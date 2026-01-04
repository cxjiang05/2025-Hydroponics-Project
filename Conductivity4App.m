function [ppm, Char1] = Conductivity4App(a, Char1)
% This function reads pin A0 and returns the calibrated ppm value
% according to y = -341.4x + 641.28
voltage = readVoltage(a, 'A0');
ppm = -7.05 * voltage + 30.74;
Char1 = {};
Char1{end+1,1} = char(sprintf('pin read, voltage %.2f V, ppm %.2f \n', voltage, ppm));
end
