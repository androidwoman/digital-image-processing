% Define the total number of elements
filename = 's.txt';

% Read the sequence from the text file
sequence = dlmread(filename);
total_elements = numel(sequence);


figure;

valid_combinations_count = 0;



% Loop through possible factors
for factor1 = 1:total_elements
    % Check if factor1 is a factor of total_elements
    if mod(total_elements, factor1) == 0
        factor2 = total_elements / factor1;

        % Create the matrix based on the current factors
        current_matrix1 = reshape(sequence, factor1, factor2);



            valid_combinations_count = valid_combinations_count + 1;
            subplot(3, 3, valid_combinations_count); % Display in a 3x3 grid
            imagesc(current_matrix1);
            colormap(gray);
            axis equal;
            axis off;
             title(['Matrix ' num2str(factor1) '*' num2str(factor2)]);

    end
end

