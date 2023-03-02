close all; clear all; clc;

l1 = .120461;
l2 = .1085;
l3 = .1148;
l4 = 0;
l5 = .0893;
l6 = .0864;

w = .013;
t = 0.0032;

figure(1)
test1 = charStressStrain(1, l1, w*t)
figure(2)
test2 = charStressStrain(2, l2, w*t)

sy = mean([test1.sy, test2.sy]);
sut = mean([test1.sut, test2.sut]);
e = mean([test1.e, test2.e]);
