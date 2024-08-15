

clear
close all
clc

%% system define

%
% *****
% *****   -> u
%
%
%  *                      *
%   *                    *
%    *                  *
%     *                *
%      *                ->
%       **************
%                 

a = 10;
h_des = 10;
g = 9.81;


%% simulink

t_sim = 20;
out = sim("waterTankControl_sim.slx");

figure("Name","output")
plot(out.h.Time, out.h.Data, "LineWidth",1.5)

figure("Name","u")
plot(out.u.Time, out.u.Data, "LineWidth",1.5)

figure("Name","Cout")
plot(out.Cout.Time, out.Cout.Data, "LineWidth",1.5)



