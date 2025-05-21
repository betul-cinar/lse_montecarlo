close all;
clc;
clear;

% Load sensor model data
coeff = load("coeff_sensor.mat");
coeff_inv = load("coeff_inverse.mat");

n= 42;

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

az_el = [sensor_az_body' sensor_el_body'];

% Simulation settings
N_sims = 100;               % Number of simulations per sun direction
sun_az_all = 0:359;         % Azimuth angles (degrees)
sun_el_all = 1:90;          % Elevation angles (degrees)

% Preallocate MSE matrix
ERROR_MAP = zeros(360, 90);

for az_idx = 1:length(sun_az_all)
    for el_idx = 1:length(sun_el_all)

        sun_az = sun_az_all(az_idx);
        sun_el = sun_el_all(el_idx);

        lse_az = zeros(1, N_sims);
        lse_el = zeros(1, N_sims);

        for d = 1:N_sims
            sens_val = zeros(1, n);
            halfangle_deg = zeros(1, n);

            for i = 1:n
                sens_val(i) = compute_photodiode(sensor_el_body(i), sensor_az_body(i), sun_el, sun_az, coeff);
                halfangle_deg(i) = photodiode_model_inverse(sens_val(i), coeff_inv);
            end

            halfangle = halfangle_deg * pi / 180;

            % Select valid sensors
            a = 0;
            sel_numbers = [];
            sel_azel = [];
            for i = 1:n
                if halfangle_deg(i) < 55 && halfangle_deg(i) > 0
                    a = a + 1;
                    sel_numbers(a) = i;
                    sel_azel(a,:) = az_el(i,:);
                end
            end

            % if a < 3
            %     % Too few sensors to triangulate
            %     lse_az(d) = NaN;
            %     lse_el(d) = NaN;
            %     continue
            % end

            nv_sel = zeros(a, 3);
            halfangle_sel = zeros(1, a);
            for i = 1:a
                nv_sel(i,:) = sph2cart_unit(sel_azel(i,:));
                halfangle_sel(i) = halfangle(sel_numbers(i));
            end

            % Initial guess for optimization
            u0 = sum(nv_sel, 1);
            u0 = u0 / norm(u0);

            residualFunc = @(u) coneResiduals(a, u, nv_sel, halfangle_sel);
            options = optimoptions('lsqnonlin', 'Display', 'off');
            try
                u_solution = lsqnonlin(residualFunc, u0, [], [], options);
                lse_el(d) = rad2deg(atan2(u_solution(3), norm(u_solution(1:2))));
                lse_az(d) = rad2deg(atan2(u_solution(2), u_solution(1)));
            catch
                lse_el(d) = NaN;
                lse_az(d) = NaN;
            end
        end

        % Compute ground truth unit vector
        [x_gt, y_gt, z_gt] = sph2cart(deg2rad(sun_az), deg2rad(sun_el), 1);
        v_gt = [x_gt, y_gt, z_gt];

        % Compute estimated vectors
        est_valid = ~isnan(lse_az) & ~isnan(lse_el);
        if sum(est_valid) == 0
            ERROR_MAP(az_idx, el_idx) = NaN;
        else
            x_est = cosd(lse_el(est_valid)) .* cosd(lse_az(est_valid));
            y_est = cosd(lse_el(est_valid)) .* sind(lse_az(est_valid));
            z_est = sind(lse_el(est_valid));
            v_est = [x_est(:), y_est(:), z_est(:)];

            % Calculate squared angular error
            angle_errors = acosd(dot(v_est, repmat(v_gt, size(v_est,1), 1), 2));
            % MSE_map(az_idx, el_idx) = mean(angle_errors.^2);
            ERROR_MAP(az_idx, el_idx) = mean(abs(angle_errors));

        end
    end

    % Progress display
    fprintf('%.1f%% finished...\n', 100*az_idx/length(sun_az_all));
end

% Save result if needed
% save('MSE_map.mat', 'MSE_map');
%%
% Assumes MSE_map is a 360x90 matrix (azimuth x elevation)
% load("ERRROR_MAP_n20_MAE.mat")
% figure('Name','Mean Squared Error Heatmap', 'Color','w');
figure('Name','Mean Absolute Error Heatmap', 'Color','w');

imagesc(0:359, 1:90, ERROR_MAP');  % Transpose to align elevation as Y-axis
axis xy;  % Flip y-axis so 1 is bottom, 90 is top
colormap(jet);  % Use jet colormap
colorbar;
xlabel('Sun Azimuth (°)');
ylabel('Sun Elevation (°)');
title('Mean Absolute Error of Estimated Sun Direction (deg)');
caxis([0, max(ERROR_MAP(:), [], 'omitnan')]);  % Adjust color scale

% Optional: mark high error zones
% [row, col] = find(MSE_map > threshold); hold on; plot(row-1, col, 'k.')

