% Read the Bayer pattern image from the file
bayerImage = imread('Mand.tiff');

% Define the Bayer mask (2x2 for your pattern)
bayerMask = [2 1; 3 2];

% Get the dimensions of the Bayer image
[rows, cols] = size(bayerImage);

% Initialize arrays to hold color channels
redChannel = zeros(rows, cols);
greenChannel = zeros(rows, cols);
blueChannel = zeros(rows, cols);

% Perform demosaicing using nearest neighbor interpolation
for row = 2:rows-1
    for col = 2:cols-1
        % Determine the position in the Bayer mask
        maskRow = mod(row, 2) + 1;
        maskCol = mod(col, 2) + 1;

        % Calculate the interpolated color values
        if bayerMask(maskRow, maskCol) == 1
            blueChannel(row, col) = bayerImage(row, col);
            greenChannel(row, col) = bayerImage(row-1, col);
            redChannel(row, col) = bayerImage(row-1, col-1);
        elseif bayerMask(maskRow, maskCol) == 2
            greenChannel(row, col) = bayerImage(row, col);
            if(maskRow== 2)
            blueChannel(row, col) = bayerImage(row-1, col);
            redChannel(row, col) = bayerImage(row, col-1);
          else
            blueChannel(row, col) = bayerImage(row, col-1);
            redChannel(row, col) = bayerImage(row-1, col);
            end
        elseif bayerMask(maskRow, maskCol) == 3
            redChannel(row, col) = bayerImage(row, col);
            greenChannel(row, col) = bayerImage(row-1, col);
            blueChannel(row, col) = bayerImage(row-1, col-1);
        end
    end
end

% Combine color channels into a single color image
colorImage = cat(3, redChannel, greenChannel, blueChannel);

% Convert to uint8 format (0-255)
colorImage = uint8(colorImage);

% Display the resulting color image
imshow(colorImage);
title('Color Image (Nearest Neighbor Interpolation)');

