close all;
clc;
clear;

%%%%%%%%%%%%%% USER INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define cones with different half-angles
n = 42; %HOW MANY CONES?


%WE START TO SIMULATE SUN-SUNSENSOR INTERACTION HERE

coeff = load("coeff_sensor_sfh.mat");
coeff_inv = load("coeff_inverse_sfh.mat");

%USER INPUT
sensor_az_body = [ ...
    90.0, 126.0, 90.0, 108.4, 54.0, 67.9, 48.6, 112.1, 131.4, 71.6, ...
    50.9, 23.0, 19.3, 160.7, 129.1, 157.0, 90.0, 12.2, 11.4, 168.6, ...
    167.8, 270.0, 234.0, 270.0, 251.6, 306.0, 292.1, 311.4, 247.9, ...
    228.6, 288.4, 309.1, 337.0, 340.7, 199.3, 230.9, 203.0, 270.0, ...
    347.8, 348.6, 191.4, 192.2 ];

sensor_el_body = [ ...
    37.4, 10.8, 19.3, 5.9, 10.8, 44.5, 28.2, 44.5, 28.2, 5.9, ...
    64.8, 32.3, 1.4, 1.4, 64.8, 32.3, 79.2, 53.4, 17.7, 17.7, ...
    53.4, 37.4, 10.8, 19.3, 5.9, 10.8, 44.5, 28.2, 44.5, 28.2, ...
    5.9, 64.8, 32.3, 1.4, 1.4, 64.8, 32.3, 79.2, 53.4, 17.7, ...
    17.7, 53.4 ];

%SUN COMING 
sun_el = 20;
sun_az = 60;


% Define cone directions (unit vectors)
az_el = [sensor_az_body' sensor_el_body' ];



for i=1:n
    
    sens_val(i) = compute_photodiode(sensor_el_body(i), sensor_az_body(i), sun_el, sun_az, coeff);
    
    % halfangle_deg(i) = (1 - sens_val(i)) * 90;
    halfangle_deg(i) = photodiode_model_inverse(sens_val(i), coeff_inv);
end


 halfangle = halfangle_deg .* (pi/180);      

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ekleme

a =0;
for i=1:n

    if halfangle_deg(i) < 55 && halfangle_deg(i) > 0
        a = a+1;
        sel_numbers(a) = i; % to keep the track of selected sensor numbers
        sel_azel(a,:) = az_el(i,:);
        
    end
end

% if a == 0
%     return 
% end


   

for i=1:a
    % for j=1:3
    nv_sel(i,:) = sph2cart_unit(az_el(sel_numbers(i),:));
    halfangle_sel(i) = halfangle(sel_numbers(i));
end
% 
% for i=1:a 
% 
%         nv_sel(i,:) =normalVec(i,:)/norm(normalVec(i,:));
% 
% end    














% Create a figure for plotting
figure('Name','Three Cones Intersection Approximation');
hold on; axis equal; grid on;                             
xlabel('X'); ylabel('Y'); zlabel('Z');
title('Selected Sensors FOVs and Their Approximate Intersection');
view(3);


colors = ['b','g','m','c','y','r'];
for j = 1:a
    colorChoice = colors(mod(j-1, length(colors))+1);
    plotCone(halfangle_sel(j), nv_sel(j, :), colorChoice,true);

    if j ==3
        plotCone(halfangle_sel(j), nv_sel(j, :), colorChoice,false);

    end
end

%Least Squares Optimization
%Initial guess (average of the three normal vectors) ??? CHECK !
upper = 0;
for i= 1:a
    upper = upper + nv_sel(i,:);
end
u0 = upper/ norm(upper);
% u0 = (nv_sel(1,:) + nv_sel(2,:) + nv_sel(3,:)) / norm(nv_sel(1,:) + nv_sel(2,:) + nv_sel(3,:));

% Define anonymous function for residuals
residualFunc = @(u) coneResiduals(a, u, nv_sel, halfangle_sel);      


% Solve using lsqnonlin
options = optimoptions('lsqnonlin', 'Display', 'iter');
u_solution = lsqnonlin(residualFunc, u0, [], [], options);

% Display the solution
disp('Approximate intersection vector:');
disp(u_solution);

display(  rad2deg(  atan2( u_solution(3), sqrt(  sum(u_solution(1:2).^2 )  )  )  )  );
display( rad2deg(atan2(u_solution(2), u_solution(1))));
% Plot the approximate intersection
% quiver3(0, 0, 0, u_solution(1), u_solution(2), u_solution(3), 1, 'r', 'LineWidth', 3);

% Plot the approximate intersection
h_intersection = quiver3(0, 0, 0, u_solution(1), u_solution(2), u_solution(3), 1, 'r', 'LineWidth', 3, 'DisplayName','LS Estimated Sun Vector');

% Add legend
legend






