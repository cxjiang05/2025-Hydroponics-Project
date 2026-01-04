% This is the test protocol for the Hydroponic device Fall 2025 and Spring
% 2026.  This code calls functions that are initially "dummy" function but
% will print to show that they were correctly called.  Student teams will
% replace these functions with actual functions that they write.  Teams
% without a User Interface team member will use this code as thier base
% code to demonstrate their hydroponic device on the final day of class. 

% To run this code attach an Ardino and camera,but the Arduino does not
% need to be populated. The code was written to have a 180 servo on D8, an
% LED on D5, and a voltage divider tied to A0 all on the Arduino.  

% This code was written March, 2025 by Julie Whitney, updated to reflect
% removal of DHT 11 sensor May, 2025.

clear all;
clc

% Initialize variables   ********************************************

a1 = arduino('COM5','Uno','Libraries', {'Servo', 'AccelStepperAddon/AccelStepperAddon'}); %sensors
a2 = arduino('COM4', 'Uno','Libraries', {'Servo', 'AccelStepperAddon/AccelStepperAddon'});  % motors

cam=webcam(2);
preview(cam);
pause(2)

servo2 = servo(a2, 'D8', 'MinPulseDuration', 700*10^-6, 'MaxPulseDuration', 2300*10^-6);
servo3 = servo(a2, 'D4', 'MinPulseDuration', 700*10^-6, 'MaxPulseDuration', 2300*10^-6);
s2=addon(a1,'AccelStepperAddon/AccelStepperAddon',{'D8','D12','D11','D13'}); %stepper for reservoir

threshold = 2.0;
Char1 = {};

% Read moisture sensor voltage
[Voltage, Char1] = WaterLevel4App(a1, 'A1', Char1);
disp(Voltage);

% Decide pump state based on voltage
[PumpState, Char1] = PumpOnOff4App(servo2, Voltage, threshold, Char1);

if PumpState
    disp('Pump is ON');
else
    disp('Pump is OFF');
end     
pause(3);

% Check water flow
writeDigitalPin(a2, 'A1', 1);
[Voltage, Char1] = WaterLevel4App(a1,'A1', Char1);
disp('Checking water flowing');
writeDigitalPin(a2, 'A1', 0);
disp(Voltage);
PumpFlag = PumpOnOff4App(servo2, 0.5, threshold, Char1);

%Add fresh water - ALL DESIGN TYPES
% Checking height of water in the sump
disp('Checking water level in the sump')
Voltage = waterLevelReading4App(a1,'A0', Char1);
disp(Voltage);


% move stepper motor to allow water to enter sump from the Reservoir 

MovedDistance = stepperValve4App(s2,2000);
      pause (5)
  
fprintf('MovedDistance =  \n');
disp(MovedDistance);
pause(5) % uses the timer to delay while valve closes

% Check pH (servo motion) 
disp("Dipping a pH test strip");
Char1 = pHservo4App(servo3, Char1);

% Check conductivity
disp("checking conductivity of solution");
ppm = Conductivity4App(a1,'D3');
disp(ppm);

if ppm > 2
    writeDigitalPin(a2,"D12",1)
    disp('LED should be lit now')
    pause(3)
    writeDigitalPin(a2,"D12",0)
else
    disp('Conductivity Within limits')
end

% Checking water temperature
disp('Checking water temperature')
TempF = WaterTemp4App(a1,'');
disp(TempF);

% Reading pH
disp('reading nutrient water pH')
[pH] = ReadPH4App(cam);

% Vision system
disp("calling vision code")
[LightLevel,PlantHeight,Blooming,image] = Vison4App(cam);
imshow(image);

% Store data
t=datetime('now');
[y,month,d] = ymd(t);
[h,m,s] = hms(t);

Data2Add=[y,month,d,h,m,ppm,TempF,pH,LightLevel,PlantHeight,Blooming,Voltage];

ExistingData=readmatrix('myHydroponicData.xlsx');
lr=size(ExistingData,1);
string1=['A',num2str(lr+1)];
string2=['M',num2str(lr+1)];
range=strcat(string1,':',string2);

writematrix(Data2Add,'myHydroponicData.xlsx','Sheet',1,'Range',range)