

clear
close all
clc

rng("default")
%% system define
zeta = 0.7; wn = 5; 
G = tf(1, [1 2*zeta*wn wn^2]);

% pole(G)
% step(G) % stable
%% closed loop transfer function
K = 1; % initial feedback gain
closed_G = feedback(K*G, 1);
 
% pole(closed_G)
% step(closed_G) % stable

%% RL environment create
% observation define
obsInfo = rlNumericSpec([1 1], 'LowerLimit', -inf, 'UpperLimit', inf);
obsInfo.Name = "error";
obsInfo.Description = "error";

% action define
actInfo = rlNumericSpec([1 1], 'LowerLimit', -200, 'UpperLimit', 200);
actInfo.Name = "K";
actInfo.Description = "feed back gain";
%% environment create

env = rlFunctionEnv(obsInfo,actInfo,"myStepFunction","myResetFunction");

%% critic create
% state path is used to receive error
statePath = [
    featureInputLayer(1, 'Normalization', 'none', 'Name', 'state')
    fullyConnectedLayer(24, 'Name', 'fc1')
    reluLayer('Name', 'relu1')
    fullyConnectedLayer(24, 'Name', 'fc2')
    ];
% action path is used to action
actionPath = [
    featureInputLayer(1, 'Normalization', 'none', 'Name', 'action')
    fullyConnectedLayer(24, 'Name', 'fc3')
    ];
% to connect state and action path
commonPath = [
    additionLayer(2, 'Name', 'add')
    reluLayer('Name', 'relu2')
    fullyConnectedLayer(1, 'Name', 'fc4')
    ];

criticNetwork = layerGraph(statePath);
criticNetwork = addLayers(criticNetwork, actionPath);
criticNetwork = addLayers(criticNetwork, commonPath);

criticNetwork = connectLayers(criticNetwork, 'fc2', 'add/in1');
criticNetwork = connectLayers(criticNetwork, 'fc3', 'add/in2');

critic = rlQValueFunction(criticNetwork, obsInfo, actInfo, ...
    'ObservationInputNames', 'state', 'ActionInputNames', 'action');
%% actor network create
actorNetwork = [
    featureInputLayer(1, 'Normalization', 'none', 'Name', 'state')
    fullyConnectedLayer(24, 'Name', 'fc1')
    reluLayer('Name', 'relu1')
    fullyConnectedLayer(24, 'Name', 'fc2')
    reluLayer('Name', 'relu2')
    fullyConnectedLayer(1, 'Name', 'fc3')
    tanhLayer('Name', 'tanh1')
    scalingLayer('Name', 'scale', 'Scale', max(actInfo.UpperLimit)) 
    ];

actor = rlContinuousDeterministicActor(actorNetwork, obsInfo, actInfo, ...
    'ObservationInputNames', 'state');

%% DDPG agent create

agentOptions = rlDDPGAgentOptions('SampleTime', 0.1, 'DiscountFactor', 0.99);
agent = rlDDPGAgent(actor, critic, agentOptions);


open_system("mySystem")
return
%% training

trainOpts = rlTrainingOptions(...
    'MaxEpisodes', 500, ...
    'MaxStepsPerEpisode', 200, ...
    'Verbose', false, ...
    'Plots', 'training-progress');

trainingStats = train(agent, env, trainOpts);


%% get the optimal action

InitialObservation = 1;
optimalK = getAction(agent,InitialObservation);
optimalK = cell2mat(optimalK);

T_optimal = feedback(optimalK * G, 1);

step(T_optimal, 3);