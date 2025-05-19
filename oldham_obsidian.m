clear; close all; clc;

function oldham_obsidian()
% Parameters
phase_diff = pi/2;       % 90° phase difference between disks
omega = 2;               % Angular velocity (rad/s)
AP = 0.05;               % Length AP (semi-major axis)
BP = 0.03;               % Length BP (semi-minor axis)
R = 0.02;                % Wheel radius (m)
duration = 2*pi/omega;   % One full rotation
dt = 0.01;               % Time step

% Create figure
fig = figure('Color', 'white', 'Position', [100, 100, 800, 600]);
ax = axes('Parent', fig);
hold(ax, 'on');
axis(ax, 'equal');
grid(ax, 'on');
xlim(ax, [-AP-2*R, AP+2*R]);
ylim(ax, [-BP-2*R, BP+2*R]);
title(ax, 'Oldham Coupling with Elliptic Trammel Motion');

% Initialize disks (now using AP/BP for motion)
disk1 = rectangle('Position', [AP-R/2, -R/2, R, R], 'Curvature', [1,1], ...
    'FaceColor', [1,0.8,0.8], 'EdgeColor', 'r', 'LineWidth', 2);
disk2 = rectangle('Position', [-R/2, -R/2, R, R], 'Curvature', [1,1], ...
    'FaceColor', [0.8,0.8,0.8], 'EdgeColor', 'k', 'LineWidth', 2);
disk3 = rectangle('Position', [-R/2, BP-R/2, R, R], 'Curvature', [1,1], ...
    'FaceColor', [0.8,1,0.8], 'EdgeColor', 'g', 'LineWidth', 2);

% Initialize slots
slot1 = plot(ax, [0,0], [0,0], 'r-', 'LineWidth', 2); % Disk 1 vertical
slot2a = plot(ax, [0,0], [0,0], 'k-', 'LineWidth', 2); % Disk 2 horizontal
slot2b = plot(ax, [0,0], [0,0], 'k-', 'LineWidth', 2); % Disk 2 vertical
slot3 = plot(ax, [0,0], [0,0], 'g-', 'LineWidth', 2); % Disk 3 horizontal

% Animation loop
for t = 0:dt:duration
    theta = omega * t;

    % Disk 1 (Left disk - follows x = AP*cosθ)
    x1 = AP * cos(theta);
    y1 = 0; % Constrained to x-axis

    % Disk 3 (Right disk - follows y = BP*sinθ with phase shift)
    x3 = 0; % Constrained to y-axis
    y3 = BP * sin(theta + phase_diff);

    % Disk 2 (Middle disk - Oldham coupling motion)
    % Combines both motions with correction terms
    x2 = (AP/2)*cos(theta) - (AP^2)/(4*R)*cos(2*theta);
    y2 = (BP/2)*sin(theta + phase_diff) - (BP^2)/(4*R)*sin(2*(theta + phase_diff));

    % Update disk positions
    set(disk1, 'Position', [x1-R/2, y1-R/2, R, R]);
    set(disk2, 'Position', [x2-R/2, y2-R/2, R, R]);
    set(disk3, 'Position', [x3-R/2, y3-R/2, R, R]);

    % Update slots
    set(slot1, 'XData', [x1, x1], 'YData', [y1-R/2, y1+R/2]); % Disk 1 vertical
    set(slot2a, 'XData', [x2-R/2, x2+R/2], 'YData', [y2, y2]); % Disk 2 horizontal
    set(slot2b, 'XData', [x2, x2], 'YData', [y2-R/2, y2+R/2]); % Disk 2 vertical
    set(slot3, 'XData', [x3-R/2, x3+R/2], 'YData', [y3, y3]); % Disk 3 horizontal

    % Update title
    title(ax, sprintf('θ = %.2f rad\nDisk 1: (%.3f, 0)\nDisk 3: (0, %.3f)', ...
        theta, x1, y3));

    drawnow;
end
end