


clear
close all
clc

%% system define
zeta = 0.7; wn = 5; 
G = tf(1, [1 2*zeta*wn wn^2]);

% pole(G)
% step(G) % stable
%% Partical Swarm Optimization algorithm

% update volecity
% vi(t+1) = w*vi(t) + c1*r1*(pi-xi(t)) + c2*r2*(pg-x(i))
% update position
% xi(t+1) = xi(t) + vi*(t+1)

n_particles = 30; % the number of paticals, usually in [30, 50]
n_iterations = 100; 

w = 0.7;  % inertia weight, usually in [0.5, 1]

c1 = 1.5; % sigle study coefficent, usually around 2
c2 = 1.5; % global study coefficent, usually around 2

lb = [0, 0, 0];  % low bound of PID gain
ub = [10, 10, 10];  % up bound of PID gain

%% initial 

pos = rand(n_particles, 3) .* (ub - lb) + lb; % initial position
vel = zeros(n_particles, 3); % initial volecity
pbest = pos; % single best postion
gbest = pos(1, :); % global best postion
pbest_cost = inf(n_particles, 1); % single best cost
gbest_cost = inf; % global best cost


%% iteration

for iter = 1:n_iterations
    for i = 1:n_particles

        cost = pid_cost(pos(i, :), G);

        if cost < pbest_cost(i)
            pbest(i, :) = pos(i, :);
            pbest_cost(i) = cost;
        end
        
        if cost < gbest_cost
            gbest = pos(i, :);
            gbest_cost = cost;
        end
    end
    
    for i = 1:n_particles
        vel(i, :) = w * vel(i, :) ...
                    + c1 * rand * (pbest(i, :) - pos(i, :)) ...
                    + c2 * rand * (gbest - pos(i, :));
        pos(i, :) = pos(i, :) + vel(i, :);
        
        pos(i, :) = max(min(pos(i, :), ub), lb);
    end
    
    fprintf('Iteration %d, Best cost: %f\n', iter, gbest_cost);
end

%% get the best PID coefficents

Kp_best = gbest(1);
Ki_best = gbest(2);
Kd_best = gbest(3);
fprintf('Optimal PID parameters: Kp = %f, Ki = %f, Kd = %f\n', Kp_best, Ki_best, Kd_best);

%% simulation
C_opt = pid(Kp_best, Ki_best, Kd_best);
T_opt = feedback(C_opt * G, 1);
step(T_opt, 30);
title('Step Response with Optimized PID Controller');