clear all; clc; close all;

m1 = 4.57e-6; m2 = 1.308e-5;
k1 = 1.813e-3; k2 = 1.278e-3;
d1 = 5.61e-5; d2 = 1.6065e-4;

b2 = m2; b1 = d2; b0 = k2;
a4 = m1*m2; a3 = m1*d2 + m2*d1;
a2 = k2*m1 + (k1+k2)*m2 + d1*d2;
a1 = (k1+k2)*d2 + k2*d1; a0 = k1*k2;

G1 = tf(1,[m2 d2 k2]);
G2 = tf(1,[m1 d1 k1+k2]);
G3 = tf([b2 b1 b0],[a4 a3 a2 a1 a0]);

G_ar = [G1;G2;G3];

t_0 = []; y_0 = []; t_n = []; y_n = []; y_inf = []; n_out = [];
for m = 1:3 % Set test id
    for n = 1 % Trials of same test

        switch m % Find Experiment # used in the report from test_id (they're different)
            case 1
                exp_num = 3;
            case 2
                exp_num = 2;
            case 3
                exp_num = 1;
        end

        filename = sprintf('Data/Open_Loop/test_%d_%d.mat',m,n);
        data = load(filename).data;    
        
        % Cut last third of data for test 1 (Some error near end)
        if m == 1
            data = data(1:floor(2*end/3),:);
        end
    
        % Take first half of data for tests 2, 3 (Before motor resets)
        if m > 1
            data = data(1:floor(end/2),:); 
        end
    
        t = data(:,2);
    
        y = data(:,4);
    
        % Flip signs for positive convention for tests 2, 3
        if m > 1
            y = -y;
        end
    
        % Redefine t_0 as start of step input for test 1
        if m == 1
            start_index = find(y > 168,1) - 6; % Determined by trial/error
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
            if y_peaks(k) < y_inf_n + peak_threshold(m) * amplitude
                y_peaks(k) = [];
                t_peaks(k) = [];
            end
        end
    
        % Find max peak for t_0, y_0
        [y_max_peak, index_max_peak] = max(y_peaks);
        t_max_peak = t_peaks(index_max_peak);
    
        % Ready parameters for return
        t_0 = [t_0; t_max_peak]; y_0 = [y_0; y_max_peak];
        t_n = [t_n; t_peaks(end)]; y_n = [y_n; y_peaks(end)];
        y_inf = [y_inf; y_inf_n]; n_out = [n_out length(t_peaks)-index_max_peak];

        end_index = find(t >= 2.5,1,'first');
        t_plot = t(1:end_index);
        y_plot = y(1:end_index);

        t_points = [t_max_peak;t_peaks(end);t_plot(floor(end*0.95))];
        y_points = [y_max_peak;y_peaks(end);y_plot(floor(end*0.95))];

       % Uncomment for visual representation of analysis
        if m > 2
            figure(m)
        else
            subplot(1,2,m);
        end
        plot(t_plot,y_plot,'k-','LineWidth',2);
        hold on;
        [y_step, t_step] = step(G_ar(m),2.5);
        plot(t_step,y_step,'r:','LineWidth',2)
        plot(t_points,y_points,'r.','MarkerSize',10);
        xlim([t_step(1) t_step(end)]);
        title(sprintf('Step Response, Experiment %d',exp_num));
        ylabel('Position [counts]'); xlabel('Time [s]');
        legend('Experimental','Simulated','Location','southeast')
        set(gca,'FontSize',14);
    end
end

