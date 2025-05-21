clc;
clear;
close all;

% Load data
error_map_20 = load("ERRROR_MAP_n20_MAE.mat");
overallMean_20 = mean(error_map_20.ERROR_MAP, 'all');

error_map_12 = load("ERRROR_MAP_n12_MAE.mat");
overallMean_12 = mean(error_map_12.ERROR_MAP, 'all');

error_map_jspringer = load("ERROR_MAP_JSPRINGER.mat");
overallMean_jspringer = mean(error_map_jspringer.ERROR_MAP, 'all');

error_map_jwang = load("ERROR_MAP_JWANG.mat");
overallMean_jwang = mean(error_map_jwang.ERROR_MAP, 'all');

% Calculate percentage of values <= 1 for error_map_20
numBelowOne_20 = sum(error_map_20.ERROR_MAP(:) <= 1);
totalPoints_20 = numel(error_map_20.ERROR_MAP);
percentageBelowOne_20 = (numBelowOne_20 / totalPoints_20) * 100;


% Calculate percentage of values <= 1 for error_map_12
numBelowOne_12 = sum(error_map_12.ERROR_MAP(:) <= 1);
totalPoints_12 = numel(error_map_12.ERROR_MAP);
percentageBelowOne_12 = (numBelowOne_12 / totalPoints_12) * 100;

% Calculate percentage of values <= 1 for error_map_20
numBelowOne_jspringer = sum(error_map_jspringer.ERROR_MAP(:) <= 1);
totalPoints_jspringer = numel(error_map_jspringer.ERROR_MAP);
percentageBelowOne_jspringer = (numBelowOne_jspringer / totalPoints_jspringer) * 100;

% Calculate percentage of values <= 1 for error_map_20
numBelowOne_jwang = sum(error_map_jwang.ERROR_MAP(:) <= 1);
totalPoints_jwang = numel(error_map_jwang.ERROR_MAP);
percentageBelowOne_jwang = (numBelowOne_jwang / totalPoints_jwang) * 100;

% Display the results
fprintf('n = 20 → Mean Error: %.4f | Points ≤ 1: %d (%.2f%%)\n', ...
    overallMean_20, numBelowOne_20, percentageBelowOne_20);

fprintf('n = 12 → Mean Error: %.4f | Points ≤ 1: %d (%.2f%%)\n', ...
    overallMean_12, numBelowOne_12, percentageBelowOne_12);

fprintf('n = jspringer → Mean Error: %.4f | Points ≤ 1: %d (%.2f%%)\n', ...
    overallMean_jspringer, numBelowOne_jspringer, percentageBelowOne_jspringer);

fprintf('n = jwang → Mean Error: %.4f | Points ≤ 1: %d (%.2f%%)\n', ...
    overallMean_jwang, numBelowOne_jwang, percentageBelowOne_jwang);
