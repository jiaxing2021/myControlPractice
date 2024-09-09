

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

%% nmpc
