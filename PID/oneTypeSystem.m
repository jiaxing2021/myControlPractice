

clear
close all
clc

%% system define 1-type system

s = tf('s');
G = 10/(s*(s+5));

sys = G;

K = dcgain(sys); % K -> infinity

%% open loop step response
t = 0:0.1:20;
step = ones(size(t));

[y,t] = lsim(sys, step, t);
figure('Name','step signal response')
hold on, grid on
plot(t,y,"LineWidth",1.5)
plot(t,step,"LineWidth",1.5)
legend("response","input")  % goes to infinity due to infinite dc gain

%% close loop step response

sys_closed = feedback(sys,1); 
[y_closed,t] = lsim(sys_closed, step, t);
figure('Name','step signal response')
hold on, grid on
plot(t,y_closed,"LineWidth",1.5)
plot(t,step,"LineWidth",1.5)
legend("response","input") % close loop system is stable

% If the closed loop system is stable, it is guranteed for PID to make this
% system stable


%% opne loop ramp signal response

ramp = t;
[y,t] = lsim(sys, ramp, t);
figure('Name','ramp signal response')
hold on, grid on
plot(t,y,"LineWidth",1.5)
plot(t,ramp,"LineWidth",1.5)
legend("response","input")  % goes to infinity due to infinite dc gain

%% close loop ramp response
 
[y_closed,t] = lsim(sys_closed, ramp, t);
figure('Name','ramp signal response')
hold on, grid on
plot(t,y_closed,"LineWidth",1.5)
plot(t,ramp,"LineWidth",1.5)
legend("response","input") % close loop system is stable


%% PID controller
Kp = 5;    % Proportional gain
Ki = 2;    % Integral gain
Kd = 1;  % Derivative gain

PID_controller = pid(Kp, Ki, Kd);

%% close loop with PID
sys_PID = feedback(PID_controller * sys, 1);

%% closed loop step signal response with pid

[y_PID,t] = lsim(sys_PID, step, t);
figure('Name','step signal response')
hold on, grid on
plot(t,y_PID,"LineWidth",1.5)
plot(t,step,"LineWidth",1.5)
legend("response","input") % close loop system is stable

%% closed loop ramp signal response with pid
[y_PID,t] = lsim(sys_PID, ramp, t);
figure('Name','ramp signal response')
hold on, grid on
plot(t,y_PID,"LineWidth",1.5)
plot(t,ramp,"LineWidth",1.5)
legend("response","input")  % remove steady state error

