%% (Display & store) or (store only)
toDisplay = 0;
toPrint = 1;

%% Basic Params
width = 150;
height = 100;
fontSize = 22;

%% Path Tracking
epsFile = 'Figs\path-tracking-sq.eps';
tiffFile = 'Figs\path-tracking-sq.tiff';
xLabel = 'X-displacement (in m)';
yLabel = 'Y-displacement (in m)';
Title = 'Path tracked by the robot';
Legend = {'Actual Path','Desired Path'};
legendLocation = 'eastoutside';
Axis = [-0.6 0.6 -0.6 0.6];

xTicks = Axis(1):(Axis(2)-Axis(1))/12:Axis(2);
yTicks = Axis(3):(Axis(4)-Axis(3))/12:Axis(4);

figure('Units','centimeters',...
    'Position',[0 0 width height],...
    'PaperPositionMode','auto');

plot(q_c(:,1)*1e-3,q_c(:,2)*1e-3,'g-',...
    'LineWidth',2.0);
hold on;
plot(q_d(:,1)*1e-3,q_d(:,2)*1e-3,'k--',...
    'LineWidth',1.0);

grid on;
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

%% Velocity Tracking
epsFile = 'Figs\velocity-tracking-sq.eps';
tiffFile = 'Figs\velocity-tracking-sq.tiff';
xLabel = 'Time (in sec)';
yLabel = {'Linear velocity (in m/sec)','Angular velocity (in rad/sec)'};
Title = 'Linear and angular velocity profile';
Legend = {'Linear velocity profile ($v$)','Angular velocity profile ($\omega$)'};
legendLocation = 'northeast';
Axis = [0 340 -0.05 0.2];

xTicks = Axis(1):(Axis(2)-Axis(1))/17:Axis(2);
yTicks = Axis(3):(Axis(4)-Axis(3))/5:Axis(4);

figure('Units','centimeters',...
    'Position',[0 0 width height],...
    'PaperPositionMode','auto');

plot(time, eta_c(:,1)*1e-3,'g-',...
    'LineWidth',2.0);
hold on;
plot(time, eta_c(:,2),'k--',...
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
epsFile = 'Figs\positional-error-sq.eps';
tiffFile = 'Figs\positional-error-sq.tiff';
xLabel = 'Time (in sec)';
yLabel = 'Positional Error (in m)';
Title = 'Error in robot position';
Legend = {'Error in abscissa ($X_{e}$)','Error in ordinate ($Y_{e}$)'};
legendLocation = 'northeast';
Axis = [0 340 -0.02 0.1];

xTicks = Axis(1):(Axis(2)-Axis(1))/17:Axis(2);
yTicks = Axis(3):(Axis(4)-Axis(3))/12:Axis(4);

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
epsFile = 'Figs\required-torque-sq.eps';
tiffFile = 'Figs\required-torque-sq.tiff';
xLabel = 'Time (in sec)';
yLabel = 'Torque (in N-mm)';
Title = 'Torque applied by the motors';
Legend = {'$Motor_{1}$','$Motor_{2}$'};
legendLocation = 'northeast';
Axis = [0 340 -0.5 0.5];

xTicks = Axis(1):(Axis(2)-Axis(1))/17:Axis(2);
yTicks = Axis(3):(Axis(4)-Axis(3))/10:Axis(4);

figure('Units','centimeters',...
    'Position',[0 0 width height],...
    'PaperPositionMode','auto');

a = tsmovavg(torque(:,1)*1e-3,'e',30,1);
b = tsmovavg(torque(:,2)*1e-3,'e',30,1);

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