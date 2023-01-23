clear all; clc; close all;
test_num = 1; % Test Setup, 1-3
%% Load Data

U = 0.02; % m (Val of step size)

%% Eval Data

[t0,y0,t1,y1,y_ss,n] = AutoAnalysis(test_num);

%% Eval Parameters

[k, m, d] = DOF1EvalPram(t0, t1, y0, y1, y_ss, U, n);

disp("Experimentally Determined Parameters")
fprintf("Mass: %.3f +- %.3f\n", m.avg, m.std);
fprintf("Spring Constant: %.3f +- %.3f\n", k.avg, k.std)
fprintf("Damping Ratio: %.3f +- %.3f\n", d.avg, d.std)