function [traj] = generateTrajScript()
%% Path Generation
sim('generateTraj');

%% Numerical Data
time = x.time;
x = x.signals.values;
y = y.signals.values;
theta = theta.signals.values;
v = v.signals.values;
omega = omega.signals.values;
v_dot = v_dot.signals.values;
omega_dot = omega_dot.signals.values;

%% CSV Genertaion
trajArray=[time,x,y,theta,v,omega,v_dot,omega_dot];
csvwrite('traj-circle.csv',trajArray)

%% TimeSeries
x = timeseries(x,time);
y = timeseries(y,time);
theta = timeseries(theta,time);
v = timeseries(v,time);
omega = timeseries(omega,time);
v_dot = timeseries(v_dot,time);
omega_dot = timeseries(omega_dot,time);

%% Simulink Dataset
traj = Simulink.SimulationData.Dataset;
traj = traj.addElement(x,'x_signal');
traj = traj.addElement(y,'y_signal');
traj = traj.addElement(theta,'theta_signal');
traj = traj.addElement(v,'v_signal');
traj = traj.addElement(omega,'omega_signal');
traj = traj.addElement(v_dot,'v_dot_signal');
traj = traj.addElement(omega_dot,'omega_dot_signal');

end