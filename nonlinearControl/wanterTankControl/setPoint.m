

clear
close all
clc

%% system define

%
% *****
% *****   -> u
%
%  *                      *
%  *                      *
%   *                    *
%    *                  *
%     *                *
%      *                -> Cout
%       **************
%                 

a = 10; % Cout cross section area
h_des = 10; % reference water level
g = 9.81; % gravity acceleration

%% control gain
% K = 2;
K = 5;
% K = 2000;
% Why no overshot?
% Because the solver is fast enough?


%% simulink

t_sim = 5000;
out = sim("setPoint_sim.slx");

figure("Name","output & reference")
hold on
plot(out.ref.Time, out.ref.Data, "LineWidth",1.5)
plot(out.h.Time, out.h.Data, "LineWidth",1.5)
legend("reference","output")

figure("Name","u(Cin) & Cout")
hold on
plot(out.u.Time, out.u.Data, "LineWidth",1.5)
plot(out.Cout.Time, out.Cout.Data, "LineWidth",1.5)
legend("Cin","Cout")



