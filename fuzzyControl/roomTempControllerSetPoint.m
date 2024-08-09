

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

% define room temperature difference membership funcion
FIS = addInput(FIS, [-50 50], 'Name', 'difference');
FIS = addMF(FIS, 'difference', 'trimf', [-50 -10 0], 'Name', 'Cooling');
FIS = addMF(FIS, 'difference', 'trimf', [-2 0 2], 'Name', 'Settling');
FIS = addMF(FIS, 'difference', 'trimf', [0 10 50], 'Name', 'Heating');

% define fan speed membership funcion
FIS = addOutput(FIS, [0 100], 'Name', 'FanSpeed');
FIS = addMF(FIS, 'FanSpeed', 'trimf', [0 0 25], 'Name', 'Low');
FIS = addMF(FIS, 'FanSpeed', 'trimf', [25 50 75], 'Name', 'Medium');
FIS = addMF(FIS, 'FanSpeed', 'trimf', [75 100 100], 'Name', 'High');

% define rule
rule1 = "difference==Cooling => FanSpeed=Low";
rule2 = "difference==Settling => FanSpeed=Medium";
rule3 = "difference==Heating => FanSpeed=High";
rules = [rule1 rule2 rule3];

FIS = addRule(FIS, rules);

% display the structure of fuzzy controller
figure;
plotfis(FIS);

% fuzzy inference system
figure;
subplot(2,1,1);
plotmf(FIS, 'input', 1);
title('difference Membership Functions');
subplot(2,1,2);
plotmf(FIS, 'output', 1);
title('Fan Speed Membership Functions');


%% test
% define reference room temperature
Tr = 25;

% define current room temperature
T_current = 30;
T_previous = 30;

fanSpeed_ = [];
T = [T_current];

for i = 1:100
    % fuzzy inference
    diff = T_current - Tr;
    fanSpeed = evalfis(FIS, diff);
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
