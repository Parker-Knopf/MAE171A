clear all; clc; close all;

data = readecp("Data/test_3_5.csv");

% cpr = 1 / 560 / 100; % m/counts
cpr = 1;

time = data(:,2);
pos = data(:,4) .*cpr;

plot(time, pos);