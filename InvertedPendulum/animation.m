

function animation(l, yOut, tOut)
    dt = tOut(1)/10;
    figure('Name','inverted pendulum');
    for i = 1:length(tOut)
        clf;
    
        x = l * sin(yOut(i,2));
        y = l * cos(yOut(i,2));
    
        hold on;
        plot([yOut(i,1) yOut(i,1)+x], [0 y], 'r-', 'LineWidth', 2); 
        plot(yOut(i,1)+x, y, 'bo', 'MarkerSize', 10, 'MarkerFaceColor', 'b'); 
        plot(yOut(i,1), 0, 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k');
        axis equal;
        axis([-3*l 3*l -2*l 2*l]);
    
        title(sprintf('Time: %.2f s', tOut(i)));
    
        pause(dt);
    end
end