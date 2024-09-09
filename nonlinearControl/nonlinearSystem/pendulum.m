

clear
close all
clc

%% system define
m = 1; l = 0.8; J = m*l^2; K = 9.8*m*l;
% beta = 0;
beta = 0.6; % friction coefficient
tau = 0.01; % time inteval
a1 = 2-tau*beta/J;
a2 = -1+tau*beta/J;
a3 = -tau^2*K/J;
b = tau^2/J;

%% initial condition

theta = [pi/4; pi/4]; % theta(1) = theta(2) = pi/4
theta_dot = [0]; % theta_dot(1) = theta_dot(2) = 0

%% time evoluion

for k = 1:1998
    % T(k) = sin(0.01*k);
    T(k) = 0;
    theta(k+2) = a1*theta(k+1) + a2*theta(k) + a3*sin(theta(k)) + b*T(k);
    theta_dot(k+1) = (theta(k+2)-theta(k+1))/tau;
end

%% plot

figure('Name',"input")
plot(T,'LineWidth',1.5)

figure('Name',"output")
plot(theta,'LineWidth',1.5)

figure('Name',"theta_dot")
hold on
plot(theta(1:1999),theta_dot,'LineWidth',1.5)
plot(theta(1),theta_dot(1),'o','LineWidth',1.5)
plot(theta(1999),theta_dot(1999),'*','LineWidth',1.5)


return
%% simulink

t_sim = 10;
out = sim("pendulum_sim.slx");

figure('Name',"input")
plot(out.T,'LineWidth',1.5)

figure('Name',"output")
plot(out.theta,'LineWidth',1.5)

figure('Name',"theta_dot")
% plot(out.theta_dot,out.theta,'LineWidth',1.5)
plot(out.theta.data,out.theta_dot.data,'LineWidth',1.5)


