function [NextObs, Reward, IsDone, UpdatedInfo] = myStepFunction(Action, Info)
    
    K = Action;
    
    zeta = 0.7; wn = 5; 
    G = tf(1, [1 2*zeta*wn wn^2]);

    closed_G = feedback(K*G, 1);
    
    ref = 1;
    % steady state error
    [y, t] = step(closed_G, 0:0.1:20);  
    steadyStateError = abs(ref - y(end)); 

    % overshut error
    maxOutput = max(y);
    if maxOutput > ref
        overshoot = maxOutput - ref;
    else
        overshoot = 0;
    end

    settlingTime = t(find(abs(y - ref) < 0.02 * ref, 1));  
    if isempty(settlingTime)
        settlingTime = 20;  
    end


    Reward = -abs(steadyStateError) - 5 * overshoot - 0.1 * settlingTime; 
  

    NextObs = steadyStateError;
    IsDone = steadyStateError < 0.01 || t(end) >= 20;
    % IsDone = t(end) >= 10;

    UpdatedInfo = [];
end
