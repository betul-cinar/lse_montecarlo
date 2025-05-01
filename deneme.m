close all;
clc;
clear;

%%%%%%%%%%%%%% USER INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n = 3; %HOW MANY CONES?


%WE START TO SIMULATE SUN-SUNSENSOR INTERACTION HERE

coeff = load("coeff_sensor.mat");
coeff_inv = load("coeff_inverse.mat");

%USER INPUT
sensor_el = [0, 35.26, 69.09];
sensor_az = [20.905, 45, 0];
%SUN COMING 
sun_az = 40;
sun_el = 38;



for i=1:n

 sens_val(i) = compute_photodiode(sensor_el(i), sensor_az(i), sun_el, sun_az, coeff);
 if sens_val(i) > 1  %i guarantee that sensor value with noise is no bigger than 1

     temp = sens_val(i) - 1;
     sens_val(i) = sens_val(i) - 2*temp;
 end

  halfangle_deg(i) = (1 - sens_val(i)) * 90;
  % halfangle_deg(i) = photodiode_model_inverse(sens_val(i), coeff_inv);
end


 halfangle = halfangle_deg .* (pi/180);                   

% Define cone directions (unit vectors)
az_el = [20.905,   0;%1
         45,     35.26;%7
         0,     69.09];%11


for i=1:n
    % for j=1:3
    normalVec(i,:) = sph2cart_unit(az_el(i,:));
end

for i=1:n 
    
        nv(i,:) =normalVec(i,:)/norm(normalVec(i,:));
    
end    


% Create a figure for plotting
figure('Name','Three Cones Intersection Approximation');
hold on; axis equal; grid on;                             
xlabel('X'); ylabel('Y'); zlabel('Z');
title('Three Cones and Their Approximate Intersection');
view(3);

% Plot the three cones
plotCone(halfangle(1), nv(1,:), 'b');
plotCone(halfangle(2), nv(2,:), 'g');
plotCone(halfangle(3), nv(3,:), 'm');

% Least Squares Optimization
% Initial guess (average of the three normal vectors)
u0 = (nv(1,:) + nv(2,:) + nv(3,:)) / norm(nv(1,:) + nv(2,:) + nv(3,:));

% Define anonymous function for residuals
residualFunc = @(u) coneResiduals(n, u, nv, halfangle);      

% Solve using lsqnonlin
options = optimoptions('lsqnonlin', 'Display', 'iter');
u_solution = lsqnonlin(residualFunc, u0, [], [], options);

% Display the solution
disp('Approximate intersection vector:');
disp(u_solution);

% Plot the approximate intersection
quiver3(0, 0, 0, u_solution(1), u_solution(2), u_solution(3), 1, 'r', 'LineWidth', 3);

% Check residuals for the solution
r1 = dot(u_solution, nv(1,:)) - cos(halfangle(1));
r2 = dot(u_solution, nv(2,:)) - cos(halfangle(2));
r3 = dot(u_solution, nv(3,:)) - cos(halfangle(3));
r4 = norm(u_solution)^2 - 1; % Ensure unit vector constraint

disp('Residuals for the solution:');
disp(['r1 (nv1 constraint): ', num2str(r1)]);
disp(['r2 (nv2 constraint): ', num2str(r2)]);
disp(['r3 (nv3 constraint): ', num2str(r3)]);
disp(['r4 (unit vector constraint): ', num2str(r4)]);






