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

% Preallocation 

x_1 = zeros(2295,19)
x_1disp = zeros(2295,19)
y_1 = zeros(2295,19)
y_1disp = zeros(2295,19)

x_2 = zeros(3273,19)
x_2disp = zeros(3273,19)
y_2 = zeros(3273,19)
y_2disp = zeros(3273,19)

% Epsilon_xx = zeros(3273,18)

for i = 0:19 % number of csv files for each test

    if (i < 10)
        n = "0"+ num2str(i);
    else
        n = num2str(i);
    end

    t_1(i+1) = importdata(sprintf("Test 1/results/DICe_solution_%s.csv",n)); % Test 1
    x_1(: , i+1) = t_1(i+1).data(:,2) % grab x cordinate of each point from test 1
    x_1disp(:, i+1) = t_1(i+1).data(:,4) % grab x displacement data from test 1
    y_1(: , i+1) = t_1(i+1).data(:,3) % grab y cordinate from each point from test 1
    y_1disp(: , i+1) = t_1(i+1).data(:,5) % grab y displacement data from test 1

    t_2(i+1) = importdata(sprintf("Test 2/results/DICe_solution_%s.csv",n)); % Test 2
    x_2(: , i+1) = t_2(i+1).data(:,2)
    x_2disp(: , i+1) = t_2(i+1).data(:,4)
    y_2(: , i+1) = t_2(i+1).data(:,3)
    y_2disp(: , i+1) = t_2(i+1).data(:,5)


% for j = 1:length(x_1disp)
%     Epsilon_xx(: , i+1) = ( x_1disp(:, i+1) - x_1disp(:, i) ) ./ x_1disp(:, i)
% 
% end
%     Epsilon_yy(: , i+1)
    
end



% Strain

Epsilon_yy = diff(v) ./ diff(y)
Epsilon_xx = diff(u) ./ diff(x)

% Poisson Ratio

nu = - (Epsilon_yy ./ Epsilon_xx )
