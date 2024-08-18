

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

t = 0:0.1:80;
ref = 2;
step_input = ref*ones(size(t));

[y,t] = lsim(sys_c, step_input, t);
figure('Name','step signal response')
hold on, grid on
plot(t,y,"LineWidth",1.5)
plot(t,step_input,"LineWidth",1.5)
legend("output1(position)","output2(theta)","reference") 

% animation
% animation(3,y, t)

%% PID controller with simulink
Kp = 50;
Ki = 30;
Kd = 10;

t_sim = 80;

out = sim("invertedPendulum_sim.slx");

figure('Name','step signal response(PID)')
hold on, grid on
plot(out.y.Time, out.y.Data, "LineWidth",1.5)
plot(out.r.Time, out.r.Data, "LineWidth",1.5)
legend("output1(position)","output2(theta)","reference") 

% animation
% animation(3,out.y.Data, out.y.Time)





