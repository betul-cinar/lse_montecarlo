function visualizeSunSensorCones(az_el, halfAnglesDeg)
% visualizeSunSensorCones  Plot a set of sun‐sensor cones in 3D.
%
%   visualizeSunSensorCones(az_el, halfAnglesDeg) plots one cone per row of
%   az_el, where az_el is an N×2 array [azimuth_deg, elevation_deg]. halfAnglesDeg
%   is either a scalar (same half‐angle for all) or an N×1 vector (degrees).
%
% Example:
%   az_el = [20.905,  0;
%            90,     21.91;
%            159.095, 0;
%            …           ];
%   halfAngles = repmat(65, size(az_el,1), 1); % all 65°
%   visualizeSunSensorCones(az_el, halfAngles);

    % Ensure sizes match
    n = size(az_el,1);
    if isscalar(halfAnglesDeg)
        halfAnglesDeg = repmat(halfAnglesDeg, n, 1);
    elseif numel(halfAnglesDeg)~=n
        error('halfAnglesDeg must be scalar or length N.');
    end

    % Convert to radians
    halfAnglesRad = deg2rad(halfAnglesDeg(:));

    % Compute unit normals from az/el (deg)
    az = az_el(:,1);
    el = az_el(:,2);
    normals = [ cosd(az).*cosd(el), ...
                sind(az).*cosd(el), ...
                sind(el)           ];  % already unit length

    % Set up figure
    figure; hold on; axis equal; grid on; view(3);
    xlabel('X'); ylabel('Y'); zlabel('Z');
    title('Sun‐Sensor Cones and Normals');

    % Choose a colormap
    cols = lines(n);

    % Plot each cone + its normal
    for i = 1:n
        plotCone(halfAnglesRad(i), normals(i,:), cols(i,:));
    end

    % Optional: example intersection between cone 1 & 2
    if n>=2
        [u1,u2] = findConeIntersections(normals(1,:), halfAnglesRad(1), ...
                                        normals(2,:), halfAnglesRad(2));
        if ~isempty(u1)
            fill3( [0,u1(1),u2(1)], [0,u1(2),u2(2)], [0,u1(3),u2(3)], ...
                   'r','FaceAlpha',0.3,'EdgeColor','none' );
        end
    end

end

function plotCone(halfAngle, normalVec, faceColor)
    % Plot a unit‐length cone with apex at origin, axis=normalVec, half‐angle
    L = 1;                          
    r = tan(halfAngle)*L;          
    Nslice = 40;                   
    theta = linspace(0,2*pi,Nslice);
    z = linspace(0,L,2)';
    [T,Z] = meshgrid(theta,z);
    X = (Z/L)*r .* cos(T);
    Y = (Z/L)*r .* sin(T);

    % build rotation from [0;0;1] to normalVec
    v = normalVec(:)/norm(normalVec);
    a = [0;0;1];
    if norm(cross(a,v))>1e-6
        axis_ = cross(a,v); axis_ = axis_/norm(axis_);
        ang   = acos(dot(a,v));
        K = [    0   -axis_(3)  axis_(2);
             axis_(3)     0    -axis_(1);
            -axis_(2)  axis_(1)     0   ];
        R = eye(3) + sin(ang)*K + (1-cos(ang))*(K*K);
    else
        R = (dot(a,v)<0) * diag([-1 -1 1]) + (dot(a,v)>=0)*eye(3);
    end

    % apply rotation
    pts = R*[X(:)'; Y(:)'; Z(:)'];
    Xr = reshape(pts(1,:),size(X));
    Yr = reshape(pts(2,:),size(Y));
    Zr = reshape(pts(3,:),size(Z));

    surf(Xr,Yr,Zr,'FaceColor',faceColor,'EdgeColor','none','FaceAlpha',0.4);
    quiver3(0,0,0,v(1),v(2),v(3),0.8,'k','LineWidth',1.5);
end

function [u1,u2] = findConeIntersections(nv1, a1, nv2, a2)
    % Solve u·nv1=cos(a1), u·nv2=cos(a2), |u|=1
    c1 = cos(a1); c2 = cos(a2);
    d12 = dot(nv1,nv2);
    phi = acos(min(max(d12,-1),1));
    if abs(phi)<1e-8, u1=[]; u2=[]; return; end

    e1 = nv1;
    tmp = nv2 - d12*nv1;
    if norm(tmp)<1e-8, u1=[]; u2=[]; return; end
    e2 = tmp/norm(tmp);
    e3 = cross(e1,e2);

    alpha = c1;
    beta  = (c2 - c1*cos(phi))/sin(phi);
    gamma2= 1 - alpha^2 - beta^2;
    if gamma2<0, u1=[]; u2=[]; return; end

    gamma = sqrt(gamma2);
    u1 = alpha*e1 + beta*e2 + gamma*e3;
    u2 = alpha*e1 + beta*e2 - gamma*e3;
end
