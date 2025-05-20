clc; clear; close all;

% === Golden ratio
phi = (1 + sqrt(5)) / 2;

% === Vertices (from known construction of rhombicosidodecahedron)
coords = [
    % These are the 60 vertices of the rhombicosidodecahedron
    0, 1, 3*phi;
    0, 1, -3*phi;
    0, -1, 3*phi;
    0, -1, -3*phi;
    1, 3*phi, 0;
    1, -3*phi, 0;
    -1, 3*phi, 0;
    -1, -3*phi, 0;
    3*phi, 0, 1;
    3*phi, 0, -1;
    -3*phi, 0, 1;
    -3*phi, 0, -1;
    phi, 2, 2*phi;
    phi, 2, -2*phi;
    phi, -2, 2*phi;
    phi, -2, -2*phi;
    -phi, 2, 2*phi;
    -phi, 2, -2*phi;
    -phi, -2, 2*phi;
    -phi, -2, -2*phi;
    2, 2*phi, phi;
    2, 2*phi, -phi;
    2, -2*phi, phi;
    2, -2*phi, -phi;
    -2, 2*phi, phi;
    -2, 2*phi, -phi;
    -2, -2*phi, phi;
    -2, -2*phi, -phi;
    2*phi, phi, 2;
    2*phi, phi, -2;
    2*phi, -phi, 2;
    2*phi, -phi, -2;
    -2*phi, phi, 2;
    -2*phi, phi, -2;
    -2*phi, -phi, 2;
    -2*phi, -phi, -2;
    2*phi, 2, phi;
    2*phi, 2, -phi;
    2*phi, -2, phi;
    2*phi, -2, -phi;
    -2*phi, 2, phi;
    -2*phi, 2, -phi;
    -2*phi, -2, phi;
    -2*phi, -2, -phi;
    phi, 2*phi, 2;
    phi, 2*phi, -2;
    phi, -2*phi, 2;
    phi, -2*phi, -2;
    -phi, 2*phi, 2;
    -phi, 2*phi, -2;
    -phi, -2*phi, 2;
    -phi, -2*phi, -2;
    1, phi, 3*phi;
    1, phi, -3*phi;
    1, -phi, 3*phi;
    1, -phi, -3*phi;
    -1, phi, 3*phi;
    -1, phi, -3*phi;
    -1, -phi, 3*phi;
    -1, -phi, -3*phi;
];

% Normalize coordinates for radius = 1
coords = coords ./ vecnorm(coords, 2, 2);

% === Faces (just 5 shown for brevity — full model has 62 faces: 20 triangles, 30 squares, 12 pentagons)
% Let's define a few square faces manually to test:
faces = [
    1, 13, 21, 5;
    1, 5, 37, 29;
    1, 29, 9, 53;
    1, 53, 3, 13;
    3, 53, 9, 15;
    5, 21, 37, 29;
];

% === Loop to compute azimuth & elevation
azimuths = zeros(size(faces, 1), 1);
elevations = zeros(size(faces, 1), 1);

for i = 1:size(faces, 1)
    verts = coords(faces(i,:), :);
    centroid = mean(verts, 1);
    normal = centroid / norm(centroid);

    x = normal(1); y = normal(2); z = normal(3);

    az = atan2d(y, x);
    if az < 0
        az = az + 360;
    end

    el = atan2d(z, sqrt(x^2 + y^2));

    azimuths(i) = az;
    elevations(i) = el;
end

% Display results
T = table((1:size(faces,1))', azimuths, elevations, ...
          'VariableNames', {'FaceID', 'Azimuth_deg', 'Elevation_deg'});
disp(T)
