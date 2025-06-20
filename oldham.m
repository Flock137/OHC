% Oldham Coupling Dynamics Simulation with Three Phase-Shifted Disks
% Based on the kinematic modeling from VINUNIVERSITY presentation

clear; close all; clc;

%% Parameters
rpm = 300;                  % Rotational speed (revolutions per minute)
omega = rpm * 2*pi/60;      % Angular velocity (rad/s)
offset = 0.015;             % Parallel misalignment between shafts (m)
duration = 0.5;             % Simulation duration (s)
phase_diff = pi/2;          % Phase difference between disks (π/2 as per slides)

% Coupling parameters
R = 0.05;                   % Coupling radius (m)
d = 2*R;                    % Diameter (for velocity/acceleration formulas)

% Simulation parameters
dt = 1e-4;                  % Time step (s)
t = 0:dt:duration;          % Time vector
N = length(t);              % Number of time steps

%% Initialize Disk Positions
% All disks follow the same basic equations but with phase shifts
theta = omega * t;          % Base angle evolution

% Disk 1 (Red - Driving disk) - Vertical slot initially (phase = 0)
x1 = offset*cos(theta);
y1 = offset*sin(theta);

% Disk 2 (Gray - Middle disk) - Has both slots (average phase)
x2 = offset*cos(theta) - (offset^2)/(2*R)*cos(2*theta);
y2 = offset*sin(theta) - (offset^2)/(2*R)*sin(2*theta);

% Disk 3 (Green - Driven disk) - Horizontal slot initially (phase = π/2)
x3 = offset*cos(theta + phase_diff);
y3 = offset*sin(theta + phase_diff);

%% Calculate Velocities and Accelerations (from slides formulas)
% Velocity magnitude for all disks is d*ω (where d is offset)
v1 = d*omega;
v2 = d*omega;
v3 = d*omega;

% Angular acceleration (assumed zero for constant velocity)
alpha = 0;

% Acceleration magnitude (from slide 26)
a_mag = d*sqrt(alpha^2 + 4*omega^4);

%% Visualization
figure('Color', 'white', 'Position', [100, 100, 1200, 800]);

% Animation of the coupling motion
for i = 1:50:N
    clf;
    
    % Draw all three disks with phase-shifted positions
    subplot(2,2,[1,3]);
    hold on; axis equal; grid on;
    title('Oldham Coupling Motion with Phase-Shifted Disks');
    xlim([-2*R-offset, 2*R+offset]); 
    ylim([-2*R-offset, 2*R+offset]);
    
    % Draw shafts
    plot([-2*R, -R], [0, 0], 'r-', 'LineWidth', 2); % Input shaft
    plot([R, 2*R], [0, 0], 'g-', 'LineWidth', 2);   % Output shaft
    
    % Disk 1 (Red - Driving disk)
    rectangle('Position', [x1(i)-R/2-offset, y1(i)-R/2, R, R], ...
              'Curvature', [1,1], 'FaceColor', [1, 0.8, 0.8], ...
              'EdgeColor', 'r', 'LineWidth', 3);
    % Vertical slot (initial position)
    % plot([x1(i)-R/2*cos(0+phase_diff/2), x1(i)+R/2*cos(0+phase_diff/2)], ...
    %      [y1(i)-R/2*sin(0+phase_diff/2), y1(i)+R/2*sin(0+phase_diff/2)], ...
    %      'r-', 'LineWidth', 3);
    
    % Disk 2 (Gray - Middle disk)
    rectangle('Position', [x2(i)-R/2, y2(i)-R/2, R, R], ...
              'Curvature', [1,1], 'FaceColor', [0.8, 0.8, 0.8], ...
              'EdgeColor', 'k', 'LineWidth', 2);
    % Cross slots
    plot([x2(i)-R*cos(theta(i)), x2(i)+R*cos(theta(i))], ...
         [y2(i)-R*sin(theta(i)), y2(i)+R*sin(theta(i))], 'k-', 'LineWidth', 2);
    plot([x2(i)-R*cos(theta(i)+phase_diff), x2(i)+R*cos(theta(i)+phase_diff)], ...
         [y2(i)-R*sin(theta(i)+phase_diff), y2(i)+R*sin(theta(i)+phase_diff)], ...
         'k-', 'LineWidth', 2);
    
    % Disk 3 (Green - Driven disk)
    rectangle('Position', [x3(i)-R/2+offset, y3(i)-R/2, R, R], ...
              'Curvature', [1,1], 'FaceColor', [0.8, 1, 0.8], ...
              'EdgeColor', 'g', 'LineWidth', 3);
    % Horizontal slot (initial position)
    % plot([x3(i)-R/2*cos(phase_diff), x3(i)+R/2*cos(phase_diff)], ...
    %      [y3(i)-R/2*sin(phase_diff), y3(i)+R/2*sin(phase_diff)], ...
    %      'g-', 'LineWidth', 3);
    
    % Trajectories
    plot(x1(1:i), y1(1:i), 'r:', 'LineWidth', 1);
    plot(x2(1:i), y2(1:i), 'b-', 'LineWidth', 1);
    plot(x3(1:i), y3(1:i), 'g:', 'LineWidth', 1);
    
    % Time and parameter display
    text(-2*R-offset, 2*R+offset, sprintf('Time: %.3f s\nω: %.1f rad/s\nOffset: %.3f m', ...
         t(i), omega, offset), 'FontSize', 10);
    
    % Plot angular positions
    subplot(2,2,2);
    plot(t(1:i), theta(1:i), 'r-', t(1:i), theta(1:i)+phase_diff, 'g-');
    xlabel('Time (s)'); ylabel('Angle (rad)');
    title('Disk Angular Positions');
    legend('Disk 1 (Red)', 'Disk 3 (Green)');
    grid on;
    
    % Plot velocity and acceleration
    subplot(2,2,4);
    yyaxis left;
    plot(t(1:i), repmat(v1,1,i), 'b-');
    ylabel('Velocity (m/s)');
    yyaxis right;
    plot(t(1:i), repmat(a_mag,1,i), 'r-');
    ylabel('Acceleration (m/s²)');
    title('Velocity and Acceleration Magnitude');
    grid on;
    
    drawnow;
end

%% Additional Analysis
% Calculate relative motions
rel_x = x3 - x1;
rel_y = y3 - y1;

figure('Color', 'white');
subplot(2,1,1);
plot(t, rel_x, 'b-', t, rel_y, 'r-');
xlabel('Time (s)'); ylabel('Displacement (m)');
title('Relative Motion Between Disks 1 and 3');
legend('X direction', 'Y direction');
grid on;

subplot(2,1,2);
plot(t, sqrt(rel_x.^2 + rel_y.^2), 'k-');
xlabel('Time (s)'); ylabel('Distance (m)');
title('Distance Between Disks 1 and 3');
grid on;