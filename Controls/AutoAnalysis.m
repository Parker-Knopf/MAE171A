function [t_0,y_0,t_n,y_n,y_inf,n_out] = AutoAnalysis(test_id)
% AUTO_ANALYSIS Automatically retrieves needed values from controls test,
% given the test id and access to the needed files in the /Data/ folder.
% Returns five column vectors with results from each unique test.

enc2m = 1; %1/560/100; % Y in m

% all_parameters = zeros(5,5,3); % Old matrix return method

t_0 = []; y_0 = []; t_n = []; y_n = []; y_inf = []; n_out = [];
m = test_id;

if m == 3
    iterations = 16;
else
    iterations = 5;
end

for n = 1:iterations % Trials of same test
    
    filename = sprintf('Data/Open_Loop/test_%d_%d.csv',m,n);
    data = readecp(filename);

    % Cut last third of data for test 1 (Some error near end)
    if m == 1
        data = data(1:floor(2*end/3),:);
    end

    % Take first half of data for tests 2, 3 (Before motor resets)
    if m > 1
        data = data(1:floor(end/2),:); 
    end

    t = data(:,2);

    y = enc2m * data(:,4);

    % Flip signs for positive convention for tests 2, 3
    if m > 1
        y = -y;
    end

    % Redefine t_0 as start of step input for test 1
    if m == 1
        start_index = find(y > 168*enc2m,1) - 6; % Determined by trial/error
        t = t(start_index:end);
        y = y(start_index:end);
        t = t - t(1);
        y = y - y(1);
    end

    % Find local peaks
    [y_peaks,max_index] = findpeaks(y);
    t_peaks = t(max_index);

    % For robustness, takes average of last 10 pct of values for y_inf
    y_inf_n = mean(y(floor(end*0.9),end));
    y_max = max(y);
    amplitude = y_max - y_inf_n;

    % Filter out minor peaks for tests (Custom thresholds per test)
    peak_threshold = [0.05,0,0];
    for k = length(y_peaks):-1:1
        if abs(y_peaks(k) - y_inf_n) < peak_threshold(m) * amplitude
            y_peaks(k) = [];
            t_peaks(k) = [];
        end
    end

    % Find max peak for t_0, y_0
    [y_max_peak, index_max_peak] = max(y_peaks);
    t_max_peak = t_peaks(index_max_peak);

    switch m
        case 1
            t_0 = [t_0; t_max_peak]; y_0 = [y_0; y_max_peak];
            t_n = [t_n; t_peaks(5)]; y_n = [y_n; y_peaks(5)];
            y_inf = [y_inf; y_inf_n]; n_out = [n_out 4];
        case 2
            t_0 = [t_0; t_max_peak]; y_0 = [y_0; y_max_peak];
            t_n = [t_n; t_peaks(2)]; y_n = [y_n; y_peaks(2)];
            y_inf = [y_inf; y_inf_n]; n_out = [n_out 1];
        case 3
            t_0 = [t_0; t_max_peak]; y_0 = [y_0; y_max_peak];
            t_n = [t_n; t_peaks(end)]; y_n = [y_n; y_peaks(end)];
            y_inf = [y_inf; y_inf_n]; n_out = [n_out 1];
    end
    % Ready parameters for return
    t_0 = [t_0; t_max_peak]; y_0 = [y_0; y_max_peak];
    t_n = [t_n; t_peaks(end)]; y_n = [y_n; y_peaks(end)];
    y_inf = [y_inf; y_inf_n]; n_out = [n_out length(t_peaks)-index_max_peak];

  % Uncomment for visual representation of analysis
        figure(1);
        hold off;
        plot(t,y);
        hold on;
        plot(t_peaks,y_peaks,'r.','MarkerSize',10);
        title(sprintf('Test Setup %d, Trial %d',m,n));
        ylabel('Position [m]'); xlabel('Time [s]');
        t_peaks
        drawnow();
        w = waitforbuttonpress;
end
end