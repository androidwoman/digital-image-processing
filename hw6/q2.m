% Load the .mat files containing the images
T1W = load('T1W.mat');
Xray = load('Xray.mat');

% Convert images to double
T1W = normalize_image(T1W.A);
Xray = normalize_image(Xray.A);

% Display the original images
figure;
subplot(2, 2, 1);
imshow(T1W);
title('Original T1W Image');

subplot(2, 2, 2);
imshow(Xray);
title('Original Xray Image');

% Add Gaussian noise to images
target_psnr = 15;
noise_level = (255^2) / (10^(target_psnr/10));

T1W_noisy = imnoise(T1W, 'gaussian', 0, noise_level / 255^2);
Xray_noisy = imnoise(Xray, 'gaussian', 0, noise_level / 255^2);

% Display the noisy images
subplot(2, 2, 3);
imshow(T1W_noisy);
title('Noisy T1W Image');

subplot(2, 2, 4);
imshow(Xray_noisy);
title('Noisy Xray Image');

% Apply FFT to the noisy images
fft_T1W_noisy = fft2(T1W_noisy);
fft_Xray_noisy = fft2(Xray_noisy);

% Calculate the percentage of frequencies to be removed (you can adjust this value)
percentage_to_remove = 0.1;

% Determine the threshold value for frequency removal
threshold_value = prctile(abs(fft_T1W_noisy(:)), 100 - percentage_to_remove * 100);

% Set frequencies below the threshold to zero
fft_T1W_noisy_highpass = fft_T1W_noisy .* (abs(fft_T1W_noisy) > threshold_value);
fft_Xray_noisy_highpass = fft_Xray_noisy .* (abs(fft_Xray_noisy) > threshold_value);

% Apply inverse FFT to obtain the denoised images
denoised_T1W = ifft2(fft_T1W_noisy_highpass);
denoised_Xray = ifft2(fft_Xray_noisy_highpass);

% Display the denoised images
figure;
subplot(1, 2, 1);
imshow(abs(denoised_T1W));
title('Denoised T1W Image');

subplot(1, 2, 2);
imshow(abs(denoised_Xray));
title('Denoised Xray Image');

% Calculate and display PSNR
psnr_T1W = psnr(abs(denoised_T1W), T1W);
psnr_Xray = psnr(abs(denoised_Xray), Xray);

disp(['PSNR for Denoised T1W Image: ', num2str(psnr_T1W)]);
disp(['PSNR for Denoised Xray Image: ', num2str(psnr_Xray)]);

% Plot the PSNR vs. percentage of frequencies removed
percentage_removed_values = linspace(0, 100, 100);
psnr_values = zeros(size(percentage_removed_values));

for i = 1:length(percentage_removed_values)
    current_percentage = percentage_removed_values(i);
    
    % Determine the threshold value for frequency removal
    current_threshold = prctile(abs(fft_T1W_noisy(:)), 100 - current_percentage);
    
    % Set frequencies below the threshold to zero
    fft_T1W_noisy_highpass = fft_T1W_noisy .* (abs(fft_T1W_noisy) > current_threshold);
    
    % Apply inverse FFT to obtain the denoised image
    denoised_T1W = ifft2(fft_T1W_noisy_highpass);
    
    % Calculate and store PSNR
    psnr_values(i) = custom_psnr(abs(denoised_T1W), T1W);
end

% Plot the results
figure;
plot(percentage_removed_values, psnr_values, '-o');
title('PSNR vs. Percentage of Frequencies Removed');
xlabel('Percentage of Frequencies Removed');
ylabel('PSNR (dB)');
grid on;


% Custom PSNR calculation function
function psnr_value = custom_psnr(image, original)
    mse = sum((original(:) - image(:)).^2) / numel(original);
    maxval = 1; 
    psnr_value = 10 * log10(maxval^2 / mse);
end


% Function to manually normalize the image to [0, 1] range
function normalized_image = normalize_image(image)
    normalized_image = double(image) / double(intmax(class(image)));
end
