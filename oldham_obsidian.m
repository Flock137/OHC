% Cureently an Elliptical Trammel Simulation

AP = 5;         % distance from x-slider to point P
BP = 3;         % distance from y-slider to point P
T  = 10;        % time for one full revolution (seconds)
N  = 500;       % number of frames per cycle

% precompute the ellipse coordinates
t     = linspace(0, T, N);
omega = 2*pi/T; 
theta = omega*t;
x     = AP*cos(theta);
y     = BP*sin(theta);

% set up figure and capture its handle
fig = figure('Color','w');
axis equal
axis([-AP*1.2 AP*1.2 -BP*1.2 BP*1.2])
hold on
grid on

% draw the tracks and “ghost” ellipse
plot([-AP*1.1 AP*1.1],[0 0],'k-','LineWidth',1.5)
plot([0 0],[-BP*1.1 BP*1.1],'k-','LineWidth',1.5)
%plot(x, y, '--','Color',[.7 .7 .7])

% initialize the sliders and pen-point
hBlockX = plot(x(1), 0, 'o','MarkerSize',20,'MarkerFaceColor','b');
hBlockY = plot(0, y(1), 'o','MarkerSize',20,'MarkerFaceColor','r');
%hPoint  = plot(x(1), y(1), 'o','MarkerSize',8,'MarkerFaceColor','g');

% animate in a wrap-around loop until the figure is closed
k = 1;
while ishandle(fig)
    set(hBlockX, 'XData', x(k), 'YData', 0);
    set(hBlockY, 'XData', 0,    'YData', y(k));
    %set(hPoint,  'XData', x(k), 'YData', y(k));
    drawnow            % process events & update
    k = k + 1;
    if k > N
        k = 1;         % wrap index back to start
    end
end
