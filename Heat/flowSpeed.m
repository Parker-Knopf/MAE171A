flowSpeeds(21, 0)

function v = flowSpeeds(percentFlow, plots)

r = linspace(0, 1.2, 4);
percent = linspace(0, 100, 6);

data = table2array(readtable("Calibration/Flow Calibration Table.csv"));

% Interpolate Data
if ismember(percentFlow, percent)
    data_col = find(percentFlow==percent, 1);
    v_data = data(:, data_col);
else
    diffPercent = abs(percent - percentFlow);
    minPoints = sort(diffPercent);
    lBound = find(diffPercent==minPoints(1), 1);
    diffPercent(lBound) = 0;
    hBound = find(diffPercent==minPoints(2), 1);
    
    ldata = data(:, lBound);
    hdata = data(:, hBound);

    v_data = ldata(:) + (hdata(:) - ldata(:)) .* (percentFlow - percent(lBound)) ./ (percent(hBound) - percent(lBound));
end


[c, ~, ~] = polyfit(r, v_data, 2);

r = linspace(0, 1.2, 40);
v_profile = @(x) c(1).*x.^2 + c(2).*x + c(3);

plot(r, v_profile(r));

%% Return avg value with integral of velocity time r all divided by area
end