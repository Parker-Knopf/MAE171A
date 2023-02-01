clear all; clc; close all;

format long;

%% Experiment 1 to find Sys1 Parameters (Lumped Model Analysis)
% m_eff = m1 + m2, k_eff = k1
test_num = 3; % 2 DOF -> 1 DOF Approximation
U = .5; % V (Val of step size)
[t0,y0,t1,y1,y_ss,n] = AutoAnalysis(test_num);
[k1, m_e, d_e] = DOF1EvalParam(t0, t1, y0, y1, y_ss, U, n);

%% Experiment 2 to find Sys1 Paramters (1DOF holding Sys2)
% k_eff = k1 + k2, m_eff = m1, d_eff = d1
test_num = 2;
U = 0.5; % V (Val of step size)
[t0,y0,t1,y1,y_ss,n] = AutoAnalysis(test_num);
[k_e, m1, d1] = DOF1EvalParam(t0, t1, y0, y1, y_ss, U, n);

k2.avg = k_e.avg - k1.avg;
m2.avg = m_e.avg - m1.avg;
d2.avg = d_e.avg - d1.avg;

%% Results

disp("Experimentally Determined Parameters: SYS1")
fprintf("Mass: %.8f\n", m1.avg);
fprintf("Spring Constant: %.8f\n", k1.avg)
fprintf("Damping Ratio: %.8f\n\n", d1.avg)

disp("Experimentally Determined Parameters: SYS2")
fprintf("Mass: %.8f\n", m2.avg);
fprintf("Spring Constant: %.8f\n", k2.avg)
fprintf("Damping Ratio: %.8f\n\n", d_e.avg)