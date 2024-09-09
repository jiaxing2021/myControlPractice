

clear
close all
clc

%% system define
syms x [3 1] real 
syms u real
syms v

R = 0.1; alpha = 10.4; beta = 16.5;
rho = -1.16*x(1) + 0.041*x(1)^3;
xd = [alpha*(x(2)-x(1)-rho);
    x(1)-x(2)+x(3)+u;
    -beta*x(2)-R*x(3)];

y = x(1);

% rhod = (diff(rho,x(1)))
rhod = (123*x(1)^2)/1000 - 29/25;

%% feedback linearization
% y = x(1);
% yd = alpha*(x(2)-x(1)-rho);
% ydd = alpha*(x(1)-x(2)+x(3)+u-alpha*(x(2)-x(1)-rho)*(1+rhod));
% v = ydd;
u = v/alpha - (x(1)-x(2)+x(3)-alpha*(x(2)-x(1)-rho)*(1+rhod));
mu = [x(1); alpha*(x(2)-x(1)-rho)];
gama = 2;

%% linear controller
A = [0 1;
    0 0];
B = [0;1];
l_des = [-1 -2];

K = place(A, B, l_des);

%% simulation

t_sim = 100;
% out = sim("chua_sim.slx");
out = sim("chuaTracking_sim.slx");


figure('Name',"state")
hold on, grid on
plot(out.x.time, out.x.data, "LineWidth",1.5)
legend("x(1)","x(2)","x(3)")


figure('Name',"ref&output")
hold on, grid on
plot(out.y.time, out.y.data, "LineWidth",1.5)
plot(out.r.time, out.r.data, "LineWidth",1.5)
legend("y","r")


% figure('Name',"error")
% hold on, grid on
% plot(out.e1.time, out.e1.data, "LineWidth",1.5)
% plot(out.e2.time, out.e2.data, "LineWidth",1.5)

% figure('Name',"input(v)")
% plot(out.v.time, out.v.data, "LineWidth",1.5)
% figure('Name',"input(u)")
% plot(out.u.time, out.u.data, "LineWidth",1.5)








