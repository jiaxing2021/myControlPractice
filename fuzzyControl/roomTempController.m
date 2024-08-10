

clear
close all
clc

% define the relationship between room temperature and fan speed
% T: room temperature
% S: fan speed
% T_current = T_previous - S * 0.1 + 5

%% define fuzzy inference system
% define fuzzy inference system
FIS = mamfis('Name', 'RoomTemperatureController');

% define room temperature member funcion
FIS = addInput(FIS, [8 32], 'Name', 'temp');
FIS = addMF(FIS, 'temp', 'trapmf', [8 8 11 14], 'Name', 'Cold');
FIS = addMF(FIS, 'temp', 'trapmf', [11 14 17 20], 'Name', 'Cool');
FIS = addMF(FIS, 'temp', 'trimf', [17 20 23], 'Name', 'Comfortable');
FIS = addMF(FIS, 'temp', 'trapmf', [20 23 26 29], 'Name', 'Warm');
FIS = addMF(FIS, 'temp', 'trapmf', [26 29 32 32], 'Name', 'Hot');


% define fan speed member funcion
FIS = addOutput(FIS, [0 100], 'Name', 'FanSpeed');
FIS = addMF(FIS, 'FanSpeed', 'trimf', [0 0 25], 'Name', 'Low');
FIS = addMF(FIS, 'FanSpeed', 'trimf', [25 50 75], 'Name', 'Medium');
FIS = addMF(FIS, 'FanSpeed', 'trimf', [75 100 100], 'Name', 'High');

% define rule
rule1 = "temp==Cold => FanSpeed=Low";
rule2 = "temp==Cool => FanSpeed=Low";
rule3 = "temp==Comfortable => FanSpeed=Medium";
rule4 = "temp==Warm => FanSpeed=High";
rule5 = "temp==Hot => FanSpeed=High";
rules = [rule1 rule2 rule3 rule4 rule5];

FIS = addRule(FIS, rules);

% display the structure of fuzzy controller
figure;
plotfis(FIS);

% fuzzy inference system
figure;
subplot(2,1,1);
plotmf(FIS, 'input', 1);
title('temperature Membership Functions');
subplot(2,1,2);
plotmf(FIS, 'output', 1);
title('Fan Speed Membership Functions');

%% test

% define current room temperature
T_current = 30;
T_previous = 30;

fanSpeed_ = [];
T = [];

for i = 1:100
    % fuzzy inference
    fanSpeed = evalfis(FIS, T_current);
    T_current = T_previous - fanSpeed * 0.1 + 5;
    % according to above model, the temperature would be convergent to 20
    T_previous = T_current;
    fanSpeed_ = [fanSpeed_; fanSpeed];
    T = [T; T_current];

    pause(0.01)
end


figure;
subplot(2,1,1);
plot(T);
title('room temperatures');
subplot(2,1,2);
plot(fanSpeed_);
title('fan speed');
