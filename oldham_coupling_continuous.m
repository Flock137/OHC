% Continuous Oldham Coupling Simulation - Runs until window is closed

function oldham_coupling_continuous()
%% Parameters
rpm = 300;                  % Rotational speed (revolutions per minute)
omega = rpm * 2*pi/60;      % Angular velocity (rad/s)
offset = 0.015;             % Parallel misalignment between shafts (m)
phase_diff = pi/2;          % Phase difference between disks (π/2)

% Coupling parameters
R = 0.05;                   % Coupling radius (m)

% Time parameters
dt = 0.001;                 % Time step (s)
t = 0;                      % Start time


%% Run indefinitely until termination
fig = figure('Color', 'white', 'Position', [100, 100, 1200, 800], ...
    'CloseRequestFcn', @closeFigure);
running = true;

    function closeFigure(~,~)
        running = false;
        delete(fig);
    end


%% Initialize plots
subplot(2,2,[1,3]);
hold on; axis equal; grid on;
title('Continuous Oldham Coupling Simulation');
xlim([-2*R-offset, 2*R+offset]);
ylim([-2*R-offset, 2*R+offset]);

%% Initialize trajectory lines
traj1 = plot(0, 0, 'r:', 'LineWidth', 1);
traj2 = plot(0, 0, 'b-', 'LineWidth', 1);
traj3 = plot(0, 0, 'g:', 'LineWidth', 1);

%% Plot shape and position initialization
% Initialize disks shape and position
disk1 = rectangle('Position', [0,0,R,R], 'Curvature', [1,1], ...
    'FaceColor', [1, 0.8, 0.8], 'EdgeColor', 'r', 'LineWidth', 3);
disk2 = rectangle('Position', [0,0,R,R], 'Curvature', [1,1], ...
    'FaceColor', [0.8, 0.8, 0.8], 'EdgeColor', 'k', 'LineWidth', 2);
disk3 = rectangle('Position', [0,0,R,R], 'Curvature', [1,1], ...
    'FaceColor', [0.8, 1, 0.8], 'EdgeColor', 'g', 'LineWidth', 3);

% Initialize cross slots for middle disk (second flange)
slot1 = plot([0,0], [0,0], 'k-', 'LineWidth', 2);
slot2 = plot([0,0], [0,0], 'k-', 'LineWidth', 2);

% Initialize time text
timeText = text(-2*R-offset, 2*R+offset, 'Time: 0.000 s', 'FontSize', 12);

%% Initialize graphs
% Initialize angular position plit
subplot(2,2,2);
anglePlot = plot(0, 0, 'r-', 0, 0, 'g-');
xlabel('Time (s)'); ylabel('Angle (rad)');
title('Disk Angular Positions');
legend('Disk 1 (Red)', 'Disk 3 (Green)');
grid on;

% Initialize velocity plot
subplot(2,2,4);
velPlot = plot(0, 0, 'b-');
xlabel('Time (s)'); ylabel('Velocity (m/s)');
title('Velocity Magnitude (dω)');
grid on;

%% Main simulation loop

% Arrays initialization
x1_data = [];
y1_data = [];
x2_data = [];
y2_data = [];
x3_data = [];
y3_data = [];
time_data = [];

while running
    %% Update time
    t = t + dt;

    %% Calculate current positions
    current_theta = omega * t;

    %{
    There was only current_theta as input, theoretically, this should be correct, however,
    In practice, it wasnt
    So the phase shift is pi, instead
    %}
    x1 = offset*cos(current_theta - pi/2); %reminder: phase_diff = pi/2
    y1 = offset*sin(current_theta - pi/2);
    x2 = offset*cos(current_theta) - (offset^2)/(2*R)*cos(2*current_theta);
    y2 = offset*sin(current_theta) - (offset^2)/(2*R)*sin(2*current_theta);
    x3 = offset*cos(current_theta + phase_diff);
    y3 = offset*sin(current_theta + phase_diff);

    %% Store data for trajectories
    % And, yes, the array is looping itself
    x1_data = [x1_data, x1];
    y1_data = [y1_data, y1];
    x2_data = [x2_data, x2];
    y2_data = [y2_data, y2];
    x3_data = [x3_data, x3];
    y3_data = [y3_data, y3];
    time_data = [time_data, t];

    %% Update disk positions
    set(disk1, 'Position', [x1-R/2-offset, y1-R/2, R, R]);
    set(disk2, 'Position', [x2-R/2, y2-R/2, R, R]);
    set(disk3, 'Position', [x3-R/2+offset, y3-R/2, R, R]);

    %% Update cross slots
    set(slot1, 'XData', [x2-R*cos(current_theta), x2+R*cos(current_theta)], ...
        'YData', [y2-R*sin(current_theta), y2+R*sin(current_theta)]);
    set(slot2, 'XData', [x2-R*cos(current_theta+phase_diff), x2+R*cos(current_theta+phase_diff)], ...
        'YData', [y2-R*sin(current_theta+phase_diff), y2+R*sin(current_theta+phase_diff)]);

    %% Animation/Graph update
    % Update trajectories
    set(traj1, 'XData', x1_data, 'YData', y1_data);
    set(traj2, 'XData', x2_data, 'YData', y2_data);
    set(traj3, 'XData', x3_data, 'YData', y3_data);

    % Update time display
    set(timeText, 'String', sprintf('Time: %.3f s', t));

    % Update angle plot
    set(anglePlot(1), 'XData', time_data, 'YData', omega*time_data);
    set(anglePlot(2), 'XData', time_data, 'YData', omega*time_data + phase_diff);

    % Update velocity plot
    set(velPlot, 'XData', time_data, 'YData', 2*R*omega*ones(size(time_data)));

    % Pause to allow rendering and check for window close
    drawnow;

    % Break if figure window was closed
    if ~ishandle(fig)
        break;
    end
end
end