function [h, Nu, Re] = calculateParameters(tempC, flowSpeedPct, longFlag)
%CALCULATEPARAMETERSFROMDATA Calculates the heat transfer coefficient,
%Nusselt number, and Reynolds number, given temperature in Celsius,
%percentage flow speed, and whether or not it is a long experiment (false
%for short, true for long)

%% Define constants
L = 0.007; % Distance from plate to end of duct in [m]
nu = 2.317*10^5; % kinematic viscosity of air in [m^2/s]
p = 0.9413; % density of air in [kg/m^3]
mu = p*nu; % dynamic viscosity of air in [kg/(m s)]
c = 1010.6; % heat capacity of air in [J/(kg K)]
k = 3.186*10^-2; % thermal conductivity in [W/(m K)]
A = 3.723*10^-3; % area of the disk in [m^2]

%% Calculate flow speed, Re
flowSpeedMs = flowSpeed(flowSpeedPct,false); % Flow speed in [m/s]

Re = flowSpeedMs*L/nu; % Reynolds number, unitless

%% Load data
if longFlag
    fileName = sprintf('Data/Long/temp%dCwind%d.csv',tempC,flowSpeedPct);
else
    fileName = sprintf('Data/Short/temp%dCwind%d.csv',tempC,flowSpeedPct);
end
data = readmatrix(fileName);

%% Calculate qdot
V_heater = mean(data(:,3));
V_sense = mean(data(:,6));
V = V_heater - V_sense;
R_sense = 5; % Resistor of sensor in [Ohm], uncertainty of 0.01
I = V/R_sense;
P = V * I;
qdot = P/A;

%% Calculate h, Nu, and return
T1 = mean(data(:,2));
T2 = mean(data(:,6));

h = qdot/(T1-T2); % heat transfer coefficient in [W/(m^2*K)]

Nu = qdot*L/(k*(T1-T2)); % Nusselt number, unitless
end

