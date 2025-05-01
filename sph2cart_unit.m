function normalVec = sph2cart_unit(az_el) %OK
    % Convert spherical coordinates (azimuth, elevation) to unit vector
    az = az_el(1);
    el = az_el(2);
    normalVec(3) = sind(el);
    normalVec(2) = cosd(el) * sind(az);
    normalVec(1) = cosd(az) * cosd(el);
end