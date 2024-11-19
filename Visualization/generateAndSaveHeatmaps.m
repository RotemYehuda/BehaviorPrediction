function generateAndSaveHeatmaps(outputDir, transitionMatrices, avgMatrix, behaviorLabels, numFlies)
    % generateAndSaveHeatmaps: Generates heatmaps and saves them as PNG files.
    %
    % Inputs:
    % - outputDir: Directory where heatmaps will be saved.
    % - transitionMatrices: Cell array of individual fly transition matrices.
    % - avgMatrix: Average transition matrix.
    % - behaviorLabels: Labels for the behaviors.
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

    % Define colormap
    cmap = hot;  % Use the hot colormap to match the example

    % Generate and save standard heatmaps for individual flies
    for flyNum = 1:numFlies
        fig = figure('Visible', 'off');
        imagesc(transitionMatrices{flyNum});
        colormap(cmap);
        colorbar;
        caxis([0, 1]);
        xticks(1:numel(behaviorLabels));
        yticks(1:numel(behaviorLabels));
        xticklabels(behaviorLabels);
        yticklabels(behaviorLabels);
        xtickangle(45);
        ylabel('From');
        xlabel('To');
        title(['Fly ', num2str(flyNum), ' Transition Matrix']);
        
        % Save figure as PNG
        saveas(fig, fullfile(standardHeatmapsDir, sprintf('heatmap_flyNum_%d.png', flyNum)));
        close(fig);
    end

    % Generate and save standard heatmap for the average matrix
    fig = figure('Visible', 'off');
    imagesc(avgMatrix);
    colormap(cmap);
    colorbar;
    caxis([0, 1]);
    xticks(1:numel(behaviorLabels));
    yticks(1:numel(behaviorLabels));
    xticklabels(behaviorLabels);
    yticklabels(behaviorLabels);
    xtickangle(45);
    ylabel('From');
    xlabel('To');
    title('Average Transition Matrix');

    % Save figure as PNG in the standard heatmaps folder
    saveas(fig, fullfile(standardHeatmapsDir, 'heatmap_avgMatrix.png'));
    close(fig);

    % Generate custom heatmaps for "Touch" and "Long Distance Approach"
    customBehaviors = {'Touch', 'Long Distance Approach'};  % Behaviors to filter

    for flyNum = 1:numFlies
        generateCustomHeatmap(customHeatmapsDir, transitionMatrices{flyNum}, behaviorLabels, customBehaviors, sprintf('heatmap_custom_flyNum_%d.png', flyNum), flyNum);
    end

    % Generate custom heatmap for the average matrix
    generateCustomHeatmap(customHeatmapsDir, avgMatrix, behaviorLabels, customBehaviors, 'heatmap_custom_avgMatrix.png', 'Average');
end

function generateCustomHeatmap(outputDir, matrix, behaviorLabels, customBehaviors, fileName, titleLabel)
    % Generate heatmap for specific rows of a matrix
    %
    % Inputs:
    % - matrix: Transition matrix (individual or average).
    % - behaviorLabels: All behavior labels.
    % - customBehaviors: Cell array of behaviors to include in rows.
    % - fileName: Name of the output PNG file.
    % - titleLabel: Title to display on the heatmap.

    % Find indices of custom behaviors
    selectedRows = ismember(behaviorLabels, customBehaviors);
    
    if ~any(selectedRows)
        % Print a warning if no custom behaviors are found
        disp(['Warning: None of the custom behaviors "', strjoin(customBehaviors, ', '), ...
              '" exist in the behavior labels for ', titleLabel, '.']);
        return;
    end

    % Extract the relevant matrix rows and labels
    selectedMatrix = matrix(selectedRows, :);
    selectedBehaviorLabels = behaviorLabels(selectedRows);

    % Create and save custom heatmap
    fig = figure('Visible', 'off');
    imagesc(selectedMatrix);
    colormap(hot);
    colorbar;
    caxis([0, 1]);
    xticks(1:numel(behaviorLabels));
    yticks(1:numel(selectedBehaviorLabels));
    xticklabels(behaviorLabels);
    yticklabels(selectedBehaviorLabels);
    xtickangle(45);
    ylabel('From');
    xlabel('To');
    title(['Custom Heatmap: ', titleLabel]);

    % Adjust figure size to improve square cell appearance
    set(gca, 'DataAspectRatio', [1 1 1]);  % Ensures square aspect ratio for data
    set(gca, 'TickLength', [0 0]);  % Remove tick length for cleaner look

    % Save figure as PNG
    saveas(fig, fullfile(outputDir, fileName));
    close(fig);
end

