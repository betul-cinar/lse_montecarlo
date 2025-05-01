function angle_diff = sun_sensor_angle_diff(sun_el, sun_az, sensor_el, sensor_az)
%SUN_SENSOR_ANGLE_DIFF Computes the angle difference between the sun and sensor normal.
%   angle_diff = sun_sensor_angle_diff(sun_el, sun_az, sensor_el, sensor_az)
%   calculates the angular difference (in degrees) between the sun's direction 
%   (defined by sun_el and sun_az in degrees) and the sensor normal's direction 
%   (defined by sensor_el and sensor_az in degrees).
%
%   Example:
%       diff = sun_sensor_angle_diff(45, 135, 30, 120);

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
    angle_diff = rad2deg(angle_rad);
end
