function v_avg = flowSpeed(percentFlow, plots)

r_outter = 1.2;
in2m = 0.0254;
r = linspace(0, r_outter, 4) .* in2m;
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

c = polyfit(r, v_data, 2);
v_profile = @(x) c(1).*x.^2 + c(2).*x + c(3);

if (plots)
    u2mm = 1000;
    r_plot = linspace(0, r_outter, 40) .* in2m;
    
    hold on;
    plot(r_plot*u2mm, v_profile(r_plot));
    title("Velocity Flow vs Radial Pipe Axis")
    ylabel("Velocity (m/s)")
    xlabel("Radial Axis (mm)")
    xlim([r(1)*u2mm, r(end)*u2mm])
end

%% Return avg value with integral of velocity time r all divided by area
fuc = @(x) x .* v_profile(x);
q = 2 * pi * integral(fuc, r(1), r(end));

v_avg = q / (pi * r(end)^2);

end