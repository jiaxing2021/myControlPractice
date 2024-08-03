


close all
clear
clc

%% parameters define

syms M m l I g u
syms x theta xd thetad xdd thetadd

% state x = [x xd theta thetad]
%% Euler-lagrange Equation
% kinetic energy
T = 1/2*M*xd^2 + 1/2*I*thetad^2 + 1/2*m*((xd+thetad*l*cos(theta))^2+(thetad*l*sin(theta))^2);
% potential energy
U = m*g*l*cos(theta);

%%
dT_xd = collect(simplify(diff(T,xd)));
dT_thetad = collect(simplify(diff(T,thetad)));

dT_xd_dot = (M+m)*xdd+m*l*thetadd*cos(theta)-m*l*thetad^2*sin(theta);
dT_thetad_dot = I*thetadd + m*l^2*thetadd+m*l*(xdd*cos(theta)-xd*thetad*sin(theta));

dT_x = collect(simplify(diff(T,x)));
dT_theta = collect(simplify(diff(T,theta)));

dU_x = collect(simplify(diff(U,x)));
dU_theta = collect(simplify(diff(U,theta)));

dT_qd_dot = [dT_xd_dot; dT_thetad_dot]; 
dT_dq = [dT_x; dT_theta];
dU_dq = [dU_x; dU_theta]; 

%%
% F = [u; 0]
F = dT_qd_dot - dT_dq + dU_dq;
F = collect(simplify(F));
