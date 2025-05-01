clc;
clear;


dta = load('data.mat');

x= dta.x .* 90/(dta.x(1) - dta.x(140));
y = dta.y .* 1/ dta.y(1);
x = x(1:140);
x = flip(x);
y = y(1:140);
x(140) = 90;
p = polyfit(x,y,4);


x1 = linspace(0,90);
y1 = polyval(p,x1);
figure
plot(x,y,'o')
hold on
plot(x1,y1,'r--')
legend('y','y1','f1')       