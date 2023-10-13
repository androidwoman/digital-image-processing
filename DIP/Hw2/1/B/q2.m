% Read the Bayer pattern image from the file
bayerImage = double(imread('Mand.tiff'));




% Determine the size of the Bayer pattern image
[height, width] = size(bayerImage);

% Create matrices for the red, green, and blue channels
redChannel = zeros(height, width);
greenChannel = zeros(height, width);
blueChannel = zeros(height, width);

% Apply bilinear interpolation to the green channel
for i = 2:height-1
    for j = 2:width-1
        if mod(i, 2) == 1 % Odd rows
            if mod(j, 2) == 1 % Odd columns
                greenChannel(i, j) = bayerImage(i, j);
                redChannel(i, j) = (bayerImage(i, j - 1) + bayerImage(i, j + 1)) / 2;
                blueChannel(i, j) = (bayerImage(i - 1, j) + bayerImage(i + 1, j)) / 2;
            else % Even columns
                greenChannel(i, j) = (bayerImage(i, j - 1) + bayerImage(i, j + 1) + bayerImage(i - 1, j) + bayerImage(i + 1, j)) / 4;
                redChannel(i, j) = bayerImage(i, j);
                blueChannel(i, j) = (bayerImage(i - 1, j - 1) + bayerImage(i - 1, j + 1) + bayerImage(i + 1, j - 1) + bayerImage(i + 1, j + 1)) / 4;
            end
        else % Even rows
            if mod(j, 2) == 0 % Even columns
                greenChannel(i, j) = bayerImage(i, j);
                blueChannel(i, j) = (bayerImage(i, j - 1) + bayerImage(i, j + 1)) / 2;
                redChannel(i, j) = (bayerImage(i - 1, j) + bayerImage(i + 1, j)) / 2;
            else % Odd columns
                greenChannel(i, j) = (bayerImage(i, j - 1) + bayerImage(i, j + 1) + bayerImage(i - 1, j) + bayerImage(i + 1, j)) / 4;
                redChannel(i, j) = (bayerImage(i - 1, j - 1) + bayerImage(i - 1, j + 1) + bayerImage(i + 1, j - 1) + bayerImage(i + 1, j + 1)) / 4;
               blueChannel(i, j) = bayerImage(i, j);
            end
        end
    end
end

% Combine the channels to create the full-color image
colorImage = cat(3, redChannel, greenChannel, blueChannel);
% Convert to uint8 format (0-255)
t = uint8(colorImage);
% Display the resulting color image
imshow(t);



