clc;
clear;
close all;

dta = load('data.mat');

x= dta.x .* 90/(dta.x(1) - dta.x(140));
y = dta.y .* 1/ dta.y(1);
x = x(1:140);
x = flip(x);
y = y(1:140);
x(140) = 90;
p_inv = polyfit(y,x,4);


% x1 = linspace(0,1);
% y1 = polyval(p,x1);
% figure
% plot(y,x,'o')
% hold on
% plot(y1,x1,'r--')
% legend('y','y1','f1')        %JUST IGNORE THIS PART, i took 'p_inv' as
%                                   inverse coeff matrix even though i dont
%                                   plot them