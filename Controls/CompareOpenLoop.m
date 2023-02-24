clear all; clc; close all;

m1 = 5.016e-06; m2 = 5.405e-06;
d1 = 4.646e-05; d2 = 1.344e-05;
k1 = 0.001759; k2 = 0.001333;

b2 = m2; b1 = d2; b0 = k2;
a4 = m1*m2; a3 = m1*d2 + m2*d1;
a2 = k2*m1 + (k1+k2)*m2 + d1*d2;
a1 = (k1+k2)*d2 + k2*d1; a0 = k1*k2;

G1 = tf(1,[m2 d2 k2]);
G2 = tf(1,[m1 d1 k1+k2]);
G3 = tf([b2 b1 b0],[a4 a3 a2 a1 a0]);

G_ar = [G1;G2;G3];
U = [2 * (560) * (k2); 0.5; 0.5];
t_0 = []; y_0 = []; t_n = []; y_n = []; y_inf = []; n_out = [];
for m = 1:3 % Set test id
    for n = 2 % Trials of same test

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
        figure(m);
        plot(t_plot,y_plot,'k-','LineWidth',2);
        hold on;
        [y_step, t_step] = step(U(m)*G_ar(m),2.5);
        plot(t_step,y_step,'r:','LineWidth',2)
        plot(t_points,y_points,'r.','MarkerSize',10);
        xlim([t_step(1) t_step(end)]);
        title(sprintf('Step Response, Experiment %d',exp_num));
        ylabel('Position [counts]'); xlabel('Time [s]');
        legend('Experimental','Simulated','Location','southeast')
        set(gca,'FontSize',14);

% 
%         % Plot from one test
%         [t0,y0,tn,yn,y_ss,n0] = AutoAnalysis(m);
%         [k0, m0, d0] = DOF1EvalParam(t0, tn, y0, yn, y_ss, U(m), n0);
%         k0 = k0.avg; m0 = m0.avg; d0 = d0.avg;
%         C = 1/k0; wn = sqrt(k0/m0); B = d0/2/sqrt(k0*m0);
%         wd = wn*sqrt(1-B^2); phi = atan((1-B^2)/B);
%         f_actual = @(t) C*U(m)*(1-exp(-B*wn*t)*sin(wd*t + phi));
%         fplot(f_actual,[0 3]);
    end
end

