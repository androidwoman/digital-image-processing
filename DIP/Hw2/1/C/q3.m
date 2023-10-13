bayerImage = imread('Mand.tiff');

% Demosaic the image using the AHD algorithm
colorImage = demosaic(bayerImage, "grbg");

% Display the color image
imshow(colorImage);
title('Color Image');

