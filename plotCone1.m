function h = plotCone1(halfAngle, normalVec, faceColor)
    % Plot a single cone of unit length with the given halfAngle and direction normalVec.
    % Returns a surface handle `h` for use in legends.

    normalVec = normalVec(:) / norm(normalVec);  % Ensure it's a unit vector

    L = 1; 
    r = L * tan(halfAngle);
    numPoints = 50; 
    theta = linspace(0, 2*pi, numPoints);
    z = linspace(0, L, numPoints)';

    [Theta, Z] = meshgrid(theta, z);
    X = (Z/L)*r .* cos(Theta);
    Y = (Z/L)*r .* sin(Theta);

    % Rotation: align [0;0;1] to normalVec
    refVec = [0; 0; 1];
    crossVal = cross(refVec, normalVec);
    if norm(crossVal) > 1e-15
        rotAxis = crossVal / norm(crossVal);
        angle = acos(dot(refVec, normalVec));
        K = [0            -rotAxis(3)  rotAxis(2);
             rotAxis(3)    0          -rotAxis(1);
            -rotAxis(2)    rotAxis(1)  0        ];
        R = eye(3) + sin(angle)*K + (1 - cos(angle))*(K*K);
    else
        if dot(refVec, normalVec) < 0
            R = [-1  0  0; 
                  0 -1  0; 
                  0  0  1];
        else
            R = eye(3);
        end
    end

    % Apply rotation
    conePoints = R * [X(:)'; Y(:)'; Z(:)'];
    Xr = reshape(conePoints(1,:), size(X));
    Yr = reshape(conePoints(2,:), size(Y));
    Zr = reshape(conePoints(3,:), size(Z));

    % Plot the cone and return its handle
    h = surf(Xr, Yr, Zr, ...
        'FaceColor', faceColor, ...
        'EdgeColor','none', ...
        'FaceAlpha', 0.5);

    % Plot the normal vector (black arrow)
    quiver3(0, 0, 0, normalVec(1), normalVec(2), normalVec(3), ...
        0.8, 'k', 'LineWidth', 2);
end
