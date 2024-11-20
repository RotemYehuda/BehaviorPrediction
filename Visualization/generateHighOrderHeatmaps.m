function generateHighOrderHeatmaps(outputDir, transitionMatrices, avgMatrix, allStates, behaviorLabels, numFlies)
    % generateHighOrderHeatmaps: Creates heatmaps for high-order matrices and saves them.
    %
    % Inputs:
    % - outputDir: Directory to save the heatmaps.
    % - transitionMatrices: Struct array with 'matrix' and 'states' for each fly.
    % - avgMatrix: Averaged high-order transition matrix.
    % - allStates: States corresponding to the rows of the matrices.
    % - behaviorLabels: Labels for the behaviors (columns of the matrices).
    % - numFlies: Number of flies.
    
    % Create subdirectories for heatmaps
    standardHeatmapsDir = fullfile(outputDir, 'StandardHeatmaps');
    customHeatmapsDir = fullfile(outputDir, 'CustomHeatmaps');
    
    if ~exist(standardHeatmapsDir, 'dir')
        mkdir(standardHeatmapsDir);
    end
    if ~exist(customHeatmapsDir, 'dir')
        mkdir(customHeatmapsDir);
    end

    % Convert states to human-readable labels
    stateLabels = convertStateSequenceToBehaviors(cellstr(num2str(allStates)), behaviorLabels);

    % Generate heatmap for each fly
    for flyNum = 1:numFlies
        flyMatrix = transitionMatrices{flyNum}.matrix;
        flyStates = transitionMatrices{flyNum}.states;
        flyStateLabels = convertStateSequenceToBehaviors(cellstr(num2str(flyStates)), behaviorLabels);
        createHeatmap(standardHeatmapsDir, flyMatrix, flyStateLabels, behaviorLabels, sprintf('Fly %d', flyNum));
    end

    % Generate heatmap for the average matrix
    createHeatmap(standardHeatmapsDir, avgMatrix, stateLabels, behaviorLabels, 'Average');

    % Generate custom heatmaps for each fly
    targetBehaviors = {'Long Distance Approach', 'Touch'};
    for flyNum = 1:numFlies
        flyMatrix = transitionMatrices{flyNum}.matrix;
        flyStates = transitionMatrices{flyNum}.states;
        flyStateLabels = convertStateSequenceToBehaviors(cellstr(num2str(flyStates)), behaviorLabels);
        createCustomHeatmap(customHeatmapsDir, flyMatrix, flyStateLabels, behaviorLabels, targetBehaviors, sprintf('Fly %d Custom', flyNum));
    end

    % Generate custom heatmap for the average matrix
    createCustomHeatmap(customHeatmapsDir, avgMatrix, stateLabels, behaviorLabels, targetBehaviors, 'Average Custom');
end

function createHeatmap(standardHeatmapsDir, matrix, rowLabels, columnLabels, titleLabel)
    % createHeatmap: Generates a heatmap for the given matrix.
    %
    % Inputs:
    % - standardHeatmapsDir: Directory to save the heatmap.
    % - matrix: Transition probability matrix.
    % - rowLabels: Labels for the rows (state sequences).
    % - columnLabels: Labels for the columns (behaviors).
    % - titleLabel: Title and file identifier for the heatmap.

    % Create figure
    fig = figure('Visible', 'off');
    imagesc(matrix);
    colormap(flipud(bone));
    colorbar;

    % Set tick labels
    yticks(1:numel(rowLabels));
    yticklabels(rowLabels);
    xticks(1:numel(columnLabels));
    xticklabels(columnLabels);
    xtickangle(45);
    set(gca, 'TickLength', [0 0]);
    set(gca, 'FontSize', 6);

    % Title and labels
    xlabel('To');
    ylabel('From');
    title(sprintf('%s Transition Matrix', titleLabel));
    
    % Save the figure
    fileName = fullfile(standardHeatmapsDir, sprintf('Heatmap_%s.png', titleLabel));
    saveas(fig, fileName);
    close(fig);
end


function createCustomHeatmap(customHeatmapsDir, matrix, rowLabels, columnLabels, targetBehaviors, titleLabel)
    % createCustomHeatmap: Generates a heatmap with filtered rows.
    %
    % Inputs:
    % - customHeatmapsDir: Directory to save the custom heatmap.
    % - matrix: Transition probability matrix.
    % - rowLabels: Labels for the rows (state sequences).
    % - columnLabels: Labels for the columns (behaviors).
    % - targetBehaviors: Cell array of target behaviors to filter rows.
    % - titleLabel: Title and file identifier for the heatmap.

    % Identify rows containing target behaviors
    rowsToKeep = contains(rowLabels, targetBehaviors);

    % Filter the matrix and row labels
    filteredMatrix = matrix(rowsToKeep, :);
    filteredRowLabels = rowLabels(rowsToKeep);

    % Create figure
    fig = figure('Visible', 'off');
    imagesc(filteredMatrix);
    colormap(flipud(bone));
    colorbar;

    % Set tick labels
    yticks(1:numel(filteredRowLabels));
    yticklabels(filteredRowLabels);
    xticks(1:numel(columnLabels));
    xticklabels(columnLabels);
    xtickangle(45);
    set(gca, 'TickLength', [0 0]);
    set(gca, 'FontSize', 6);

    % Title and labels
    xlabel('To');
    ylabel('From');
    title(sprintf('%s Transition Matrix', titleLabel));

    % Save the figure
    fileName = fullfile(customHeatmapsDir, sprintf('Heatmap_%s.png', titleLabel));
    saveas(fig, fileName);
    close(fig);
end
