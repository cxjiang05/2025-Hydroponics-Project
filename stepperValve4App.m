function MovedDistance = stepperValve4App(stepperObj, steps, Height)
% stepperValve4App
% Controls stepper motor based on water height.
% If water is below threshold → rotate +8000 steps (counterclockwise, ON).
% If water reaches/exceeds max height → rotate -8000 steps (clockwise, OFF).

    % Water trigger thresholds
    vLowThreshold  = 5 / 4;   % 1.25 cm (low water level)
    vHighThreshold = 5;       % 5 cm (max water level)

    % Default return
    MovedDistance = 0;

    % Case 1: Water is LOW → Turn ON (counterclockwise)
    if Height < vLowThreshold
        stepperObj.setMaxSpeed(300);
        stepperObj.setAcceleration(800);

        stepperObj.startrun();
        pause(1);
        stepperObj.moveTo(steps);   % +8000 steps counterclockwise
        pause(3);
        stepperObj.stop();
        stepperObj.setCurrentPosition(0);

        MovedDistance = steps;
        pause(5);

    % Case 2: Water is HIGH → Turn OFF (clockwise)
    elseif Height >= vHighThreshold
        stepperObj.setMaxSpeed(300);
        stepperObj.setAcceleration(800);

        stepperObj.startrun();
        pause(1);
        stepperObj.moveTo(-steps);  % -8000 steps clockwise
        pause(3);
        stepperObj.stop();
        stepperObj.setCurrentPosition(0);

        MovedDistance = -steps;
    end
end