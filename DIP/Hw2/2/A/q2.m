% Image dimensions
numRows = 435;
numCols = 580;

% Open the binary file for reading
fid = fopen('imgdrv.txt', 'rb');

% Read the data directly into the image matrix
imageMatrix = fread(fid, [numCols numRows], 'uint8=>uint8')';

% Close the file
fclose(fid);

% Display the image
imshow(imageMatrix, []);
title('Binary Image');
