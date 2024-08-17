

clear
close all
clc

%% syetem define
syms x [3 1] real 
syms u real
syms v

R = 0.1; alpha = 10.4; beta = 16.5;
rho = -1.16*x(1) + 0.041*x(1)^3;
rho_hat = -1.194*x(1) + 0.0422*x(1)^3;
xd = [alpha*(x(2)-x(1)-rho_hat);
    x(1)-x(2)+x(3)+u;
    -beta*x(2)-R*x(3)];

y = x(1);

% rho_hatd = simplify(diff(rho_hat,x(1)));
rhod = (123*x(1)^2)/1000 - 29/25;
rho_hatd = (633*x1^2)/5000 - 597/500;

%% feedback linearization
% y = x(1);
% yd = alpha*(x(2)-x(1)-rho);
% ydd = alpha*(x(1)-x(2)+x(3)+u-alpha*(x(2)-x(1)-rho)*(1+rhod));
% v = ydd;
u = v/alpha - (x(1)-x(2)+x(3)-alpha*(x(2)-x(1)-rho)*(1+rho_hatd));
mu = [x(1); alpha*(x(2)-x(1)-rho_hat)];
gama = 2;

%% simulation
% compraring between feedback linearization and sliding mode control
% according to the staty state error
% SMC is more robust than feedback linearization against uncertainty


ref = 1;
t_sim = 100;

out = sim("chuaSMC_sim.slx");


% figure('Name',"states")
% hold on, grid on
% plot(out.x1.time, out.x1.data(:,1), "LineWidth",1.5)
% plot(out.x.time, out.x.data(:,2), "LineWidth",1.5)
% plot(out.x.time, out.x.data(:,3), "LineWidth",1.5)
% legend("x(1)","x(2)","x(3)")


figure('Name',"ref&output")
hold on, grid on
plot(out.y1.time, out.y1.data, "LineWidth",1.5)
plot(out.y2.time, out.y2.data, "LineWidth",1.5)
plot(out.r.time, out.r.data, "LineWidth",1.5)
legend("y_{SMC}","y_{FL}","r")

