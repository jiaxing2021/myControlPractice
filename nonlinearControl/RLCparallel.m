

close all
clear
clc

%% system define
R = 3; L = 0.5; C = 0.25;

%% simulink

t_sim = 20;
out = sim('RCLparallel_sim.slx');

figure('Name',"input")
plot(out.is,'LineWidth',1.5)

figure('Name',"output")
plot(out.i,'LineWidth',1.5)

figure('Name',"theta_dot")
hold on
plot(out.i.data,out.i_dot.data,'LineWidth',1.5)
plot(out.i.data(1),out.i_dot.data(1),'o', 'LineWidth',1.5)
plot(out.i.data(end),out.i_dot.data(end),'*', 'LineWidth',1.5)

