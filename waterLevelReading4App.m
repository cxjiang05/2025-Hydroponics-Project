function [Voltage, Height, Char1] = waterLevelReading4App(a, pin, Char1)

    % Step 1: Read voltage
    Voltage = readVoltage(a, pin);

    % Step 2: Convert voltage to height 
    Vmin = 0;       
    Vmax = 5;       
    Hmax = 5;      % Max height = 5 cm
    
    Height = (Voltage - Vmin) * (Hmax / (Vmax - Vmin));

    % Step 3: Log results
    Char1{end+1} = char(sprintf('Pin read: %.2f V, Water height: %.2f cm\n', Voltage, Height));
end