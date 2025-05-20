
clc;
clear;
close all;


geometry_names = {'Icosahedron', 'Truncated Icosahedron'};
mean_errors = [1.3601, 0.8421];
sensor_counts = [12, 20];

opt_value = 1 ./ (mean_errors .* sensor_counts);

figure;
bar(opt_value);
set(gca, 'XTickLabel', geometry_names);
ylabel('Optimization Value (1 / Error × Sensors)');
title('Performance per Cost Comparison');
grid on;



