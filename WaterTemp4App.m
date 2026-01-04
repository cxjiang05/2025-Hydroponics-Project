function [TempF, Char1] = WaterTemp4App(a, Char1)
    % Read raw voltage
    V = readVoltage(a, 'A1');

    % Known values
    R_fixed = 10000;        % 10k series resistor
    B = 3950;               % Thermistor Beta value
    R0 = 10000;             % Thermistor resistance at T0
    T0 = 298.15;            % 25°C in Kelvin

    % Convert voltage to thermistor resistance
    R_therm = R_fixed * (5 - V) / V;

    % Convert resistance to temperature (Kelvin)
    T_kelvin = 1 / ( (1/T0) + (1/B) * log(R_therm/R0) );

    % Convert to Fahrenheit
    TempF = (T_kelvin - 273.15) * 9/5 + 32;

    % Log
    Char1 = {};
    Char1{end+1,1} = char(sprintf('Pin read: %.2f V, Temperature: %.2f °F\n', V, TempF));
end


