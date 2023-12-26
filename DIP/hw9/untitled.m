% To use with an existing image
img = imread('cameraman.tif');
displayImageProcessingResults(img);

% To generate a random image
displayImageProcessingResults(randi([0, 255], [256, 256], 'uint8'));

% Load images from files
img_t1w = load('T1W.mat');
displayImageProcessingResults(img_t1w.A);

img_xray = load('Xray.mat');
displayImageProcessingResults(img_xray.A);

% Function to display image processing results
function displayImageProcessingResults(input_image)
    % Step 1: Calculate histogram of the input image
    histogram_input = calculateHistogram(input_image);

    % Step 2: Calculate cumulative distribution function (CDF) of the input image
    cdf_input = cumsum(histogram_input) / numel(input_image);

    % Step 3: Perform histogram equalization
    equalized_image = applyHistogramEqualization(input_image, cdf_input);

    % Step 4: Calculate histogram of the equalized image
    histogram_equalized = calculateHistogram(equalized_image);

    % Step 5: Use built-in histeq function for comparison
    histeq_result = histeq(input_image);

    % Display the original, equalized, and histeq images
    figure;
    subplot(3, 3, 1), imshow(input_image), title('1. Original Image');
    subplot(3, 3, 2), imshow(equalized_image, []), title('2. My Equalized Image');
    subplot(3, 3, 3), imshow(histeq_result, []), title('3. Histeq Image');

    % Display histograms using bar function
    subplot(3, 3, 4), bar(histogram_input), title('4. Histogram of Input Image (bar)');
    subplot(3, 3, 8), bar(histogram_equalized), title('7. Histogram of My Equalized Image (bar)');

    % Display histograms using imhist function
    subplot(3, 3, 5), imhist(input_image), title('5. Histogram of Input Image (imhist)');
    subplot(3, 3, 6), imhist(uint8(equalized_image)), title('6. Histogram of My Equalized Image (imhist)');
    subplot(3, 3, 7), imhist(uint8(histeq_result)), title('8. Histogram of Histeq Image (imhist)');
end

% Helper function to calculate histogram
function histogram = calculateHistogram(image)
    histogram = zeros(256, 1);
    [M, N] = size(image);

    % Iterate through the image pixels
    for i = 1:M
        for j = 1:N
            intensity = image(i, j) + 1; % MATLAB indexing starts from 1
            histogram(intensity) = histogram(intensity) + 1;
        end
    end
end

% Helper function to apply histogram equalization
function equalized_image = applyHistogramEqualization(image, cdf)
    [M, N] = size(image);
    equalized_image = zeros(M, N);

    % Iterate through the image pixels
    for i = 1:M
        for j = 1:N
            intensity = image(i, j) + 1; % MATLAB indexing starts from 1
            equalized_image(i, j) = uint8(255 * cdf(intensity));
        end
    end
end
