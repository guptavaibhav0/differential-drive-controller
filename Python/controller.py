import math
import numpy as np 

# OUTER CONTROLLER
# Calculates the tracking control input u umath.sing the control law and the constants K_x, K_y and K_theta

def OC(eta_d, Q_e, Q, K_x, K_y, K_theta):
	th = Q[2]
	Rot = np.array([(math.cos(th), math.sin(th), 0), (-math.sin(th), math.cos(th), 0), (0,0,1)])
	q_e = np.dot(Rot,Q_e)
	u = np.array([
		eta_d[0] * math.cos(q_e[2]) + K_x * q_e[0] ,
		eta_d[1] + eta_d[0] * ( K_y * q_e[1] + K_theta * math.sin(q_e[2]))])
	return u

# INNER CONTROLLER
# Usual PID control on error in eta (i.e. the u-eta)

def IC(eta_dot_d, eta_e, eta_e_old, eta_e_integral, timeStep, K_eta, K_eta_d, K_eta_i):
	eta_e_dot = (eta_e - eta_e_old) / timeStep

	eta_e_integral += eta_e * timeStep

	v = eta_dot_d + np.dot(K_eta, eta_e) + np.dot(K_eta_d, eta_e_dot) + np.dot(K_eta_i, eta_e_integral)
	return v

# NON-LINEAR COMPENSATOR
# Standard Inverse Dynamics Control. First all the dynamic parameter matrices (M_matrix, V_matrix, B_matrix) are calculated and then the torque to motors is calculated according to the dynamic equation    
def NLC(Q, eta, v, M, M_bar, k, I, L, R, R_R, R_L):
	th = Q[2]
	sth = math.sin(th)
	cth = math.cos(th)
	dth = eta[1]
	csth = math.cos(th)*math.sin(th)
	
	M_matrix = np.array([(M+k*cth**2 , k*csth , M_bar*cth) , ( k*csth , M+k*sth**2  , M_bar*sth) , (M_bar*cth , M_bar*sth , I )])
	V_matrix = np.array([(-k*dth*csth , -k*dth*sth**2  , -M_bar*dth*sth) , (k*dth*cth**2 , k*dth*csth , M_bar*dth*cth) , (-dth*sth , dth*cth , 0 )])
	B_matrix = np.array([(cth/R_L , cth/R_R) , (sth/R_L , sth/R_R) , (-L/R_L , R/R_R)])
	
	S = np.array([(cth , 0.0) , (sth , 0.0) , (0.0 , 1.0)])
	S_dot = np.array([(-sth*dth , 0.0) , (cth*dth , 0.0) , (0.0 , 0.0)])

	coeff_matrix = np.dot(np.transpose(S),B_matrix)
	c_arr = np.dot(np.dot(np.dot(np.transpose(S),M_matrix),S),v) + np.dot(np.dot(np.dot(np.transpose(S),M_matrix),S_dot),eta) + np.dot(np.dot(np.dot(np.transpose(S),V_matrix),S),eta)
	torque = np.linalg.solve(coeff_matrix, c_arr)

	return torque
