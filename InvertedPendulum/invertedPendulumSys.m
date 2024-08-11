

clear
close all
clc

%% parameters define
M = 10; % kg
m = 2; % kg
l = 0.5; % m
I = ((m*2*l)^2)/12; % pendulum inertia
g = 9.8;

% x = [x, xd, theta, thetad]
% y = [x, theta]
%% linearized system
x0 = [0; 0; 0; 0];
a23 = -m^2*l^2*g/(I*(M+m)+M*m*l^2);
a43 = m*l*g*(M+m)/(I*(M+m)+M*m*l^2);
A = [0 1 0 0;
    0 0 a23 0;
    0 0 0 1;
    0 0 a43 0]; 

b21 = (m*l^2+I)/(I*(M+m)+M*m*l^2);
b41 = -(m*l)/(I*(M+m)+M*m*l^2);
B = [0; b21; 0; b41];

C = [-1 0 0 0;
    0 0 1 0];

D = [0; 0];

sys_x = ss(A, B, eye(4,4), zeros(4,1));
%% stability check
eig_A = eig(A);

%% reachability check
Co = ctrb(A,B);
rho_Co = rank(Co);

%% observabilty check
Mo = obsv(A,C);
rho_Mo = rank(Mo);

%% system simulation
sys = ss(A, B, C, D);
% [yOut,tOut] = step(sys);
% animation(l,yOut, tOut)
% 
% return

%% full states feadback control
des = [-1 -1 -1 -1];
K = acker(A,B,des);
A_c = A-B*K;
B_c = B;
C_c = C;
D_c = D;

sys_c = ss(A_c, B_c, C_c, D_c);
% step(sys_c);
% animation
% [yOut,tOut] = step(sys_c);
% animation(l,yOut, tOut)


%% full states feadback control with integral
% doesn't work

A_aug = [zeros(2,2) -C;zeros(4,2) A];
B_aug = [0; 0; B];

% reachability check
Co = ctrb(A_aug,B_aug);
rho_Co = rank(Co); % full states feadback control with integral doesn't work

% des = [-1 -1 -1 -1 -2 -2]; % two more roots for intrgrator
% K_aug = acker(A_aug,B_aug,des);
% K_q = K_aug(1:2);
% K_x = K_aug(3:end);

K_x = K;
K_q = [-1, -10];

% simulation
t_sim = 20;
out = sim("fullStateFeadbackWithIntegrator");

figure()
hold on
plot(out.y1.time, out.y1.data, "g", "LineWidth",1.5)
plot(out.y2.time, out.y2.data, "b", "LineWidth",1.5)
% legend('position','angle')
zoom on, grid on;


%% full states feedback control with state observer





