clc;
clear;
close all;


dta_sfh = load('SFH2430.mat');
data_sfh.x = dta_sfh.data_matrix.x;
data_sfh.y = dta_sfh.data_matrix.y;



x= data_sfh.x .* 90/(data_sfh.x(1) - data_sfh.x(145));
y = data_sfh.y .* 1/ (data_sfh.y(1) - data_sfh.y(145));
x = x(1:145);
x = flip(x);
% y = -y;
y = y(1:145);
x(145) = 90;
p = polyfit(x,y,10);
p_inv = polyfit(y,x,10);


x1 = linspace(0,90);
y1 = polyval(p,x1);
figure
plot(x,y,'o')
hold on
plot(x1,y1,'r--')
legend('y','y1','f1')       