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
xLabel = 'X-displacement (in mm)';
yLabel = 'Y-displacement (in mm)';
Title = 'Path tracked by the robot';
Legend = {'Actual Path','Desired Path'};
legendLocation = 'eastoutside';
Axis = [-350 350 -650 50];

xTicks = Axis(1):(Axis(2)-Axis(1))/14:Axis(2);
yTicks = Axis(3):(Axis(4)-Axis(3))/14:Axis(4);

figure('Units','centimeters',...
    'Position',[0 0 width height],...
    'PaperPositionMode','auto');

plot(q_c(:,1),q_c(:,2),'g-',...
    'LineWidth',2.0);
hold on;
plot(q_d(:,1),q_d(:,2),'r--',...
    'LineWidth',1.0);

axis('equal');
set(gca, 'XTickLabelRotation', 90);
Plotter_anotations;
if (toPrint == 1)
     print( gcf, '-depsc2', epsFile );    
     print( gcf, '-dpng', tiffFile );
end
if (toDisplay == 1)
    pause;
end
close(gcf);

%% Linear Velocity Tracking
epsFile = 'Figs\linear-velocity-tracking.eps';
tiffFile = 'Figs\linear-velocity-tracking.tiff';
xLabel = 'Time (in sec)';
yLabel = 'Linear velocity (in mm/sec)';
Title = 'Linear velocity tracked by the robot';
Legend = {'$v$','$v_{desired}$'};
legendLocation = 'northeast';
Axis = [0 80 0 35];

xTicks = Axis(1):(Axis(2)-Axis(1))/16:Axis(2);
yTicks = Axis(3):(Axis(4)-Axis(3))/7:Axis(4);

figure('Units','centimeters',...
    'Position',[0 0 width height],...
    'PaperPositionMode','auto');

plot(time, eta_c(:,1),'g-',...
    'LineWidth',2.0);
hold on;
plot(time, eta_d(:,1),'r--',...
    'LineWidth',1.0);

Plotter_anotations;
if (toPrint == 1)
    print( gcf, '-depsc2', epsFile );
    print( gcf, '-dpng', tiffFile );
end
if (toDisplay == 1)
    pause;
end
close(gcf);

%% Angular Velocity Tracking
epsFile = 'Figs\angular-velocity-tracking.eps';
tiffFile = 'Figs\angular-velocity-tracking.tiff';
xLabel = 'Time (in sec)';
yLabel = 'Angular velocity (in rad/sec)';
Title = 'Angular velocity tracked by the robot';
Legend = {'$\omega$','$\omega_{desired}$'};
legendLocation = 'southeast';
Axis = [0 80 -0.15 0];

xTicks = Axis(1):(Axis(2)-Axis(1))/16:Axis(2);
yTicks = Axis(3):(Axis(4)-Axis(3))/10:Axis(4);

figure('Units','centimeters',...
    'Position',[0 0 width height],...
    'PaperPositionMode','auto');

plot(time, eta_c(:,2),'g-',...
    'LineWidth',2.0);
hold on;
plot(time, eta_d(:,2),'r--',...
    'LineWidth',1.0);

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
yLabel = 'Positional Error';
Title = 'Error in robot position during tracking';
Legend = {'$X_{e}$ (in mm)','$Y_{e}$ (in mm)','$\theta_{e}$ (in rad)'};
legendLocation = 'northeast';
Axis = [0 80 -5e-2 5e-2];

xTicks = Axis(1):(Axis(2)-Axis(1))/16:Axis(2);
yTicks = Axis(3):(Axis(4)-Axis(3))/10:Axis(4);

figure('Units','centimeters',...
    'Position',[0 0 width height],...
    'PaperPositionMode','auto');

e = (q_d - q_c);
plot(time, e,...
    'LineWidth',1.0);

Plotter_anotations;
if (toPrint == 1)
     print( gcf, '-depsc2', epsFile );     
     print( gcf, '-dpng', tiffFile );
end
if (toDisplay == 1)
    pause;
end
close(gcf);

%% Velocity error
epsFile = 'Figs\velocity-error.eps';
tiffFile = 'Figs\velocity-error.tiff';
xLabel = 'Time (in sec)';
yLabel = 'Error in velocities';
Title = 'Error in robot velocity during tracking';
Legend = {'$v_{e}$ (in mm/sec)','$\omega_{e}$ (in rad/sec)'};
legendLocation = 'northeast';
Axis = [0 80 -10e-3 10e-3];

xTicks = Axis(1):(Axis(2)-Axis(1))/16:Axis(2);
yTicks = Axis(3):(Axis(4)-Axis(3))/10:Axis(4);

figure('Units','centimeters',...
    'Position',[0 0 width height],...
    'PaperPositionMode','auto');

e = eta_d - eta_c;
plot(time, e,...
    'LineWidth',1.0);

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
Axis = [0 80 -0.3 0.3];

xTicks = Axis(1):(Axis(2)-Axis(1))/16:Axis(2);
yTicks = Axis(3):(Axis(4)-Axis(3))/10:Axis(4);

figure('Units','centimeters',...
    'Position',[0 0 width height],...
    'PaperPositionMode','auto');

plot(time, torque*1e-3,...
    'LineWidth',1.0);

Plotter_anotations;
if (toPrint == 1)
     print( gcf, '-depsc2', epsFile );     
     print( gcf, '-dpng', tiffFile );
end
if (toDisplay == 1)
    pause;
end
close(gcf);