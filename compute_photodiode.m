function photodiode_value = compute_photodiode(sensor_el, sensor_az, sun_el, sun_az, coeff)
    % compute_photodiode computes a photodiode reading with Gaussian error applied
    %
    % Inputs:
    %   sensor_el : Sensor elevation angle (in degrees)
    %   sensor_az : Sensor azimuth angle (in degrees)
    %   sun_el    : Sun elevation angle (in degrees)
    %   sun_az    : Sun azimuth angle (in degrees)
    %   coeff     : Structure containing coefficients for the photodiode model 
    %               (e.g., coeff.p = [p1, p2])
    %
    % Output:
    %   photodiode_value : The computed photodiode sensor reading
    %
    % Example usage:
    %   coeff.p = [1.0, 0.1];
    %   value = compute_photodiode(0, 20.905, 0, 20, coeff);
    
    % Add Gaussian noise to the sun angles
    error_val = randn(1, 1);
    sun_el_noisy = sun_el + error_val;
    sun_az_noisy = sun_az + error_val;
    
    % Calculate the angle difference between the noisy sun position and sensor
    diff_angle = sun_sensor_angle_diff(sun_el_noisy, sun_az_noisy, sensor_el, sensor_az);
    
    % Compute the photodiode value using the sensor model
    photodiode_value = photodiode_model(diff_angle, coeff.p);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Nested function: Calculate the angle difference
  function angle_diff = sun_sensor_angle_diff(sun_el, sun_az, sensor_el, sensor_az)
    % Convert degrees to radians
    sun_el_rad = deg2rad(sun_el);
    sun_az_rad = deg2rad(sun_az);
    sensor_el_rad = deg2rad(sensor_el);
    sensor_az_rad = deg2rad(sensor_az);
    
    % Construct the sun's direction unit vector
    % Using: x = cos(el)*cos(az), y = cos(el)*sin(az), z = sin(el)
    sun_vec = [cos(sun_el_rad)*cos(sun_az_rad), cos(sun_el_rad)*sin(sun_az_rad), sin(sun_el_rad)];
    
    % Construct the sensor normal's direction unit vector
    sensor_vec = [cos(sensor_el_rad)*cos(sensor_az_rad), cos(sensor_el_rad)*sin(sensor_az_rad), sin(sensor_el_rad)];
    
    % Compute the dot product of the two vectors
    dot_product = dot(sun_vec, sensor_vec);
    
    % Clamp dot_product to the interval [-1, 1] to avoid numerical issues with acos
    dot_product = max(min(dot_product, 1), -1);
    
    % Compute the angular difference in radians using the arccosine
    angle_rad = acos(dot_product);
    
    % Convert the result from radians to degrees
    angle_diff = rad2deg(angle_rad); % bound on [0,180] deg
  end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Nested function: Photodiode model computation
  function y = photodiode_model(x, coeff)
    y =  x.^10 .* coeff(1) + x.^9 .* coeff(2)+ x.^8 .* coeff(3)+ x.^7 .* coeff(4)+...
         x.^6 .* coeff(5)+ x.^5 .* coeff(6)+ x.^4 .* coeff(7)+ x.^3 .* coeff(8)+...
         x.^2 .* coeff(9) + x .* coeff(10) + coeff(11);

    % Clip after 90 half angle for realistic sun sensor
    if x > 90 
        y = 0;
    end

    %photodiode value will be between 0 and 1
    y = max(min(y, 1), 0);

  end

end
