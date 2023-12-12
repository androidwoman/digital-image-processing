% Example for testing with a random matrix
input_matrix_random = rand(10, 10);

% Interpolate using the custom function with different methods
matlab_nearest_random = matlab_interp(input_matrix_random, 'nearest', 0.5);
matlab_linear_random = matlab_interp(input_matrix_random, 'linear', 0.5);
matlab_cubic_random = matlab_interp(input_matrix_random, 'cubic', 0.5);

custom_nearest_random = my_interpolation(input_matrix_random, 'nearest', 0.5);
custom_linear_random = my_interpolation(input_matrix_random, 'linear', 0.5);
custom_cubic_random = customCubicInterpolationWithScale(input_matrix_random, 2);

% Plot the results for the random matrix
figure;
subplot(2, 4, 1);
imshow(input_matrix_random, 'InitialMagnification', 'fit');
title('Original Random Matrix');

subplot(2, 4, 2);
imshow(custom_nearest_random, 'InitialMagnification', 'fit');
title('Custom Nearest Interpolation (Random)');

subplot(2, 4, 3);
imshow(matlab_nearest_random, 'InitialMagnification', 'fit');
title('MATLAB Nearest Interpolation (Random)');

subplot(2, 4, 5);
imshow(custom_linear_random, 'InitialMagnification', 'fit');
title('Custom Linear Interpolation (Random)');

subplot(2, 4, 6);
imshow(matlab_linear_random, 'InitialMagnification', 'fit');
title('MATLAB Linear Interpolation (Random)');

subplot(2, 4, 7);
imshow(custom_cubic_random, [], 'InitialMagnification', 'fit');
title('Custom Cubic Interpolation (Random)');

subplot(2, 4, 8);
imshow(matlab_cubic_random, 'InitialMagnification', 'fit');
title('MATLAB Cubic Interpolation (Random)');

% Display the plot for the random matrix
sgtitle('Comparison of Interpolation Methods (Random)');

% Read the cameraman image
input_matrix_cameraman = double(imread('cameraman.tif'));

% Interpolate using the custom function with different methods
matlab_nearest_cameraman = matlab_interp(input_matrix_cameraman, 'nearest', 0.5);
matlab_linear_cameraman = matlab_interp(input_matrix_cameraman, 'linear', 0.5);
matlab_cubic_cameraman = matlab_interp(input_matrix_cameraman, 'cubic', 0.5);

custom_nearest_cameraman = my_interpolation(input_matrix_cameraman, 'nearest', 0.5);
custom_linear_cameraman = my_interpolation(input_matrix_cameraman, 'linear', 0.5);
custom_cubic_cameraman = customCubicInterpolationWithScale(input_matrix_cameraman, 2);

% Plot the results for the cameraman image
figure;
subplot(2, 4, 1);
imshow(input_matrix_cameraman, [], 'InitialMagnification', 'fit');
title('Original Image (Cameraman)');

subplot(2, 4, 2);
imshow(custom_nearest_cameraman, [], 'InitialMagnification', 'fit');
title('Custom Nearest Interpolation (Cameraman)');

subplot(2, 4, 3);
imshow(matlab_nearest_cameraman, [], 'InitialMagnification', 'fit');
title('MATLAB Nearest Interpolation (Cameraman)');

subplot(2, 4, 5);
imshow(custom_linear_cameraman, [], 'InitialMagnification', 'fit');
title('Custom Linear Interpolation (Cameraman)');

subplot(2, 4, 6);
imshow(matlab_linear_cameraman, [], 'InitialMagnification', 'fit');
title('MATLAB Linear Interpolation (Cameraman)');

subplot(2, 4, 7);
imshow(custom_cubic_cameraman, [], 'InitialMagnification', 'fit');
title('Custom Cubic Interpolation (Cameraman)');

subplot(2, 4, 8);
imshow(matlab_cubic_cameraman, [], 'InitialMagnification', 'fit');
title('MATLAB Cubic Interpolation (Cameraman)');

% Display the plot for the cameraman image
sgtitle('Comparison of Interpolation Methods (Cameraman)');



