clear all; close all; clc;

s = tf('s');

parameters

%% Coefficents

b2 = m2;
b1 = d2;
b0 = k2;
a4 = m1*m2;
a3 = m1*d2 + m2*d1;
a2 = k2*m1 + (k1 + k2)*m2 + d1*d2;
a1 = (k1 + k2)*d2 + k2*d1;
a0 = k1 * k2;

%% RLocus

% Design Parameters: Overshoot 25%

G1 = tf((b2*s^2 + b1*s + b0) / (a4*s^4 + a3*s^3 + a2*s^2 + a1*s + a0));
G2 = tf((b0) / (a4*s^4 + a3*s^3 + a2*s^2 + a1*s + a0));

L1 = G1;
figure(1);
rlocus(L1);

%kp = 0.05
kp = 0.5;

L2 = s / (G1 + kp);
figure(2);
rlocus(L2);

%kd = 0.004
kd = .03;

L3 = 1 / (s* (G1 + kp + kd*s));
figure(3);
rlocus(L3);

ki = .5;