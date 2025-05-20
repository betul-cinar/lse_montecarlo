% Load the image (replace with your uploaded file path if needed)
img = imread('jspringer_SFH2430.png');

% Display the image
figure;
imshow(img);
title('Click on the curve points (press Enter when done)');

% Let user manually select points
[x, y] = ginput();  % Clicked points on image
data_matrix.x = x;
data_matrix.y = y;

% Plot selected points for confirmation
hold on;
plot(x, y, 'r.-', 'MarkerSize', 15);
hold off;

% Display data matrix
disp('Extracted pixel coordinates:');
disp(data_matrix);

% Optionally save to file
save('directional_data_pixels.mat', 'data_matrix');
