% N. Boechler 1/23/23
% Example for 2DOF translational system; fixed-free, onsite dampers

clc;
clear all;
close all;

% system parameters

% k1=5; % N/m
% k2=1; % N/m 
% d1=0.2; % Ns/m
% d2=0.2; % Ns/m
% m1=1; % kg
% m2=1; % kg

m1=4.57e-6;         % Mass/inertia m1                     
d1=5.61e-5;         % Damping that connects m1 to ground  
k1=0.001758;         % Spring that connect m1 to ground

m2=4.57e-6;         % Mass/inertia m2                     
d2=5.61e-5;         % Damping that connects m2 to ground 
k2=0.00133;         % Spring that connects m1 and m2  


kp=50;
kd=12;
ki=53;

%kp=50;
%kd=12;
%ki=53;

cycles_open=2;
cycles_control=2;

% setup state space

A=[0 1 0 0; ...
    (-k2-k1)/m1 -d1/m1 k2/m1 0; ...
    0 0 0 1; ...
    k2/m2 0 -k2/m2 -d2/m2];

B = zeros(4,1);
B(2,1) = 1; % select input
C = zeros(2,4);
C(1,1)=1; % select outputs
C(2,3)=1; % select outputs
C_siso=zeros(1,4);
C_siso(1,1)=1;
D = zeros(2,1);
D_siso=0;


mysys=ss(A,B,C,D);

mysys_siso=ss(A,B,C_siso,D_siso);
%size(mysys_siso)


% section for control (start)
[C_pi,info] = pidtune(mysys_siso,'PID')

controlsys=pid(kp,ki,kd,0);
%size(controlsys)

totalsys=feedback(mysys_siso*controlsys,1);
%section for control (end)


% step response
wn=sqrt(k2/m1); % choose a characteristic time
Tp=2*pi/wn; % characteristic period [s]
dt=Tp*1E-2; % timestep [s]
T = Tp*cycles_open; % simulated time [s]

t=[0:dt:T];

y=step(mysys,t);

figure(01)
subplot(221)
plot(t,y(:,1),'LineWidth',2);
set(gca,'FontSize',20,'LineWidth',2);
xlabel('time [s]');
ylabel('x_1 [m]')
ylim(1.1*[min(y(:,1)) max(y(:,1))])

subplot(222)
plot(t,y(:,2),'LineWidth',2);
set(gca,'FontSize',20,'LineWidth',2);
xlabel('time [s]');
ylabel('x_2 [m]')
ylim(1.1*[min(y(:,2)) max(y(:,2))])


%%

% open Bode
[mag,phase,wout] = bode(mysys);

mag_out=mag(:,1,:);

subplot(223)
plot(wout,mag_out(1,:),'LineWidth',2);
set(gca,'FontSize',20,'LineWidth',2);
xlabel('frequency [rad/s]');
ylabel('x_1 [dB]')
ylim([0 1.1*max(mag_out(1,:))])
xlim([0 5*wn]);

subplot(224)
plot(wout,mag_out(2,:),'LineWidth',2);
set(gca,'FontSize',20,'LineWidth',2);
xlabel('frequency [rad/s]');
ylabel('x_2 [dB]')
ylim([0 1.1*max(mag_out(1,:))])
xlim([0 5*wn]);

%%

% controller 

figure(03)
subplot(221)
rlocus(totalsys);
set(findall(gcf,'-property','FontSize'),'FontSize',20)
set(findall(gcf,'-property','LineWidth'),'LineWidth',2)

% controlled step

subplot(222)
T_cont = Tp*cycles_control;
t_control=[0:dt:T_cont];
y_control=step(totalsys,t_control);
plot(t_control,y_control,[0 T_cont],mean(y_control)*[1 1],'LineWidth',2);
set(gca,'FontSize',20,'LineWidth',2);
xlabel('time [s]');
ylabel('x_1 [m]')
ylim(0.9*[min(y_control) 1.2*max(y_control)])

steady_error=y_control(end)-1 % output steady state error
transferfunc=tf(totalsys)

subplot(2,2,3)
bode(totalsys);
set(findall(gcf,'-property','FontSize'),'FontSize',20)
set(findall(gcf,'-property','LineWidth'),'LineWidth',2)

subplot(2,2,4)
nyquist(totalsys);
set(findall(gcf,'-property','FontSize'),'FontSize',20)
set(findall(gcf,'-property','LineWidth'),'LineWidth',2)

% syms s;
% [num,den] = tfdata(totalsys,'v');
% p=poly2sym(num,s)/poly2sym(den,s);
% tf_lim = limit(p,s,0)


