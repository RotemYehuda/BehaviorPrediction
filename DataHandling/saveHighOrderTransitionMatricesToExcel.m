function saveHighOrderTransitionMatricesToExcel(excelFileName, transitionMatrices, averagedMatrix, allStates, behaviorLabels)
    % saveHighOrderTransitionMatricesToExcel: Saves individual and average transition matrices to an Excel file.
    %
    % Inputs:
    % - excelFileName: Full path to the Excel file to save the matrices.
    % - transitionMatrices: Struct array containing 'matrix' and 'states' for each fly.
    % - averagedMatrix: Average transition matrix.
    % - allStates: States corresponding to the averaged matrix rows.
    % - behaviorLabels: Cell array of behavior labels.

    numFlies = length(transitionMatrices);  % Number of flies

    % Loop through flies to save individual transition matrices
    for flyNum = 1:numFlies
        % Extract current fly's transition matrix and state sequences
        flyMatrix = transitionMatrices{flyNum}.matrix;
        flyStates = transitionMatrices{flyNum}.states;

        % Save the individual matrix for the current fly
        sheetName = sprintf('flyNum_%d', flyNum);
        saveSingleTransitionMatrixToExcel(excelFileName, sheetName, flyStates, flyMatrix, behaviorLabels);
    end

    % Save the average transition matrix
    saveSingleTransitionMatrixToExcel(excelFileName, 'AverageMatrix', allStates, averagedMatrix, behaviorLabels);

    disp(['Transition matrices saved to Excel file: ', excelFileName]);
end

function saveSingleTransitionMatrixToExcel(excelFileName, sheetName, states, matrix, behaviorLabels)
    % saveSingleTransitionMatrixToExcel: Saves a single transition matrix to a specified Excel sheet.
    %
    % Inputs:
    % - excelFileName: Full path to the Excel file to save the matrix.
    % - sheetName: Name of the Excel sheet.
    % - states: State sequences (numeric).
    % - matrix: Transition probability matrix.
    % - behaviorLabels: Cell array of behavior labels.

    % Create header for the matrix
    headerRow = [{'Behavior Sequence'}, behaviorLabels(:)'];

    % Convert states to strings and map to behavior sequences
    stateCells = cellstr(num2str(states));
    behaviorSequences = convertStateSequenceToBehaviors(stateCells, behaviorLabels);

    % Combine states, behavior sequences, and matrix data
    matrixWithLabels = [behaviorSequences, num2cell(matrix)];
    dataToWrite = [headerRow; matrixWithLabels];

    % Write to the specified Excel sheet
    writecell(dataToWrite, excelFileName, 'Sheet', sheetName);
end

