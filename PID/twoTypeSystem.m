

clear
close all
clc

%% system define
s = tf('s');
sys = s/(s^2*(s+5));

K = dcgain(sys); % K -> infinity

%% step and ramp

t = 0:0.1:20;
step = ones(size(t));
ramp = t;

%% open loop step response

[y,t] = lsim(sys, step, t);
figure('Name','step signal response')
hold on, grid on
plot(t,y,"LineWidth",1.5)
plot(t,step,"LineWidth",1.5)
legend("response","input")

%% close loop step response

sys_closed = feedback(sys, 1);
[y_closed,t] = lsim(sys_closed, step, t);
figure('Name','step signal response')
hold on, grid on
plot(t,y_closed,"LineWidth",1.5)
plot(t,step,"LineWidth",1.5)
legend("response","input")

%% open loop ramp response

[y,t] = lsim(sys, ramp, t);
figure('Name','step signal response')
hold on, grid on
plot(t,y,"LineWidth",1.5)
plot(t,ramp,"LineWidth",1.5)
legend("response","input")

%% close loop ramp response

sys_closed = feedback(sys, 1);
[y_closed,t] = lsim(sys_closed, ramp, t);
figure('Name','step signal response')
hold on, grid on
plot(t,y_closed,"LineWidth",1.5)
plot(t,ramp,"LineWidth",1.5)
legend("response","input")

%% PI controller
Kp = 2;
Ki = 1;
PI_controller = tf([Kp Ki], [1 0]);

%% close loop 
sys_PI = feedback(PI_controller * sys, 1);

%% step response
[y_PI,t] = lsim(sys_PI, step, t);
figure('Name','step signal response')
hold on, grid on
plot(t,y_PI,"LineWidth",1.5)
plot(t,step,"LineWidth",1.5)
legend("response","input")

%% ramp signal response

[y_PI,t] = lsim(sys_PI, ramp, t);
figure('Name','ramp signal response')
hold on, grid on
plot(t,y_PI,"LineWidth",1.5)
plot(t,ramp,"LineWidth",1.5)
legend("response","input")


