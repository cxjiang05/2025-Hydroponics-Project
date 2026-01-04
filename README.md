# 2025-Hydroponics-Project
⚠️ Disclaimer: I use ChatGPT to check spelling and rephrase my README, and to help me in crafting this project.

Hydroponics Final App (MATLAB + Arduino)

A hydroponics monitoring and control prototype built using MATLAB App Designer, Arduino, and a USB webcam.
The system integrates hardware control, sensor monitoring, computer vision, and data logging into a single interactive UI.

This project was developed as part of a multidisciplinary engineering course and focuses on functional system integration rather than full production-level optimization.

⸻

Features
	•	MATLAB App Designer GUI
	•	Dual-Arduino architecture (sensors + motors separated)
	•	Pump control via servo motor
	•	Reservoir valve control via stepper motor
	•	Water level and sump monitoring
	•	Conductivity and temperature measurement
	•	pH estimation using camera-based color analysis
	•	Plant growth, light level, and blooming detection via vision
	•	Excel data logging
	•	UI and physical LED alarms

⸻

Project Structure

/matlab-app
• HydroponicsFinalApp.mlapp
• WaterLevel4App.m
• waterLevelReading4App.m
• PumpOnOff4App.m
• stepperValve4App.m
• pHservo4App.m
• Conductivity4App.m
• WaterTemp4App.m
• ReadPH4App.m
• Vison4App.m
• monitorWaterLevel.m

/docs
• wiring-diagram.png
• ui-screenshot.png

/data
• myHydroponicData_sample.xlsx

⸻

Requirements

Software
	•	MATLAB (R2022 or newer recommended)
	•	MATLAB App Designer
	•	MATLAB Support Package for Arduino Hardware
	•	MATLAB Support Package for USB Webcams
	•	Microsoft Excel (recommended for data logging)

Hardware
	•	2 × Arduino Uno
	•	USB Webcam
	•	Pump servo motor
	•	pH strip dipping servo
	•	Stepper motor + driver (AccelStepperAddon)
	•	Water level / moisture sensor
	•	Sump level sensor
	•	Conductivity sensor
	•	Water temperature sensor (thermistor)

⸻

Pin Configuration (Current Code)

Arduino #1 – Sensors / Stepper

Stepper Motor (AccelStepperAddon): D8, D12, D11, D13
Sump Water Level Sensor: A0
Moisture / Water Level Sensor: A1

Arduino #2 – Motors / Indicators

Pump Servo: D8
pH Servo: D4
Sump LED Indicator: D11
General Alarm LED: D12

Note: Update COM ports and pin assignments in startupFcn if your setup differs.

⸻

How to Run
	1.	Connect both Arduinos and the webcam to your computer.
	2.	Update COM ports and webcam index inside startupFcn:
arduino(‘COM5’,‘Uno’,…)
arduino(‘COM4’,‘Uno’,…)
webcam(2)
	3.	Open HydroponicsFinalApp.mlapp in MATLAB App Designer.
	4.	Click Run.
	5.	Press Start Test to execute a full monitoring and control cycle.
	6.	Use Check Sensor to display the most recent logged sensor value.

⸻

Data Logging

Sensor data is saved to:
myHydroponicData.xlsx

Each run appends a new row containing:
Year, Month, Day, Hour, Minute, Conductivity, Water Temperature, pH, Light Level, Plant Height, Blooming Status, Sump Voltage

Make sure Excel is closed before running the app.

⸻

Alarm System

Sump Lamp (UI + LED): indicates low sump water level
Sensor Alarm Lamp (UI + LED): indicates out-of-range sensor values
Alarm thresholds are defined in the app and can be adjusted as needed.

⸻

Known Limitations
	•	Code prioritizes clarity and functionality over optimization
	•	Some helper functions use simple linear mappings and assumptions
	•	Camera-based pH and vision analysis depend heavily on lighting conditions
	•	COM ports, pin assignments, and webcam index are system-dependent
	•	Some prototype/test code is retained for demonstration purposes

⸻

Safety Notes
	•	Do not power motors or servos directly from Arduino 5V pins
	•	Use external power supplies with a common ground
	•	Keep all electronics isolated from water
	•	Secure wiring and components before operation

⸻

Author:

ChenXiang Jiang
Lead UI & Data System Programmer
Hydroponics – Water Planting Device (Course Project)