function interpolated_img = customCubicInterpolationWithScale(input_matrix, scaleFactor)
    % Define the step function u
    u = @(x) double(x >= 0);

    % Define the cubic interpolation function with a=0.5
    a = 0.5;
    Rc = @(x) ((a + 2) * abs(x).^3 - (a + 3) * x.^2 + 1) .* (u(x + 1) - u(x - 1)) + ...
        (a * abs(x).^3 - 5 * a * x.^2 + 8 * a * abs(x) - 4 * a) .* (u(x - 1) - u(x - 2) + u(x + 2) - u(x + 1));

    [rows, cols] = size(input_matrix);
    
    % Define the new grid (desired output size)
    new_rows = scaleFactor * rows;
    new_cols = scaleFactor * cols;

    % Create new grid
    new_x = linspace(1, cols, new_cols);
    new_y = linspace(1, rows, new_rows);

    % Initialize the new image
    interpolated_img = zeros(new_rows, new_cols);

    % Perform cubic interpolation
    for i = 1:new_rows
        for j = 1:new_cols
            % Find the indices of the nearest neighbors
            x_idx = floor(new_x(j));
            y_idx = floor(new_y(i));

            % Clip indices to stay within the matrix bounds
            x_idx = max(1, min(cols - 1, x_idx));
            y_idx = max(1, min(rows - 1, y_idx));

            % Get the four nearest neighbors
            neighbors = input_matrix(y_idx:y_idx + 1, x_idx:x_idx + 1);

            % Perform cubic interpolation using Rc
            x_offset = (new_x(j) - x_idx) / scaleFactor;
            y_offset = (new_y(i) - y_idx) / scaleFactor;
            interpolated_value = Rc(x_offset) * Rc(y_offset) * neighbors(1, 1) + ...
                                 Rc(x_offset) * (1 - Rc(y_offset)) * neighbors(2, 1) + ...
                                 (1 - Rc(x_offset)) * Rc(y_offset) * neighbors(1, 2) + ...
                                 (1 - Rc(x_offset)) * (1 - Rc(y_offset)) * neighbors(2, 2);

            % Update the new image
            interpolated_img(i, j) = interpolated_value;
        end
    end
end


function interpolated_matrix = my_interpolation(input_matrix, interpolation_type,scale_factor)
    % Get the size of the input matrix
    [m, n] = size(input_matrix);

    % Define the grid for the original matrix
    [XI, YI] = meshgrid(1:scale_factor:n, 1:scale_factor:m); % Increase the resolution for smoother interpolation

    % Initialize the interpolated matrix
    interpolated_matrix = zeros(size(XI));

    % Perform interpolation based on the selected type
    for i = 1:numel(XI)
        % Calculate the corresponding indices in the original matrix
        sourceRow = YI(i);
        sourceCol = XI(i);

        % Perform interpolation based on the selected type
        switch interpolation_type
            case 'nearest'
                % Nearest-neighbor interpolation
                interpolated_matrix(i) = input_matrix(round(sourceRow), round(sourceCol));
            case 'linear'
                % Bilinear interpolation
                row_floor = floor(sourceRow);
                col_floor = floor(sourceCol);
                row_ceil = min(row_floor + 1, m);
                col_ceil = min(col_floor + 1, n);

                % Interpolate in the row direction
                value_row_floor = input_matrix(row_floor, col_floor) + (input_matrix(row_floor, col_ceil) - input_matrix(row_floor, col_floor)) * (sourceCol - col_floor);
                value_row_ceil = input_matrix(row_ceil, col_floor) + (input_matrix(row_ceil, col_ceil) - input_matrix(row_ceil, col_floor)) * (sourceCol - col_floor);

                % Interpolate in the column direction
                interpolated_matrix(i) = value_row_floor + (value_row_ceil - value_row_floor) * (sourceRow - row_floor);
     end
    end
end



function interpolated_matrix = matlab_interp(input_matrix, interpolation_type,scale_factor)
    [m, n] = size(input_matrix);
    
    % Define the grid for the interpolated matrix
    [X, Y] = meshgrid(1:n, 1:m);
    
    % Define the grid for the original matrix
    [XI, YI] = meshgrid(1:scale_factor:n, 1:scale_factor:m); % Increase the resolution for smoother interpolation
    
    % Perform interpolation based on the selected type
    switch interpolation_type
        case 'nearest'
            interpolated_matrix = interp2(X, Y, input_matrix, XI, YI, 'nearest');
        case 'linear'
            interpolated_matrix = interp2(X, Y, input_matrix, XI, YI, 'linear');
        case 'cubic'
            interpolated_matrix = interp2(X, Y, input_matrix, XI, YI, 'cubic');
        otherwise
            error('Invalid interpolation type. Use ''nearest'', ''linear'', or ''cubic''.');
    end
end
