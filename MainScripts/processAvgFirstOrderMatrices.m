function processAvgFirstOrderMatrices(movieFolders)
    % processAvgFirstOrderMatrices: Calculates the overall average of avgMatrix across multiple movie directories,
    % generates heatmaps for the full and custom matrices, and saves a list of valid directories.
    %
    % Inputs:
    % - movieFolders: Cell array (1 x num_movies) containing paths to movie directories.

    % Initialize a variable to store the sum of avgMatrices
    overallSumMatrix = [];
    numValidMatrices = 0;

    % Initialize a list to track valid processed directories
    validProcessedFolders = {};

    % Loop through each folder to process avgMatrix
    for i = 1:length(movieFolders)
        folderPath = movieFolders{i};
        transitionDir = fullfile(folderPath, 'FirstOrderTransitionMatrices');
        excelFile = fullfile(transitionDir, 'transitionMatrices.xlsx');

        % Check if the transitionMatrices file exists
        if ~exist(excelFile, 'file')
            disp(['Warning: transitionMatrices.xlsx not found in ', transitionDir]);
            continue;
        end

        % Try to read the avgMatrix sheet from the Excel file
        try
            avgMatrix = readmatrix(excelFile, 'Sheet', 'avgMatrix', 'Range', 'B2');
        catch ME
            disp(['Error reading avgMatrix from ', excelFile, ': ', ME.message]);
            continue;
        end

        % Initialize overallSumMatrix if not already done
        if isempty(overallSumMatrix)
            overallSumMatrix = zeros(size(avgMatrix));
        end

        % Accumulate the avgMatrix
        overallSumMatrix = overallSumMatrix + avgMatrix;
        numValidMatrices = numValidMatrices + 1;

        % Add folderPath to the valid processed list
        validProcessedFolders{end + 1} = folderPath; %#ok<AGROW>
    end

    % Check if any valid matrices were found
    if numValidMatrices == 0
        error('No valid avgMatrices found in the selected directories.');
    end

    % Calculate the overall average matrix
    overallAvgMatrix = overallSumMatrix / numValidMatrices;

    % Prompt the user to select a base directory for saving files
    savePath = uigetdir(pwd, 'Select Directory to Save Results');
    if savePath == 0
        disp('File saving canceled. Exiting function.');
        return;
    end

    % Create a unique directory in the selected location
    outputDirName = 'OverallAvgFirstOrderResults';
    outputDir = createUniqueOutputDir(savePath, outputDirName);

    % Write the average matrix to an Excel file
    excelFileName = fullfile(outputDir, 'OverallAverageMatrix.xlsx');
    behaviorLabels = readcell(fullfile(transitionDir, 'transitionMatrices.xlsx'), ...
                               'Sheet', 'avgMatrix', 'Range', 'A2:A14');
    headerRow = [{' '}, behaviorLabels']; % Top-left corner blank
    matrixWithLabels = [behaviorLabels, num2cell(overallAvgMatrix)];
    dataToWrite = [headerRow; matrixWithLabels];
    writecell(dataToWrite, excelFileName);
    disp(['Overall average matrix saved to ', excelFileName]);

    % Save the list of valid processed folders
    folderListFileName = fullfile(outputDir, 'ValidProcessedFolders.txt');
    writecell(validProcessedFolders', folderListFileName, 'Delimiter', ' ');
    disp(['List of valid processed folders saved to ', folderListFileName]);

    % Generate and save heatmaps
    heatmapDir = fullfile(outputDir, 'Heatmaps');
    mkdir(heatmapDir);
    generateHeatmap(overallAvgMatrix, behaviorLabels, fullfile(heatmapDir, 'OverallAverageMatrix_Heatmap.png'));

    % Generate custom heatmap for "Touch" and "Long Distance Approach"
    customBehaviors = {'Touch', 'Long Distance Approach'};
    generateCustomHeatmap(overallAvgMatrix, behaviorLabels, customBehaviors, ...
                          fullfile(heatmapDir, 'CustomHeatmap_OverallAverage.png'));

    disp(['All results saved in ', outputDir]);
end

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

function generateHeatmap(matrix, labels, fileName)
    % generateHeatmap: Creates and saves a heatmap for the given matrix.
    %
    % Inputs:
    % - matrix: The matrix to visualize as a heatmap.
    % - labels: Behavior labels for the rows and columns of the matrix.
    % - fileName: Full path to save the heatmap image.

    % Create figure
    fig = figure('Visible', 'off');
    imagesc(matrix);
    colormap(flipud(bone)); % Inverted bone colormap
    colorbar;
    caxis([0, 1]);

    % Set axis labels
    xticks(1:numel(labels));
    yticks(1:numel(labels));
    xticklabels(labels);
    yticklabels(labels);
    xtickangle(45);
    set(gca, 'FontSize', 10, 'TickLength', [0 0]);

    % Title and labels
    xlabel('To');
    ylabel('From');
    title('Overall Average Transition Matrix');

    % Save the heatmap
    saveas(fig, fileName);
    close(fig);
end

function generateCustomHeatmap(matrix, behaviorLabels, customBehaviors, fileName)
    % generateCustomHeatmap: Creates and saves a heatmap for selected rows (behaviors).
    %
    % Inputs:
    % - matrix: The full transition matrix.
    % - behaviorLabels: Labels for all rows/columns of the matrix.
    % - customBehaviors: Cell array of behaviors to include in the custom heatmap.
    % - fileName: Full path to save the heatmap.

    % Find indices of the custom behaviors
    selectedRows = ismember(behaviorLabels, customBehaviors);

    if ~any(selectedRows)
        disp(['Warning: None of the specified behaviors "', strjoin(customBehaviors, ', '), ...
              '" exist in the behavior labels.']);
        return;
    end

    % Extract the relevant rows from the matrix
    selectedMatrix = matrix(selectedRows, :);
    selectedBehaviorLabels = behaviorLabels(selectedRows);

    % Create figure
    fig = figure('Visible', 'off');
    imagesc(selectedMatrix);
    colormap(flipud(bone)); % Inverted bone colormap
    colorbar;
    caxis([0, 1]);

    % Set axis labels
    xticks(1:numel(behaviorLabels));
    yticks(1:numel(selectedBehaviorLabels));
    xticklabels(behaviorLabels);
    yticklabels(selectedBehaviorLabels);
    xtickangle(45);
    set(gca, 'FontSize', 10, 'TickLength', [0 0]);
    set(gca, 'DataAspectRatio', [1 1 1]);

    % Title and labels
    xlabel('To');
    ylabel('From');
    title('Custom Heatmap (Touch & Long Distance Approach)');

    % Save the heatmap
    saveas(fig, fileName);
    close(fig);
end
