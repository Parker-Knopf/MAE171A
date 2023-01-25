clear all; clc; close all;

format long;
%% Eval Data

% Experiment 1 to find Sys2 Parameters
test_num = 1; % Hold Sys1 and occilate Sys2
U = .5; % N (Val of step size)
[t0,y0,t1,y1,y_ss,n] = AutoAnalysis(test_num);
[k2, m2, d2] = DOF1EvalPram(t0, t1, y0, y1, y_ss, U, n);

% Experiment 2 to find Sys1 Parameters
test_num = 2; % Hold Sys2 and occilate Sys1
U = 0.1; % N (Val of step size)
[t0,y0,t1,y1,y_ss,n] = AutoAnalysis(test_num);
[k1, m1, d1] = DOF1EvalPram(t0, t1, y0, y1, y_ss, U, n);
k1.avg = k1.avg - k2.avg;

disp("Experimentally Determined Parameters: SYS1")
fprintf("Mass: %.8f +- %.3f\n", m1.avg, m1.std);
fprintf("Spring Constant: %.8f +- %.3f\n", k1.avg, k1.std)
fprintf("Damping Ratio: %.8f +- %.3f\n\n", d1.avg, d1.std)

disp("Experimentally Determined Parameters: SYS2")
fprintf("Mass: %.8f +- %.3f\n", m2.avg, m2.std);
fprintf("Spring Constant: %.8f +- %.3f\n", k2.avg, k2.std)
fprintf("Damping Ratio: %.8f +- %.3f\n", d2.avg, d2.std)