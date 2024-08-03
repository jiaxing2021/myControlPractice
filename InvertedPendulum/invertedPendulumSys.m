

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
[yOut,tOut] = step(sys_c);
animation(l,yOut, tOut)
% return 

%% full states feadback control with integral

%% full states feedback control with state observer





