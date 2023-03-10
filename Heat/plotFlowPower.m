clear; close all; clc;

%% Plot Flow Rate vs Fan Speed
flowData = readmatrix("Calibration/Flow Calibration Table.csv");

fanspeed = 0:20:100;
distance0 = flowData(1,:);
distance04 = flowData(2,:);
distance08 = flowData(3,:);
distance12 = flowData(4,:);

figure(1);
hold on;
grid on;
plot(fanspeed, distance0,'-o');
plot(fanspeed, distance04,'-x');
plot(fanspeed, distance08,'--');
plot(fanspeed, distance12);
xlabel('Fan Speed [%]'); ylabel('Flow Speed [m/s]')
title('Flow Speed vs. Fan Speed')
legend('Distance 0"','Distance 0.4"','Distance 0.8"','Distance 1.2"', 'Location','northwest')

%% Calculate Power consumed by Hot Plate and Plot it against Plate Temp

calibrationData50 = readmatrix("Calibration/1.12 Heat transfer 50C.csv");
calibrationData75 = readmatrix("Calibration/1.12 Heat transfer 75C.csv");
calibrationData100 = readmatrix("Calibration/1.12 Heat transfer 100C.csv");
calibrationData125 = readmatrix("Calibration/1.12 Heat transfer 125C.csv");
calibrationData150 = readmatrix("Calibration/1.12 Heat transfer 150C.csv");

V_sense50 = calibrationData50(:,4);
V_sense75 = calibrationData75(:,4);
V_sense100 = calibrationData100(:,4);
V_sense125 = calibrationData125(:,4);
V_sense150 = calibrationData150(:,4);

V_heater50 = calibrationData50(:,3);
V_heater75 = calibrationData75(:,3);
V_heater100 = calibrationData100(:,3);
V_heater125 = calibrationData125(:,3);
V_heater150 = calibrationData150(:,3);

R = 5;
Power50 = mean((V_heater50 - V_sense50) .* V_sense50/R);
Power75 = mean((V_heater75 - V_sense75) .* V_sense75/R);
Power100 = mean((V_heater100 - V_sense100) .* V_sense100/R);
Power125 = mean((V_heater125 - V_sense125) .* V_sense125/R);
Power150 = mean((V_heater150 - V_sense150) .* V_sense150/R);

PlateTemp50 = mean(calibrationData50(:,2));
PlateTemp75 = mean(calibrationData75(:,2));
PlateTemp100 = mean(calibrationData100(:,2));
PlateTemp125 = mean(calibrationData125(:,2));
PlateTemp150 = mean(calibrationData150(:,2));

Powers = [Power50 Power75 Power100 Power125 Power150];
Temps = [PlateTemp50 PlateTemp75 PlateTemp100 PlateTemp125 PlateTemp150];
figure(2);
hold on;
grid on;
plot(Temps, Powers,'-o');
xlabel('Plate Temperature [Degree Celsius]'); ylabel('Power [W]')
title('Power vs. Plate Temperature')
