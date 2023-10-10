
array = zeros(512, 512);

% تعریف مختصات مراکز دایره‌ها
centers = [200, 200; 200, 232; 300, 200; 300, 248; 400, 200; 400, 264];

% تعریف شعاع دایره
radius = 16;

% ترسیم دایره‌ها بر روی تصویر
for i = 1:size(centers, 1)
    centerX = centers(i, 1);
    centerY = centers(i, 2);


    [X, Y] = meshgrid(1:512, 1:512);


    distance = sqrt((X - centerX).^2 + (Y - centerY).^2);


    array(distance <= radius) = 1;
end

% ترسیم آرایه با محورهای مختصات یکسان
figure;
imagesc(array);
colormap(gray);
axis equal;
axis off;
title("Create Circles")

