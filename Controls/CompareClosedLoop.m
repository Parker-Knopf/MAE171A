clear all; clc; close all;

kp = 0.5; kd = 0.03; ki = 0.5;

m1 = 5.016e-06; m2 = 5.405e-06;
d1 = 4.646e-05; d2 = 1.344e-05;
k1 = 0.001759; k2 = 0.001333;

b2 = m2; b1 = d2; b0 = k2;
a4 = m1*m2; a3 = m1*d2 + m2*d1;
a2 = k2*m1 + (k1+k2)*m2 + d1*d2;
a1 = (k1+k2)*d2 + k2*d1; a0 = k1*k2;

% G1 = tf(1,[m2 d2 k2]);
% G2 = tf(1,[m1 d1 k1+k2]);

data = load('Data/Closed_Loop/closed_loop_pid.mat').data;
ref = data(1,3);
final_index = find(data(:,3) == ref,1,'last');
data = data(1:final_index,:);
t = data(:,2);
y = data(:,4);
plot(t,y,'k-','LineWidth',2); hold on;

G3 = tf([b2 b1 b0],[a4 a3 a2 a1 a0]);
D = tf([kd kp ki],[1 0]);
D = D * 1;
T = (D*G3)/(1+G3*D);
[y_step, t_step] = step(ref*T,t(end));
plot(t_step,y_step,'r:','LineWidth',2);

title('PID Controller Step Response, r(t) = 1000 counts');
xlabel('Time [s]'); ylabel('Position [counts]');
legend('Experimental','Simulated','Location','southeast');
set(gca,'FontSize',14);
