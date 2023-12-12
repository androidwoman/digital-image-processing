

compare_rotate_methods_random_and_image()




function compare_rotate_methods_random_and_image()
    % Create a small random matrix
    random_matrix = rand(5, 5);

    % Set the rotation angle and interpolation methods
    theta = -30;
    interpolation_methods = {'nearest', 'bilinear', 'bicubic'};

    % Loop over interpolation methods for the random matrix
    for i = 1:length(interpolation_methods)
        interpolation_method = interpolation_methods{i};

        % Call the function to compare rotation methods for the random matrix
        compare_rotate_methods(random_matrix, theta, interpolation_method, 'Random Matrix');
    end

    % Load the cameraman image
    cameraman_image = double(imread('cameraman.tif'))/255;

    % Loop over interpolation methods for the cameraman image
    for i = 1:length(interpolation_methods)
        interpolation_method = interpolation_methods{i};

        % Call the function to compare rotation methods for the cameraman image
        compare_rotate_methods(cameraman_image, theta, interpolation_method, 'Cameraman Image');
    end
end

function compare_rotate_methods(I1, theta, interpolation_method, title_text)
    % Get the size of the input matrix
    [P1, Q1] = size(I1);

    % Transformation matrix for rotation
    T = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
    Tinv = T^(-1);

    % Calculate size of the rotated image
    size2 = abs(T) * [P1 Q1]';
    P2 = round(size2(1));
    Q2 = round(size2(2));

    % Initialize rotated image
    I2 = zeros(P2, Q2);

    % Define functions for coordinate transformations
    index2coordinate = @(P, Q, pq) [pq(2)-(Q+1)/2 (P+1)/2-pq(1)];
    coordinate2index = @(P, Q, uv) [(P+1)/2-uv(2) uv(1)+(Q+1)/2];

    % Loop through each pixel in the rotated image
    for p2 = 1:P2
        for q2 = 1:Q2
            % Convert index in the rotated image to coordinates
            uv2 = index2coordinate(P2, Q2, [p2 q2]);
            
            % Apply inverse transformation to get corresponding coordinates in the original image
            uv1 = Tinv * uv2';
            
            % Convert coordinates to index in the original image
            pq1 = coordinate2index(P1, Q1, uv1);
            
            % Check if the index is within the valid range of the original image
            if all(pq1 <= [P1 Q1]) && all(pq1 >= [1 1])
                % Use interp2 for interpolation
                I2(p2, q2) = interp2(I1, pq1(2), pq1(1), interpolation_method);
            end
        end
    end

    % Use imrotate for comparison
    I2_imrotate = imrotate(I1, theta, interpolation_method);

    % Display the original and rotated images
    figure
    subplot(2, 2, 1)
    imshow(I1)
    title(['Original Image - ' title_text])

    subplot(2, 2, 2)
    imshow(I2)
    title(['Rotated Image (2interp - ' interpolation_method ')'])

    subplot(2, 2, 3)
    imshow(I2_imrotate)
    title(['Rotated Image (imrotate - ' interpolation_method ')'])

    sgtitle(['Rotation Comparison - ' title_text ' - Interpolation Method: ' interpolation_method])
end
