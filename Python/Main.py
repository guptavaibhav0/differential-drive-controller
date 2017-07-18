from multiprocessing import Process, Value, Array

from MPU6050 import MPU6050
from Sabertooth import Sabertooth
from RotaryEncoder import RotaryEncoder
from controller import OC, IC, NLC
from Motor import getMotorVoltage, getMotorCharacteristics
from Trajectory import getTrajectory

import smbus
import math
import serial
from RPi import GPIO
import threading
import numpy as np
from queue import Queue
import time
import signal
import sys

#------------ Robot Parameters -----------
# Basic Parameters
H = 115.0
L = 107.8
R = 107.8
R_L = 50.0
R_R = 50.0
R_3 = 50.0
d_xc = 25.79
d_yc = 0
m_p = 0.75
m_L = 1.15
m_R = 1.15
m_3 = 0.55
I_p = 6428.68
I_L = 351.882
I_R = 351.882
I_3 = 653.657
I_wL = 628.378
I_wR = 628.378
I_w3 = 628.378

# Calclulated Constants (for Simplification of M,B,V,A,S expressions)

M = m_p + m_L + m_R + m_3
M_bar = m_R*R - m_L*L - m_p*d_yc - L*I_wL/(R_L**2) + R*I_wR/(R_R**2)
I = I_p + I_R + I_L + I_3 + m_p*(d_xc**2 + d_yc**2) + m_3*H**2 + L**2*I_wL/R_L**2 + R**2*I_wR/R_R**2
k = I_wL/R_L**2 + I_wR/R_R**2 + I_w3/R_3**2

# Controller Parameters
K_x = 10
K_theta = 0.016
K_y = 0.000064

K_eta = 1.732 * np.array([(1,0),(0,1)])
K_eta_d = 0.5 * np.array([(1,0),(0,1)])
K_eta_i = 0.5 * np.array([(1,0),(0,1)])

eta_e_max = 1000

# Motor Directions
motor1_dir = -1
motor2_dir = 1
#------------ Shared Resources -----------
X = 0.0
Y = 0.0
theta = 0.0

v = 0.0
omega = 0.0

v_dot = 0.0
omega_dot = 0.0

encoder_ticks = 0

#queue = Queue()
#event = threading.Event()

state = True
gyro_calibrated = False
#enc_calibrated = False

#----------------- Gyro ------------------
gyro_bus = smbus.SMBus(1)
gyro_address = 0x68

def gyro_update():
    global X
    global Y
    global theta
    global v
    global omega
    global v_dot
    global omega_dot
    global gyro_calibrated
    gyro_offset = 0
    accel_offset = 0
    for i in range(1000):
        gyro_offset += gyro.getX()
        accel_offset += gyro.getXaccel()
    gyro_offset /= 1000
    accel_offset /= 1000
    gyro_calibrated = True
    print("Gyro Calibrated")
    oldTime = 0
    while (state):
        currentTime = time.time()
        if oldTime == 0:
            oldTime = currentTime
        else:
            t = (currentTime - oldTime)
            t = t if (t > 0) else 0.001         # To ensure that t is always non-zero
            oldTime = currentTime

            old_omega = omega
            omega = (gyro.getX() - gyro_offset) * (2*math.pi/180)
            theta += omega * t
            omega_dot = (omega - old_omega) / t

            v_dot = - (gyro.getYaccel() - accel_offset)
            v += v_dot * t
            X += v * t * math.sin(theta)
            Y += v * t * math.cos(theta)

gyro = MPU6050(gyro_bus, gyro_address)

#-------------- Sabertooth ---------------
serialObj = serial.Serial(
    port='/dev/ttyAMA0',
    baudrate = 9600)
sabertooth_address = 128

sabertooth = Sabertooth(sabertooth_address, serialObj) 

#---------------- Encoder ----------------
GPIO_A = 17   
GPIO_B = 27
encoder_scale = (2 * math.pi) / 2048

def encoder_counter(delta):
    queue.put(delta)
    event.set()

def encoder_update():
    global X
    global Y
    global v
    global v_dot
    global theta
    global queue
    global event
    global enc_calibrated
    enc_offset = 0
    for i in range(1000):
        enc_offset += gyro.getX()
    enc_offset /= 1000
    enc_calibrated = True
    print("Encoder Calibrated")
    localdata = threading.local()
    localdata.oldTime = 0
    while (state):
        print("Encoder running")
        localdata.currentTime = time.time()
        if localdata.oldTime == 0:
            localdata.oldTime = localdata.currentTime
        else:
            localdata.d = 0
            while not queue.empty():
                localdata.delta = queue.get()
                localdata.d += localdata.delta
            event.clear()
            
            localdata.t = (localdata.currentTime - localdata.oldTime)
            localdata.t = localdata.t if (localdata.t > 0) else 0.001         # To ensure that t is always non-zero
            localdata.oldTime = localdata.currentTime

            X += localdata.d * encoder_scale * math.cos(theta)
            Y += localdata.d * encoder_scale * math.sin(theta)
            localdata.new_v = (localdata.d * encoder_scale) / localdata.t
            v_dot = (localdata.new_v - v) / localdata.t
            v = localdata.new_v
        
#encoder = RotaryEncoder(GPIO_A, GPIO_B, callback=encoder_counter) 

#--------- Background Processes ----------
gyro_thread = threading.Thread(target=gyro_update)
#encoder_thread = threading.Thread(target=encoder_update)
gyro_thread.start()
#encoder_thread.start()

#---------------Exit Code---------------------------
def on_exit(a,b):
    print("Exiting...")
    #encoder.destroy()
    sabertooth.stop()
    state = False
    sys.exit(0)

signal.signal(signal.SIGINT, on_exit)

#------------- Controller------------------
Q_e = 0
eta_e = 0
eta_e_integral = 0

while not (state and gyro_calibrated):
    temporary_variable = 0    

baseTime = time.time()
oldTime = baseTime
while(state and gyro_calibrated):
    currentTime = time.time()
    timeStep = currentTime - oldTime
    
    if timeStep > 0:
        elapsedTime = currentTime - baseTime
        (X_d, Y_d, theta_d, v_d, omega_d, v_dot_d, omega_dot_d) = getTrajectory(elapsedTime)

        Q_d = np.array([X_d, Y_d, theta_d])
        eta_d = np.array([v_d, omega_d])
        eta_dot_d = np.array([v_dot_d, omega_dot_d])
        
        Q = np.array([X, Y, theta])
        eta = np.array([v, omega])
        eta_dot = np.array([v_dot, omega_dot])
    
        Q_e = Q_d - Q
        u_signal = OC(eta_d, Q_e, Q, K_x, K_y, K_theta)

        eta_e_old = eta_e
        eta_e = u_signal - eta
        v_signal = IC(eta_dot_d, eta_e, eta_e_old, eta_e_integral, timeStep, K_eta, K_eta_d, K_eta_i)

        torque = NLC(Q, eta, v_signal, M, M_bar, k, I, L, R, R_R, R_L)

        motor_omega = [(v - L * omega) / R_L, (v + R * omega) / R_R]
        v1 = getMotorVoltage(torque[0], motor_omega[0])
        v2 = getMotorVoltage(torque[1], motor_omega[1])

        sabertooth.motor(1, v1*motor1_dir)
        sabertooth.motor(2, v2*motor2_dir)

        #print(elapsedTime, torque[0], v1, torque[1], v2)
        
        oldTime = currentTime




    
