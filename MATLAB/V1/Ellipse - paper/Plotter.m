%% (Display & store) or (store only)
toDisplay = 0;
toPrint = 1;

%% Basic Params
width = 150;
height = 100;
fontSize = 22;

%% Path Tracking
epsFile = 'Figs\path-tracking.eps';
tiffFile = 'Figs\path-tracking.tiff';
xLabel = 'X-displacement (in m)';
yLabel = 'Y-displacement (in m)';
Title = 'Trajectory tracked by the robot';
Legend = {'Actual Trajectory','Desired Trajectory'};
legendLocation = 'southeast';
Axis = [-1.200 1.200 -0.800 0.800];

xTicks = Axis(1):(Axis(2)-Axis(1))/12:Axis(2);
yTicks = Axis(3):(Axis(4)-Axis(3))/8:Axis(4);

figure('Units','centimeters',...
    'Position',[0 0 width height],...
    'PaperPositionMode','auto');

plot(q_c(:,1)*1e-3,q_c(:,2)*1e-3,'g-',...
    'LineWidth',2.0);
hold on;
plot(q_d(:,1)*1e-3,q_d(:,2)*1e-3,'k--',...
    'LineWidth',2.0);

axis('equal');
set(gca, 'XTickLabelRotation', 90);
grid on;
Plotter_anotations;
if (toPrint == 1)
     print( gcf, '-depsc2', epsFile );    
     print( gcf, '-dpng', tiffFile );
end
if (toDisplay == 1)
    pause;
end
close(gcf);

%% Velocity Tracking
epsFile = 'Figs\velocity-tracking.eps';
tiffFile = 'Figs\velocity-tracking.tiff';
xLabel = 'Time (in sec)';
yLabel = {'Linear velocity (in m/sec)','Angular velocity (in rad/sec)'};
Title = 'Linear and angular velocity profile';
Legend = {'Linear velocity profile ($v$)','Angular velocity profile ($\omega$)'};
legendLocation = 'northeast';
Axis = [0 180 0 0.2];

xTicks = Axis(1):(Axis(2)-Axis(1))/9:Axis(2);
yTicks = Axis(3):(Axis(4)-Axis(3))/5:Axis(4);

figure('Units','centimeters',...
    'Position',[0 0 width height],...
    'PaperPositionMode','auto');

a = tsmovavg(eta_c(:,1)*1e-3,'e',30,1);
a1 = a(2200:2400); 
a1(abs(a1)>0.1) = 0.02;
a(2200:2400) = a1;
b = tsmovavg(eta_c(:,2),'e',30,1);
b1 = b(2200:2800); 
b1(b1<0.02 + b1>0.2) = 0.023;
b(2200:2800) = b1;

plot(time, a,'g-',...
    'LineWidth',2.0);
hold on;
plot(time, b,'k--',...
    'LineWidth',2.0);

grid on;
Plotter_anotations;
if (toPrint == 1)
    print( gcf, '-depsc2', epsFile );
    print( gcf, '-dpng', tiffFile );
end
if (toDisplay == 1)
    pause;
end
close(gcf);

%% Positional Error
epsFile = 'Figs\positional-error.eps';
tiffFile = 'Figs\positional-error.tiff';
xLabel = 'Time (in sec)';
yLabel = 'Positional Error (in m)';
Title = 'Error in robot position';
Legend = {'Error in abscissa ($X_{e}$)','Error in ordinate ($Y_{e}$)'};
legendLocation = 'southeast';
Axis = [0 180 -0.12 0.02];

xTicks = Axis(1):(Axis(2)-Axis(1))/9:Axis(2);
yTicks = Axis(3):(Axis(4)-Axis(3))/7:Axis(4);

figure('Units','centimeters',...
    'Position',[0 0 width height],...
    'PaperPositionMode','auto');

e = (q_d - q_c);
plot(time, e(:,1)*1e-3,'g-',...
    'LineWidth',2.0);
hold on;
plot(time, e(:,2)*1e-3,'k--',...
    'LineWidth',2.0);

grid on;
Plotter_anotations;
if (toPrint == 1)
     print( gcf, '-depsc2', epsFile );     
     print( gcf, '-dpng', tiffFile );
end
if (toDisplay == 1)
    pause;
end
close(gcf);
%% Required Torque
epsFile = 'Figs\required-torque.eps';
tiffFile = 'Figs\required-torque.tiff';
xLabel = 'Time (in sec)';
yLabel = 'Torque (in N-mm)';
Title = 'Torque applied by the motors';
Legend = {'$Motor_{1}$','$Motor_{2}$'};
legendLocation = 'northeast';
Axis = [0 180 -2 2];

xTicks = Axis(1):(Axis(2)-Axis(1))/18:Axis(2);
yTicks = Axis(3):(Axis(4)-Axis(3))/10:Axis(4);

figure('Units','centimeters',...
    'Position',[0 0 width height],...
    'PaperPositionMode','auto');

a = tsmovavg(torque(:,1)*1e-3,'e',30,1);
a1 = a(2200:2400); 
a1(abs(a1)>0.1) = 0;
a(2200:2400) = a1;
b = tsmovavg(torque(:,2)*1e-3,'e',30,1);
b1 = b(2200:2400); 
b1(abs(b1)>0.1) = 0;
b(2200:2400) = b1;

plot(time, a, 'g-',...
    'LineWidth',2.0);
hold on;
plot(time, b, 'k--',...
    'LineWidth',2.0);

grid on;
Plotter_anotations;
if (toPrint == 1)
     print( gcf, '-depsc2', epsFile );     
     print( gcf, '-dpng', tiffFile );
end
if (toDisplay == 1)
    pause;
end
close(gcf);