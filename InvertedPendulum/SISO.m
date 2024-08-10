


clear
close all
clc

%% state feedback
s = tf('s');
A = [-1.8 -2.8 -2;1 0 0; 0 1 0];
B = [1; 0; 0];
C = [0 1 1];
D = 0;

%% controbility check
M_r = ctrb(A, B);
rho = rank(M_r)
sys_x = ss(A, B, eye(3), 0);

r = 1/s;

%% performace
s_hat = 0;
t_s1 = 1.5;

zeta = 1.5;
w_n = 1.25*log(1/0.01)/(zeta*t_s1);

%% poles define
l_1 = -zeta*w_n+1j*w_n*sqrt(1-zeta^2);
l_2 = -zeta*w_n-1j*w_n*sqrt(1-zeta^2);
l_3 = -20*w_n*zeta;
l_4 = l_3;

l_des = [l_1, l_2, l_3, l_4];

%% augment system 
A_aug = [0 -C; eye(3, 1) A];
B_aug = [0; B];
C_aug = [0 C];
D_aug = D;

K = acker(A_aug, B_aug, l_des);

k_q = K(1);
k_x = K(2:end);

%% simulation
t_sim = 20;

out = sim("SISO_slx");

%% plot
figure(1)
hold on
plot(out.r.time, out.r.data, "k", "LineWidth",1.5)
plot(out.e.time, out.e.data, "r", "LineWidth",1.5)
plot(out.y.time, out.y.data, "b", "LineWidth",1.5)
legend('reference','error','output')
zoom on, grid on;

figure(2)
hold on
plot(out.x.time, out.x.data, "k", "LineWidth",1.5)
legend('state')
zoom on, grid on;

figure(3)
hold on
plot(out.u.time, out.u.data, "k", "LineWidth",1.5)
legend('input')
zoom on, grid on;

figure(4)
hold on
plot(out.f.time, out.f.data, "k", "LineWidth",1.5)
legend('feadback')
zoom on, grid on;






