clear all; clc; close all;

%% Initialize results struct (extra fields included just in case)
results75 = [];
results100 = [];
results125 = [];
results150 = [];

%% Collect long data
longTemps = [75 100 125 150];
longSpeeds = [35 55 75 100];
nLong = length(longTemps);
for i=1:nLong
    tempC = longTemps(i);
    flowSpeedPct = longSpeeds(i);
    [h, Nu, Re] = calculateParameters(tempC,flowSpeedPct,true);
    results = [Re; h; Nu; flowSpeedPct; tempC];
    switch tempC
        case 75
            results75 = [results75 results];
        case 100
            results100 = [results100 results];
        case 125
            results125 = [results125 results];
        case 150
            results150 = [results150 results];
    end
end

%% Collect short data
shortTemps = [75 100 125 150];
shortSpeeds = [35 45 55 75 85 100];
for tempC = shortTemps
    for flowSpeedPct = shortSpeeds
        [h, Nu, Re] = calculateParameters(tempC,flowSpeedPct,false);
        results = [Re; h; Nu; flowSpeedPct; tempC];
        switch tempC
            case 75
                results75 = [results75 results];
            case 100
                results100 = [results100 results];
            case 125
                results125 = [results125 results];
            case 150
                results150 = [results150 results];
        end
    end
end

%% Sort results matrices by Reynolds number
[results75(1,:),sortIndex] = sort(results75(1,:));
for i = 2:size(results75,1)
    vec2change = results75(i,:);
    results75(i,:) = vec2change(sortIndex);
end

[results100(1,:),sortIndex] = sort(results100(1,:));
for i = 2:size(results100,1)
    vec2change = results100(i,:);
    results100(i,:) = vec2change(sortIndex);
end

[results125(1,:),sortIndex] = sort(results125(1,:));
for i = 2:size(results125,1)
    vec2change = results125(i,:);
    results125(i,:) = vec2change(sortIndex);
end

[results150(1,:),sortIndex] = sort(results150(1,:));
for i = 2:size(results150,1)
    vec2change = results150(i,:);
    results150(i,:) = vec2change(sortIndex);
end

%% Plot h and Nu by sqrt(Re)
close all;
figure(1); hold on; box on; grid on;

yyaxis left;
plot(sqrt(results75(1,:)),results75(2,:),'k-','LineWidth',2);
plot(sqrt(results100(1,:)),results100(2,:),'c-','LineWidth',2);
plot(sqrt(results125(1,:)),results125(2,:),'m-','LineWidth',2);
plot(sqrt(results150(1,:)),results150(2,:),'g-','LineWidth',2);

ylabel('h [W/m^2K]');
ylim([0 1.1*max(results75(2,:))]);
set(gca,'YColor','k')

yyaxis right;
plot(sqrt(results75(1,:)),results75(3,:),'k-','LineWidth',2);
plot(sqrt(results100(1,:)),results100(3,:),'c-','LineWidth',2);
plot(sqrt(results125(1,:)),results125(3,:),'m-','LineWidth',2);
plot(sqrt(results150(1,:)),results150(3,:),'g-','LineWidth',2);
fplot(@(re) 0.66*sqrt(re),sqrt([min(results75(1,:)) max(results75(1,:))]),'r--','LineWidth',2);

ylabel('Nu');
ylim([0 1.1*max(results75(3,:))]);
set(gca,'YColor','k')

xlabel('$\sqrt{Re}$','Interpreter','latex');
legend('75C','100C','125C','150C','','','','',...
       'Numerical Prediction',...
       'Location','northwest');
set(gca,'FontSize',14);