function v_avg = flowSpeed(percentFlow, plots, varargin)

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
    
    if length(varargin) >= 1
        color1 = varargin{1};
        color2 = varargin{1};
    else
        color1 = 'blue';
        color2 = 'red';
    end

    if (length(varargin) >= 2 && varargin{2}==1)
        v_profile = @(x) v_profile(x) ./ max(v_profile(r_plot));
        v_data = v_data ./ max(v_data);
    end

    hold on;
    plot(r*u2mm, v_data, 'o', 'Color', color2, 'LineWidth', 2)
    plot(r_plot*u2mm, v_profile(r_plot), 'Color', color1, 'LineWidth', 2);
    xlim([r(1)*u2mm, r(end)*u2mm])
end

%% Return avg value with integral of velocity time r all divided by area
fuc = @(x) x .* v_profile(x);
q = 2 * pi * integral(fuc, r(1), r(end));

v_avg = q / (pi * r(end)^2);

end