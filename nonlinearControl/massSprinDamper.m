

clear
close all
clc

%% system define

M = 2; beta = 0.8; K = 2;

tau = 0.01;
a1 = 2-tau*beta/M;
a2 = -1+tau*beta/M-tau^2*K/M;
b = tau^2/M;

%% initial condition

z = [1; 1]; % theta(1) = theta(2) = 1
z_dot = [0]; % theta_dot(1) = theta_dot(2) = 0

%% time evoluion

for k = 1:5998
    % T(k) = sin(0.01*k);
    T(k) = 0;
    z(k+2) = a1*z(k+1) + a2*z(k) + b*T(k);
    z_dot(k+1) = (z(k+2)-z(k+1))/tau;
end

%% plot

figure('Name',"input")
plot(T,'LineWidth',1.5)

figure('Name',"output")
plot(z,'LineWidth',1.5)

figure('Name',"theta_dot")
hold on
plot(z(1:5999),z_dot,'LineWidth',1.5)
plot(z(1),z_dot(1),'o','LineWidth',1.5)
plot(z(5999),z_dot(5999),'*','LineWidth',1.5)

