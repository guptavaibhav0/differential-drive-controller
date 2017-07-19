%% Load Variables
Variables;
    
%% Path Generation
traj = generateTrajEllipse( 1000 , 600, 2*pi/180 , 180);

%% Main Code
sim('Controller');
time = q_c.time;
q_c = q_c.signals.values;
q_d = q_d.signals.values;
eta_d = eta_d.signals.values;
eta_c = eta_c.signals.values;
eta_dot_c = eta_dot_d.signals.values;
eta = eta.signals.values;
torque = torque.signals.values;

%% Plot Graphs
Plotter;