function [PumpState, Char1] = PumpOnOff4App(PumpServo, Voltage, threshold, Char1)
%PumpOnOff4App Controls a servo pump based on moisture sensor voltage

% Define servo positions
onSpeed = 0;      % fully on
offSpeed = 0.5;  % off

% Decision based on moisture level
if Voltage > threshold
    % Soil is too dry → turn pump ON
    writePosition(PumpServo, onSpeed);
    PumpState = 1;
    Char1{end+1,1} = sprintf('Moisture voltage %.2f V < %.2f V → Pump ON\n', ...
                              Voltage, threshold);
else
    % Soil is wet enough → turn pump OFF
    writePosition(PumpServo, offSpeed);
    PumpState = 0;
    Char1{end+1,1} = sprintf('Moisture voltage %.2f V ≥ %.2f V → Pump OFF\n', ...
                              Voltage, threshold);
end

end