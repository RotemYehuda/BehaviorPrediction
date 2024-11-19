function processSingleMovieHighOrder(folderPath, k)
    % processSingleMovieHighOrder: Computes high-order transition matrices for a given movie folder.
    %
    % Inputs:
    % - folderPath: Path to the folder containing scores files.
    % - k: Order of the transition matrix (k >= 2).
    %
    % Outputs:
    % - Saves transition matrices and heatmaps in a subdirectory within the folderPath.
    
    % Validate input
    if k < 1
        error('Order k must be >= 1 for high-order transition matrices.');
    end

    % Extract scores and metadata
    [filesNames, numBehaviors, behaviorLabels, numFlies] = extractBehaviorData(folderPath);

    % Initialize a cell array to store combined scores matrices for each fly 
    %combinedScoresMatrices = cell(1, numFlies);

    % Initialize cell arrays to store high-order transition matrices
    transitionMatrices = cell(1, numFlies);

    % Compute high-order transition matrix for each fly
    for flyNum = 1:numFlies
        % Load scores for the current fly
        [combinedScoresMatrix, ~] = createCombinedScoresMatrix(filesNames, numBehaviors, flyNum);

        % Store the combined scores matrix in the cell array
        % combinedScoresMatrices{flyNum} = combinedScoresMatrix;

        % Compute high-order transition matrix
        [transitionMatrix, filteredStates] = computeHighOrderTransitionMatrix(combinedScoresMatrix, k);
        transitionMatrices{flyNum} = struct('matrix', transitionMatrix, 'states', filteredStates);
    end

    % Compute the average high-order transition matrix
    [averagedMatrix, allStates] = computeHighOrderAverageMatrix(transitionMatrices, behaviorLabels);

    disp('High-order transition matrices computed for all flies.');

    outputDir = createUniqueOutputDir(folderPath, ['HighOrderTransitionMatrices_k', num2str(k)]);

    % Save transition matrices to an Excel file in the created directory
    excelFileName = fullfile(outputDir, 'transitionMatrices.xlsx');    
    saveHighOrderTransitionMatricesToExcel(excelFileName, transitionMatrices, averagedMatrix, allStates, behaviorLabels);


end