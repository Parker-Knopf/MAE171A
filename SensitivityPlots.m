clear all; clc; close all;

filepaths = ["Data/Closed_Loop/closed_loop_less_weight1.mat";
             "Data/Closed_Loop/closed_loop_pid.mat";
             "Data/Closed_Loop/closed_loop_more_weight1.mat";
             "Data/Closed_Loop/closed_loop_less_weight2.mat";
             "Data/Closed_Loop/closed_loop_pid.mat";
             "Data/Closed_Loop/closed_loop_more_weight2.mat"];

for i = 1:6
    filepath = filepaths(i);
    data = load(filepath).data;
    ref = data(1,3);
    final_index = find(data(:,3) == ref,1,'last');
    data = data(1:final_index,:);
    t = data(:,2);
    y = data(:,4);

    switch i % Determine which figure to plot (1 for mass 1, 2 for mass 2)
        case {1,2,3}
            subplot(2,1,1);
        case {4,5,6}
            subplot(2,1,2);
    end

    switch i % Determine line style
        case {1,4} % For less mass
            linestyle = 'r-';
        case {2,5} % For default mass
            linestyle = 'k-';
        case {3,6} % For more mass
            linestyle = 'b-';
    end

    plot(t,y,linestyle,'LineWidth',2); hold on;

end

for i = 1:2
    subplot(2,1,i);
    title(sprintf('Mass %d Sensitivity Analysis of Closed Loop PID Control',i));
    xlabel('Time [s]'); ylabel('Position [counts]');
    legend('Less mass','Original mass','More mass','Location','southeast');
    set(gca,'FontSize',14);
    ylim([900 1000]);
end
