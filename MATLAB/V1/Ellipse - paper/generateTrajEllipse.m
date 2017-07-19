function [traj] = generateTrajEllipse( a , b, freq , tMax)
%% Symbolic Path
syms t;
x = a * cos(freq * t);
y = b * sin(freq * t);

x_dot = diff(x);
y_dot = diff(y);

x_ddot = diff(x,2);
y_ddot = diff(y,2);

theta = atan2(y_dot, x_dot);

v = sqrt(x_dot^2 + y_dot^2);

omega = (y_ddot * x_dot - x_ddot * y_dot) / v^2;

omega_dot = diff(omega);
v_dot = diff(v);


%% Numerical Data
time = 0.01*(0:tMax*100)';

x = double(subs(x, time));
y = double(subs(y, time));
theta = double(subs(theta, time));
v = double(subs(v, time));
omega = double(subs(omega, time));
v_dot = double(subs(v_dot, time));
omega_dot = double(subs(omega_dot, time));

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