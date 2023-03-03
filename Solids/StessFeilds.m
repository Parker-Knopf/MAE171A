close all; clear all; clc;

initalLengths

%% Control 

tests1 = [1, 2];
frame1 = [1, 1];
lengths1 = [l1, l2];

w = .013;
t = 0.0032;

p = zeros(length(tests1), 1);
for i = 1:length(tests1)
    figure(i)
    p_y = plotStressFieldControl(tests1(i), frame1(i), 'y' , lengths1(i), w*t);
%     p_x = plotStressFieldControl(tests1(i), frame1(i), 'x' , .013, w*t);
% 
%     p(i) = -p_x.strain_avg / p_y.strain_avg;
end

% p_control = p

%% Design 

tests2 = [5, 6];
frame2 = [9, 9];
lengths2 = [l5, l6];

% Experimentally determined
e = 1.282*10^9;

p = zeros(length(tests1), 1);
for i = 1:length(tests2)
    figure(i+length(tests2))
    p_y = plotStressFieldDesign(tests2(i), frame2(i), 'y' , lengths2(i), e);
%     p_x = plotStressFieldControl(tests2(i), frame2(i), 'x' , .004572, w*t);
% 
%     p(i) = -p_x.strain_avg / p_y.strain_avg;

    xticks([])
    yticks([])
end

% p_design = p