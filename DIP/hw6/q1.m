% Load the .mat files containing the images
T1W = load('T1W.mat');
Xray = load('Xray.mat');

T1W = normalize_image(T1W.A);
Xray = normalize_image(Xray.A);

% Define the target PSNR range
target_psnr_range = 15:30;

% Initialize cell arrays for noisy images
T1W_noisy = cell(1, length(target_psnr_range));
Xray_noisy = cell(1, length(target_psnr_range));

% Custom function for average filtering
average_filter = @(image, window_size) custom_average_filter(image, window_size);

% Add Gaussian noise to images and display MSE and PSNR
for i = 1:length(target_psnr_range)
    % Calculate MSE to achieve the target PSNR
    target_psnr = target_psnr_range(i);
    mse = (255^2) / (10^(target_psnr/10));
    
    % Add Gaussian noise to images
    T1W_noisy{i} = imnoise(T1W, 'gaussian', 0, mse / 255^2);
    Xray_noisy{i} = imnoise(Xray, 'gaussian', 0, mse / 255^2);
    
    % Display calculated MSE
    disp(['MSE for PSNR ', num2str(target_psnr), ' dB: ', num2str(mse)]);
    
    % Display calculated PSNR for the noisy image
    psnr_value_Xray = custom_psnr(Xray_noisy{i}, Xray);
    disp(['PSNR for Xray_noisy with PSNR ', num2str(target_psnr), ' dB: ', num2str(psnr_value_Xray)]);
end

% Define window sizes for filtering
window_sizes = [3, 5, 7];

% Initialize arrays for PSNR values
psnr_values_T1W = zeros(length(window_sizes), length(target_psnr_range));
psnr_values_Xray = zeros(length(window_sizes), length(target_psnr_range));

% Apply custom average filtering and calculate PSNR
for i = 1:length(window_sizes)
    window_size = window_sizes(i);
    
    for j = 1:length(target_psnr_range)
        % Apply average filtering
        T1W_filtered = average_filter(T1W_noisy{j}, window_size);
        Xray_filtered = average_filter(Xray_noisy{j}, window_size);
        
        % Calculate PSNR values
        psnr_values_T1W(i, j) = custom_psnr(T1W_filtered, T1W);
        psnr_values_Xray(i, j) = custom_psnr(Xray_filtered, Xray);
    end
end

% Plot PSNR vs. Input PSNR
figure;
for i = 1:length(window_sizes)
    plot(target_psnr_range, psnr_values_T1W(i, :), '-o', 'DisplayName', ['T1W, Window Size = ', num2str(window_sizes(i))]);
    hold on;
    plot(target_psnr_range, psnr_values_Xray(i, :), '-o', 'DisplayName', ['Xray, Window Size = ', num2str(window_sizes(i))]);
end
title('PSNR vs. Input PSNR');
xlabel('Input PSNR (dB)');
ylabel('Output PSNR (dB)');
legend('Location', 'Best');
grid on;
hold off;

% Custom PSNR calculation function
function psnr_value = custom_psnr(image, original)
    mse = sum((original(:) - image(:)).^2) / numel(original);
    maxval = 1; 
    psnr_value = 10 * log10(maxval^2 / mse);
end

% Custom average filter function using conv2
function filtered_image = custom_average_filter(image, window_size)
    kernel = ones(window_size) / window_size^2;
    filtered_image = conv2(image, kernel, 'same');
end

% Function to manually normalize the image to [0, 1] range
function normalized_image = normalize_image(image)
    normalized_image = double(image) / double(intmax(class(image)));
end
