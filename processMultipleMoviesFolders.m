function processMultipleMoviesFolders(processingFunction)
    % processMultipleMoviesFolders: Prompts user to select folders, processes each folder using the specified function.
    %
    % Inputs:
    % - processingFunction: Function handle for the specific processing task 
    %   (e.g., @processSingleMovieFirstOrder or @processSingleMovieHighOrder).
    %
    % This function allows the user to select multiple movie folders. Each folder is
    % processed independently to extract behavioral data and generate matrices.

    % Prompt the user to select multiple folders
    movieFolders = uipickfiles('Prompt', 'Select Movie Folders to Process', ...
                               'FilterSpec', pwd, 'REFilter', '.*');

    if isequal(movieFolders, 0)
        disp('No folders selected. Exiting...');
        return;
    end
    
    % Loop over each folder and process its files using the specified function
    for folderIdx = 1:length(movieFolders)
        folderPath = movieFolders{folderIdx};

        disp(repmat('=', 1, 80));  % Line of 80 equal signs
        disp(['Starting processing for folder: ', folderPath]);
        disp(repmat('-', 1, 80));  % Line of 80 dashes

        % Call the specified processing function
        processingFunction(folderPath);

        % Print completion message
        disp(repmat('-', 1, 80));  % Line of 80 dashes
        disp(['Finished processing for folder: ', folderPath]);
        disp(repmat('=', 1, 80));  % Line of 80 equal signs
        disp(' ');
    end

    disp('All folders processed successfully!');
end
