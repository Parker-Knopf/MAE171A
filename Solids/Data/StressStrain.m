clear all ; close all ; clc

w = 0.0032; % [m]
t = 0.013; % [m]
A = w*t;

test_1 = readtable("PMMA_dogbone_20230210_95857_test1.csv");

strain_raw1 = table2array(test_1(4:end,3));
force_1 = table2array(test_1(4:end,4));

strain_1 = strain_raw1;      % [mm]
stress_1 = force_1 * 1000 / A / 10e5;      % [MPa]
E_1 = mean((stress_1 .* 10^6) ./ (strain_1 .* 10^-3))

subplot(3,1,1)
plot(strain_1,stress_1)
xlabel('Strain (mm)')
ylabel('Stress (MPa)')
title('SS Curve for Test 1')

test_2 = readtable("PMMA_dogbone_20230210_95857_test2.csv");

strain_raw2 = table2array(test_2(311:end,3)); % Extracted data last set of data
force_2 = table2array(test_2(311:end,4)); % Extracted last set of data

strain_2 = strain_raw2 / 1000 * 10e2;      % [mm]
stress_2 = force_2 * 1000 / A / 10e5;   % [MPa]

subplot(3,1,2)
plot(strain_2,stress_2)
xlabel('Strain (mm)')
ylabel('Stress (MPa)')
title('SS Curve for Test 2')

test_3 = readtable("PMMA_dogbone_20230210_104121_2_unloading1.csv");

strain_raw3 = table2array(test_3(1:end-1,2));
force_3 = table2array(test_3(1:end-1,3));

strain_3 = strain_raw3 / 1000 * 10e2;      % [mm]
stress_3 = force_3 * 1000 / A / 10e5;   % [MPa]

subplot(3,1,3)
plot(strain_3,stress_3)
xlabel('Strain (mm)')
ylabel('Stress (MPa)')
title('SS Curve for Test 3') 

% Test 3 fractured before unloading

for i = 0:19

    if (i < 10)
        n = "0"+ num2str(i);
    else
        n = num2str(i);
    end
    t_1(i+1) = importdata(sprintf("Test 1/results/DICe_solution_%s.csv",n));
%     test_1(i+1).data = test_1(:,1)
    t_2(i+1) = importdata(sprintf("Test 2/results/DICe_solution_%s.csv",n));
end



% Strain

Epsilon_yy = diff(v) ./ diff(y)
Epsilon_xx = diff(u) ./ diff(x)

% Poisson Ratio

nu = - (Epsilon_yy ./ Epsilon_xx )