
clear
close all
clc

%% system define

 R = 3; L = 0.5; C = 0.25;

 tau = 0.01;
 a1 = 2-tau*R/L;
 a2 = R*tau/L-tau^2/(L*C)-1;
 b = tau^2/(L*C);

 %% initial condition

V = [0; 0]; % theta(1) = theta(2) = 0
V_dot = [0]; % theta_dot(1) = theta_dot(2) = 0

%% time evoluion

for k = 1:1998
    % T(k) = sin(0.01*k);
    Vs(k) = 5;
    V(k+2) = a1*V(k+1) + a2*V(k) + b*Vs(k);
    V_dot(k+1) = (V(k+2)-V(k+1))/tau;
end

%% plot

figure('Name',"input")
plot(Vs,'LineWidth',1.5)

figure('Name',"output")
plot(V,'LineWidth',1.5)

figure('Name',"theta_dot")
hold on
plot(V(1:1999),V_dot,'LineWidth',1.5)
plot(V(1),V_dot(1),'o','LineWidth',1.5)
plot(V(1999),V_dot(1999),'*','LineWidth',1.5)



