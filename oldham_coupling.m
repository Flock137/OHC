function oldham_coupling()
%% Parameters
rpm          = 300;                  % Rotational speed (RPM)
omega        = rpm * 2*pi/60;        % Angular velocity (rad/s)
offset       = 0.015;                % Parallel misalignment (m)
phase_diff   = pi/2;                 % Phase difference (π/2)
R            = 0.05;                 % Coupling “radius” (used as diameter in drawing)

%% How far apart (total) do you want Disks 1 & 3?
centerSpacing = 0.08;                % total distance between disk-1 and disk-3 centres (m)

%% Fixed centres of Disk1 & Disk3
c1 = [-centerSpacing/2, 0];          % left  disk centre
c3 = [ centerSpacing/2, 0];          % right disk centre

%% Time setup
dt = 0.001; t = 0;

%% Figure & axes
fig = figure('Color','white','Position',[100,100,1200,800], ...
    'CloseRequestFcn',@(~,~) delete(gcbf));
ax = subplot(2,2,[1,3]);
hold(ax,'on'); axis(ax,'equal'); grid(ax,'on');
title(ax,'Continuous Oldham Coupling Simulation');
xlim(ax,[-centerSpacing, centerSpacing]);
ylim(ax,[-2*R-offset, 2*R+offset]);

%% Trajectory trace for Disk2
traj2 = plot(ax,0,0,'b-','LineWidth',1);

%% Disk1 + its transform + a radial spoke
hgt1 = hgtransform('Parent',ax);
disk1 = rectangle('Position',[c1(1)-R/2, c1(2)-R/2, R, R], ...
    'Curvature',[1,1], 'FaceColor',[1,0.8,0.8], 'EdgeColor','r','LineWidth',3,...
    'Parent',hgt1);
spoke1 = line([c1(1), c1(1)+R/2], [c1(2), c1(2)], ...
    'Color','r','LineWidth',2,'Parent',hgt1);

%% Disk2 + its two cross-slots
disk2 = rectangle('Position',[0,0,R,R],'Curvature',[1,1], ...
    'FaceColor',[0.8,0.8,0.8],'EdgeColor','k','LineWidth',2);
slot1 = plot(ax,[-R/2,R/2],[0,0],'k-','LineWidth',2);
slot2 = plot(ax,[-R/2,R/2],[0,0],'k-','LineWidth',2);

%% Disk3 + its transform + a radial spoke
hgt3 = hgtransform('Parent',ax);
disk3 = rectangle('Position',[c3(1)-R/2, c3(2)-R/2, R, R], ...
    'Curvature',[1,1], 'FaceColor',[0.8,1,0.8], 'EdgeColor','g','LineWidth',3,...
    'Parent',hgt3);
spoke3 = line([c3(1), c3(1)+R/2], [c3(2), c3(2)], ...
    'Color','g','LineWidth',2,'Parent',hgt3);

%% Time display
timeText = text(-centerSpacing, 2*R+offset, 'Time: 0.000 s', 'FontSize', 12);

%% Angle & velocity subplots
subplot(2,2,2);
anglePlot = plot(0,0,'r-', 0,0,'g-');
xlabel('Time (s)'), ylabel('Angle (rad)');
title('Disk Angular Positions');
legend('Disk 1','Disk 3'), grid on;

subplot(2,2,4);
velPlot = plot(0,0,'b-');
xlabel('Time (s)'), ylabel('Velocity (m/s)');
title('Velocity Magnitude'), grid on;

%% Data buffers
x2_data = []; y2_data = []; t_data = [];

%% Simulation loop
while ishandle(fig)
    % advance time
    t = t + dt;
    theta = omega * t;
    
    %% --- Disk2 translation & rotation (unchanged) ---
    x2 = offset*cos(theta) - (offset^2)/(2*R)*cos(2*theta);
    y2 = offset*sin(theta) - (offset^2)/(2*R)*sin(2*theta);
    set(disk2,'Position',[x2-R/2, y2-R/2, R, R]);
    set(slot1, 'XData',[x2-R/2*cos(theta), x2+R/2*cos(theta)], ...
               'YData',[y2-R/2*sin(theta), y2+R/2*sin(theta)]);
    set(slot2, 'XData',[x2-R/2*cos(theta+phase_diff), x2+R/2*cos(theta+phase_diff)], ...
               'YData',[y2-R/2*sin(theta+phase_diff), y2+R/2*sin(theta+phase_diff)]);
    
    %% --- Disk1 spin in place ---
    M1 = makehgtform( ...
        'translate',[c1,0], ...
        'zrotate', theta, ...
        'translate',[-c1,0] );
    set(hgt1,'Matrix',M1);
    
    %% --- Disk3 spin in place (with phase shift) ---
    M3 = makehgtform( ...
        'translate',[c3,0], ...
        'zrotate', theta+phase_diff, ...
        'translate',[-c3,0] );
    set(hgt3,'Matrix',M3);
    
    %% --- Update plots & text ---
    x2_data(end+1) = x2;
    y2_data(end+1) = y2;
    t_data(end+1)  = t;
    set(traj2,'XData',x2_data,'YData',y2_data);
    set(timeText,'String',sprintf('Time: %.3f s',t));
    set(anglePlot(1),'XData',t_data,'YData',omega*t_data);
    set(anglePlot(2),'XData',t_data,'YData',omega*t_data + phase_diff);
    set(velPlot,'XData',t_data,'YData',2*(R/2)*omega*ones(size(t_data)));
    
    drawnow;
end
end
