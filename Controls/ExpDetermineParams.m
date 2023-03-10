clear all; clc; close all;

format long;


%% UNITS
% K IS IN V/COUNT
% M IS IN V*S^2/COUNT
% D IS IN V*S/COUNT

%% Experiment 1 to find Sys1 Parameters (Lumped Model Analysis)
% m_eff = m1 + m2, k_eff = k1
test_num = 3; % 2 DOF -> 1 DOF Approximation
U = [0.5*ones(1,7), 0.75*ones(1,9)]; % V (Val of step size)
[t0,y0,t1,y1,y_ss,n] = AutoAnalysis(test_num);
[k1, m_e, d_e] = DOF1EvalParam(t0, t1, y0, y1, y_ss, U, n);

% From 
% %% From CLOSED LOOP control, use control effort, encoder 1 position, and k1 to determine N to V conversion
% control_effort = 0.6618; % Motor outpout in [V]
% encoder_position = 995; % Encoder position in [counts]
% encoder_position = encoder_position/560/100 ; % Encoder position in [m]
% motor_force = k1*encoder_position; % Force applied by motor in [N]
% N2V = motor_force/control_effort; % Conversion from N to V

%% Experiment 2 to find Sys1 Paramters (1DOF holding Sys2)
% k_eff = k1 + k2, m_eff = m1, d_eff = d1
test_num = 2;
U = 0.5*ones(1,5); % V (Val of step size)
[t0,y0,t1,y1,y_ss,n] = AutoAnalysis(test_num);
[k_e, m1, d1] = DOF1EvalParam(t0, t1, y0, y1, y_ss, U, n);

k2.avg = k_e.avg - k1.avg;

%% Experiment 3 to find Sys2 Paramters (1DOF holding Sys1)
% k_eff = k2, m_eff = m2, d_eff = d2
test_num = 1;
U = 2 * (560) * (k2.avg) * ones(1,5); % V (Val of step size)
[t0,y0,t1,y1,y_ss,n] = AutoAnalysis(test_num);
[k_e, m2, d2] = DOF1EvalParam(t0, t1, y0, y1, y_ss, U, n);

%% Results

disp("Experimentally Determined Parameters: SYS1")
fprintf("Mass: %.4g V*s^2/Count\n", m1.avg);
fprintf("Damping Ratio: %.4g V*s/Count\n", d1.avg)
fprintf("Spring Constant: %.4g V/Count\n\n", k1.avg)

disp("Experimentally Determined Parameters: SYS2")
fprintf("Mass: %.4g V*s^2/Count\n", m2.avg);
fprintf("Damping Ratio: %.4g V*s/Count\n", d2.avg)
fprintf("Spring Constant: %.4g V/Count\n\n", k2.avg)