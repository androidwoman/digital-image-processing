% Create a 512x512 array filled with zeros
array = zeros(512, 512);

% Plot the array with equal coordinate axes
figure;
imagesc(array);
colormap(gray);
axis equal;
axis off;
title('(A) 512x512 Array of Zeros');

