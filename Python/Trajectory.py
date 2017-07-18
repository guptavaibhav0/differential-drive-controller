from numpy import genfromtxt
traj_data = genfromtxt('traj.csv', delimiter=',')

timeArray = traj_data.transpose()[0,]
    
def getTrajectory(time):
    l = len(timeArray)
    for i in range(l):
        if (time < i):
            break
    i = i if i < len(timeArray) else (len(timeArray) - 1)
    X_d = traj_data[i, 1]
    Y_d = traj_data[i, 2]
    theta_d = traj_data[i, 3]
    v_d = traj_data[i, 4]
    omega_d = traj_data[i, 5]
    v_dot_d = traj_data[i, 6]
    omega_dot_d = traj_data[i, 7]

    return(X_d, Y_d, theta_d, v_d, omega_d, v_dot_d, omega_dot_d)
