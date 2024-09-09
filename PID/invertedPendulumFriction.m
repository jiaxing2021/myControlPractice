

clear
close all
clc

%% system define

M = 10; % kg
m = 10; % kg
l = 5; % m
I = ((m*2*l)^2)/12; % pendulum inertia
g = 9.8;

b = 0.1;    % damping coefficient (friction)

%% linearized system
a22 = -(m*l^2+I)*b/(I*(M+m)+M*m*l^2);
a23 = m^2*l^2*g/(I*(M+m)+M*m*l^2);
a42 = -(m*l*b)/(I*(M+m)+M*m*l^2);
a43 = m*l*g*(M+m)/(I*(M+m)+M*m*l^2);

A = [0 1 0 0;
    0 0 a23 0;
    0 0 0 1;
    0 0 a43 0]; 

b21 = (m*l^2+I)/(I*(M+m)+M*m*l^2);
b41 = (m*l)/(I*(M+m)+M*m*l^2);
B = [0; b21; 0; b41];

C = [-1 0 0 0;
    0 0 1 0];
D = [0; 0];

% C = [0 0 1 0];
% D = 0;

sys = ss(A, B, C, D);
sys_tf = tf(sys);

%% Separate transfer functions for cart position and pendulum angle

sys_cart = sys_tf(1);    % Transfer function from force to cart position
sys_pend = sys_tf(2);  % Transfer function from force to pendulum angle

%% pid controller for pendulum angle
% negative value for stabilization
Kp_angle = -400;
Ki_angle = -50;
Kd_angle = -90; 

pid_angle = pid(Kp_angle, Ki_angle, Kd_angle);

sys_angle = feedback(pid_angle * sys_pend, 1);


%% pid controller for cart position

Kp_postion = 400;    % Proportional gain
Ki_postion = 50;      % Integral gain
Kd_postion = 90;     % Derivative gain

pid_position = pid(Kp_postion, Ki_postion, Kd_postion);

sys_position = feedback(pid_position * sys_cart, 1);

%% closed loop system

sys_closed = feedback(pid_position*pid_angle, 1);

%% step input and initial condition
t = 0:0.01:500; 
step_input = ones(size(t));
x0 = [0; 0; pi/6; 0]; 

%% simulation
sys_closed = ss(sys_closed);

[yOut,tOut, xOut] = initial(sys_closed, x0, t);

figure('Name','position')
hold on, grid on
plot(tOut, xOut(:,1), "LineWidth",1.5)
plot(tOut, xOut(:,3), "LineWidth",1.5)
legend("x1(position)","x2(angle)")

% animation
y = [xOut(:,1), xOut(:,3)];
% animation(1, y, t)





