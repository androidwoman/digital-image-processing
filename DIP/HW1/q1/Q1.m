[filename, filepath] = uigetfile({'*.mat', 'MAT Files (*.mat)'}, 'Select ct_image File');
fullpath = fullfile(filepath, filename);

ct_data = load(fullpath);

ct_image = ct_data.q;


[filename, filepath] = uigetfile({'*.mat', 'MAT Files (*.mat)'}, 'Select mri_image File');
fullpath = fullfile(filepath, filename);
mri_data = load(fullpath);
mri_image = mri_data.q;

ct_min_intensity = min(ct_image(:));
ct_max_intensity = max(ct_image(:));

mri_min_intensity = min(mri_image(:));
mri_max_intensity = max(mri_image(:));

figure;
imshow(ct_image, [ct_min_intensity, ct_max_intensity]);
title('CT Scan Image');

figure;
imshow(mri_image, [mri_min_intensity, mri_max_intensity]);
title('MRI Image');

