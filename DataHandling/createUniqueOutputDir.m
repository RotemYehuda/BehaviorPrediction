function outputDir = createUniqueOutputDir(baseDir, subfolderName)
    % createUniqueOutputDir: Creates a unique subfolder within a base directory.
    %
    % Inputs:
    % - baseDir: The base directory where the subfolder will be created.
    % - subfolderName: The desired name of the subfolder.
    %
    % Output:
    % - outputDir: Path to the uniquely created subfolder.
    
    % Define the base output directory
    baseOutputDir = fullfile(baseDir, subfolderName);
    outputDir = baseOutputDir;
    
    % Check if the folder exists, and append a counter if it does
    counter = 1;
    while exist(outputDir, 'dir')
        outputDir = sprintf('%s_%d', baseOutputDir, counter);
        counter = counter + 1;
    end

    % Create the unique output directory
    mkdir(outputDir);
    disp(['Created output folder: ', outputDir]);
end
