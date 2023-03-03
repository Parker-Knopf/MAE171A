close all; clear all; clc;

initalLengths

%% Control Test

w = .013;
t = 0.0032;

figure(1)

tests = [1, 2];
lengths = [l1, l2];
col = ["magenta", "blue"];
sy = zeros(length(tests), 1);
sut = zeros(length(tests), 1);
e = zeros(length(tests), 1);
for i = 1:length(tests)
    test = charStressStrain(tests(i), lengths(i), w*t, 1, 60);
    sy(i) = test.sy;
    sut(i) = test.sut;
    e(i) = test.e;
    SSCruve(test.strain, test.stress, test.sy_e, test.sy, test.sut_e, test.sut, col(i))
end
legend('Control Specimen 1', '', '', 'Control Specimen 2', 'Location', 'southeast')

params.sy = mean(sy);
params.sut = mean(sut);
params.e = mean(e);

Controlparams = params

%% Design Test

w = .01905;
t = 0.0032;

figure(2)

tests = [5, 6];
lengths = [l5, l6];
col = ["magenta", "blue"];
sy = zeros(length(tests), 1);
sut = zeros(length(tests), 1);
e = zeros(length(tests), 1);
for i = 1:length(tests)
    test = charStressStrain(tests(i), lengths(i), w*t, 9, 70);
    sy(i) = test.sy;
    sut(i) = test.sut;
    e(i) = test.e;
    SSCruve(test.strain, test.stress, test.sy_e, test.sy, test.sut_e, test.sut, col(i))
end
legend('Control Specimen 1', '', '', 'Control Specimen 2', 'Location', 'southeast')

params.sy = mean(sy);
params.sut = mean(sut);
params.e = mean(e);

Designparams = params

function p = SSCruve(strain, stress, sy_e, sy, sut_e, sut, color)
    plot(strain, stress, 'Color', color)
    xlabel("Strain")
    ylabel("Stress (MPa)")
    grid on;

    plot(sy_e, sy, '.', 'MarkerSize', 20, 'color', color)

    plot(sut_e , sut, '.', 'MarkerSize', 20, 'color', color)
end