function residuals = coneResiduals(n, u, nv, alpha)
    % Check if u is a valid input vector
    if norm(u) < 1e-12
        error('Input vector u has near-zero magnitude.');
    end

    % Residual for unit vector constraint
    r(n+1) = norm(u)^2 - 1;

    residuals = zeros(1,n);
    for i=1:n
        r(i) = dot(u, nv(i,:)) - cos(alpha(i));
        residuals(i) = r(i);
    end

    residuals(n+1) = r(n+1);
       
end
