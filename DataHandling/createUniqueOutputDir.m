function outputDir = createUniqueOutputDir(baseDir, subfolderName)
    % createUniqueOutputDir: Creates a subfolder within a base directory, overwriting if it exists.
    %
    % Inputs:
    % - baseDir: The base directory where the subfolder will be created.
    % - subfolderName: The desired name of the subfolder.
    %
    % Output:
    % - outputDir: Path to the created subfolder.
    
    % Define the base output directory
    outputDir = fullfile(baseDir, subfolderName);
    
    % Check if the folder exists
    if exist(outputDir, 'dir')
        % Remove the existing folder and its contents
        disp(['Folder already exists. Removing: ', outputDir]);
        rmdir(outputDir, 's'); % 's' flag for recursive removal
    end

    % Create the new output directory
    mkdir(outputDir);
    disp(['Created output folder: ', outputDir]);
end
