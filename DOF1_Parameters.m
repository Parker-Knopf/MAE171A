clear all; clc; close all;
test_num = 1; % Test Setup, 1-3
%% Load Data

U = 0.02; % m (Val of step size)
n = 1; % Period used (IMPORTANT)

%data1 = readecp("Data/DOF1_en2_manual2_test1.csv");

%% Eval Data

% cpr = 1 / 560 / 100; % m/counts
% 
% time = data(:,2);
% pos = data(:,4) .*cpr;
% 
% plot(time, pos);

% ADD PROGRAM HERE TO FIND THE PARAMETERS NEEDED BELOW FROM DATA

% Parameters that should be found from all experiments here
[t0,y0,t1,y1,y_ss] = auto_analysis(test_num);

%% Eval Parameters

[k, m, d] = DOF1evalPram(t0, t1, y0, y1, y_ss, U, n);

disp("Experimentally Determined Parameters")
fprintf("Mass: %.3f +- %.3f\n", m.avg, m.std);
fprintf("Spring Constant: %.3f +- %.3f\n", k.avg, k.std)
fprintf("Damping Ratio: %.3f +- %.3f\n", d.avg, d.std)

%% Functions

function [k, m, d] = DOF1evalPram(t0, t1, y0, y1, y_ss, U, n)
    len = length(y_ss);
    k = zeros(len, 1);
    m = zeros(len, 1);
    d = zeros(len, 1);
    for i = 1:length(y_ss)
        
        C = y_ss(i) / U;
    
        w_d = 2 * pi * n / (t1(i) - t0(i));
        b_wn = 1 / (t1(i) - t0(i)) * log((y0(i) - y_ss(i)) / (y1(i) - y_ss(i)));
        w_n = sqrt(w_d^2 + b_wn^2);
        
        b = b_wn / w_n; 
    
        k(i) = 1 / C;
        m(i) = 1 / C / w_n^2;
        d(i) = 2 * b / C / w_n;
    end
    
    k.avg = mean(k(:));
    m.avg = mean(m(:));
    d.avg = mean(d(:));

    k.std = std(k(:));
    m.std = std(m(:));
    d.std = std(d(:));
end
