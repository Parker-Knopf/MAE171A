clear all; clc; close all;

%% Initialize results struct (extra fields included just in case)
results = struct('h',[],'Nu',[],'Re',[],'tempC',[],'flowSpeedPct',[],'longFlag',[]);

%% Collect long data
longTemps = [75 100 125 150];
longSpeeds = [35 55 75 100];
nLong = length(longTemps);
for i=1:nLong
    tempC = longTemps(i);
    flowSpeedPct = longSpeeds(i);
    [h, Nu, Re] = calculateParameters(tempC,flowSpeedPct,true);
    results.h(end+1) = h;
    results.Nu(end+1) = Nu;
    results.Re(end+1) = Nu;
    results.tempC(end+1) = Nu;
    results.flowSpeedPct(end+1) = Nu;
    results.longFlag(end+1) = true;
end

%% Collect short data
shortTemps = [75 100 125 150];
shortSpeeds = [35 45 55 75 85 100];
for tempC = shortTemps
    for flowSpeedPct = shortSpeeds
        [h, Nu, Re] = calculateParameters(tempC,flowSpeedPct,false);
        results.h(end+1) = h;
        results.Nu(end+1) = Nu;
        results.Re(end+1) = Nu;
        results.tempC(end+1) = Nu;
        results.flowSpeedPct(end+1) = Nu;
        results.longFlag(end+1) = true;
    end
end

%% Sort results struct by Reynolds number
[results.Re,sortIndex] = sort(results.Re);
results.h = results.h(sortIndex);
results.Nu = results.Nu(sortIndex);
results.tempC = results.tempC(sortIndex);
results.flowSpeedPct = results.flowSpeedPct(sortIndex);
results.longFlag = results.longFlag(sortIndex);

%% Plot h and Nu by sqrt(Re)
subplot(1,2,1); hold on; box on; grid on;
plot(sqrt(results.Re),results.h,'r-','LineWidth',2);
xlabel('$\sqrt{Re}$','Interpreter','latex');
ylabel('h [W/m^2K]');
legend('Heat Transfer Coefficient, h','Location','northwest');
set(gca,'FontSize',14)


subplot(1,2,2); hold on; box on; grid on;
plot(sqrt(results.Re),results.Nu,'k-','LineWidth',2);
xlabel('$\sqrt{Re}$','Interpreter','latex');
ylabel('Nu');
legend('Nusselt Number, Nu','Location','northwest');
set(gca,'FontSize',14)
