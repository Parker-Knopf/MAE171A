clear all; clc; close all;

data = readecp("Data/DOF1_en2_manual2_test2.csv");

cpr = 1 / 560 / 100; % m/counts

time = data(:,2);
pos = data(:,4) .*cpr;

plot(time, pos);