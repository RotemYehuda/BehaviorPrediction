function processMultipleMoviesFolders(processingFunction)
    % processMultipleMoviesFolders: Prompts user to select folders, processes each folder using the specified function.
    %
    % Inputs:
    % - processingFunction: Function handle for the specific processing task 
    %   (e.g., @processSingleMovieFirstOrder or @processSingleMovieHighOrder).
    %
    %   processMultipleMoviesFolders(@processSingleMovieFirstOrder);
    %   processMultipleMoviesFolders(@processSingleMovieHighOrder);
    %
    % This function allows the user to select multiple movie folders. Each folder is
    % processed independently to extract behavioral data and generate matrices.
    
    addpath(genpath('D:\Galit''s Lab Dropbox\Galit''s Lab team folder\Rotem\Behavior prediction'));

    % Determine if high-order function is used
    isHighOrder = strcmp(func2str(processingFunction), 'processSingleMovieHighOrder');

    % Initialize k
    k = 1;  % Default value for first-order

    if isHighOrder
        k = promptForHighOrderK();  % Call the new function to prompt for k
        if isempty(k)
            return;  % Exit if user cancels
        end
    end

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
        processingFunction(folderPath, k);

        % Print completion message
        disp(repmat('-', 1, 80));  % Line of 80 dashes
        disp(['Finished processing for folder: ', folderPath]);
        disp(repmat('=', 1, 80));  % Line of 80 equal signs
        disp(' ');
    end

    disp('All folders processed successfully!');
end

function k = promptForHighOrderK()
    % promptForHighOrderK: Prompts the user to input the order (k) for high-order transition matrices.
    %
    % Outputs:
    % - k: The high-order value entered by the user (must be an integer >= 1).
    
    % Prompt user for high-order value (k)
    prompt = {'Enter the order (k) for high-order transition matrix:'};
    dlgTitle = 'High-Order Transition Matrix';
    dims = [1 35];
    defInput = {'2'};  % Default value for k
    answer = inputdlg(prompt, dlgTitle, dims, defInput);
    
    if isempty(answer)
        disp('User canceled the process.');
        k = [];  % Return empty if canceled
        return;
    end
    
    k = str2double(answer{1});
    
    % Validate the input
    if isnan(k) || k < 1
        error('Invalid input for high-order value (k). Must be an integer >= 1.');
    end
    
    disp(['High-order processing with k = ', num2str(k)]);
end
