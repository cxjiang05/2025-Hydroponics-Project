function [Voltage, Char1] = WaterLevel4App(a, pin, Char1)

% Read voltage from the moisture sensor
Voltage = readVoltage(a, pin);

% Log the reading
Char1{end+1,1} = sprintf('Moisture sensor on %s read %.2f V.\n', pin, Voltage);

end