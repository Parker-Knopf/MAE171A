clear all; close all; clc;

% All data
v = [100, 80, 60, 40, 20];
color = ["blue", "red", "k", "green", "m"];

% Compare extreams
% v = [100, 20];
% color = ["blue", "m"];

figure(1)
v_avg = zeros(length(v), 1);
q = zeros(length(v), 1);
for i = 1:length(v)
    [v_avg(i), q(i)] = flowSpeed(v(i), 1, color(i), 1);
end

title("Velocity Flow vs Radial Pipe Axis")
ylabel("Velocity (m/s)")
xlabel("Radial Axis (mm)")
names = strsplit(sprintf("Fan Percentage: %d%%,", v), ',');

lengendNames = strings(1, 2*length(v));
for i = 1:length(v)
    lengendNames(2*i) = names(i);
end

legend(lengendNames)

figure(2)

plot(v, q, 'o--', 'LineWidth', 2)
grid on;
title("Volumetric Flow Rate vs Fan Power/Speed")
ylabel("Flow Rate Q (m^3/s)")
xlabel("Percent of Fan Speed (%)")



