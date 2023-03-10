clear all; close all; clc;

figure(1)

% All data
% v = [100, 80, 60, 40, 20];
% color = ["blue", "red", "k", "green", "m"];

% Compare extreams
v = [100, 20];
color = ["blue", "m"];

for i = 1:length(v)
    flowSpeed(v(i), 1, color(i), 1);
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

