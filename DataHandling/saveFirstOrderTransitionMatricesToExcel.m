function saveFirstOrderTransitionMatricesToExcel(excelFileName, transitionMatrices, averageMatrix, behaviorLabels, numFlies)
    % saveFirstOrderTransitionMatricesToExcel: Saves individual and average transition matrices to an Excel file.
    %
    % Inputs:
    % - excelFileName: Full path to the Excel file to save the matrices.
    % - transitionMatrices: Cell array of individual fly transition matrices.
    % - averageMatrix: Average transition matrix.
    % - behaviorLabels: Cell array of behavior labels.
    % - numFlies: Number of flies (number of individual matrices).
    
    % Loop through flies to save individual transition matrices
    for flyNum = 1:numFlies
        % Create header for the current matrix
        headerRow = [{' '}, behaviorLabels(:)'];  % Top-left corner blank
        matrixWithLabels = [behaviorLabels, num2cell(transitionMatrices{flyNum})];
        dataToWrite = [headerRow; matrixWithLabels];

        % Write to the Excel file
        sheetName = sprintf('flyNum_%d', flyNum);
        writecell(dataToWrite, excelFileName, 'Sheet', sheetName);
    end

    % Save the average transition matrix
    headerRow = [{' '}, behaviorLabels(:)'];
    avgMatrixWithLabels = [behaviorLabels, num2cell(averageMatrix)];
    dataToWriteAvg = [headerRow; avgMatrixWithLabels];
    writecell(dataToWriteAvg, excelFileName, 'Sheet', 'avgMatrix');

    disp(['Transition matrices saved to Excel file: ', excelFileName]);
end
