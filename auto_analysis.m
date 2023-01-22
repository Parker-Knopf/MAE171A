clear all; clc; close all;
enc2cm = 1/560;
all_parameters = zeros(5,5,3);

for m = 1:3 % Type of test
    for n = 1:5 % Trials of same test
        
        eval(sprintf('data = readecp("test_%d_%d.csv");',m,n));

        % Cut last third of data for test 1 (Some error near end)
        if m == 1
            data = data(1:floor(2*end/3),:);
        end

        % Take first half of data for tests 2, 3 (Before motor resets)
        if m > 1
            data = data(1:floor(end/2),:); 
        end

        t = data(:,2);
        y = enc2cm * data(:,4);

        % Flip signs for positive convention for tests 2, 3
        if m > 1
            y = -y;
        end

        % Redefine t_0 as start of step input for test 1
        if m == 1
            start_index = find(y > 0.3,1) - 6; % Determined by trial/error
            t = t(start_index:end);
            y = y(start_index:end);
            t = t - t(1);
            y = y - y(1);
        end

        % Find local peaks
        [y_peaks,max_index] = findpeaks(y);
        t_peaks = t(max_index);

        % For robustness, takes average of last 10 pct of values for y_inf
        y_inf = mean(y(floor(end*0.9),end));
        y_max = max(y);
        amplitude = y_max - y_inf;

        % Filter out minor peaks for test 1
        peak_threshold = 0.03;
        if m == 1
            for k = length(y_peaks):-1:1
                if y_peaks(k) < y_inf + peak_threshold * amplitude
                    y_peaks(k) = [];
                    t_peaks(k) = [];
                end
            end
        end

        % Save parameters
        t_0 = t_peaks(1); y_0 = y_peaks(1);
        t_n = t_peaks(end); y_n = y_peaks(end);
        all_parameters(:,n,m) = [t_0 y_0 t_n y_n y_inf];

% Uncomment for visual representation of analysis
%         figure(1);
%         hold off;
%         plot(t,y);
%         hold on;
%         plot(t_peaks,y_peaks,'r.','MarkerSize',10);
%         title(sprintf('Test Setup %d, Trial %d',m,n))
%         w = waitforbuttonpress;
    end
end