function cost = pid_cost(x, G)
    Kp = x(1);
    Ki = x(2);
    Kd = x(3);

    C = pid(Kp, Ki, Kd);
    T = feedback(C*G, 1);


    [y, t] = step(T);

    overshoot = max(y) - 1; % reference is 1
    steady_state_error = abs(1 - y(end));  
    time_cost = sum(t)*0.01;

    cost = overshoot^2 + steady_state_error^2 + time_cost;
end