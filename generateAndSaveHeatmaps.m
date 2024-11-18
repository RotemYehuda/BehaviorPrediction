function generateAndSaveHeatmaps(outputDir, transitionMatrices, avgMatrix, behaviorLabels, numFlies)
    % generateAndSaveHeatmaps: Generates heatmaps and saves them as PNG files.
    %
    % Inputs:
    % - outputDir: Directory where heatmaps will be saved.
    % - transitionMatrices: Cell array of individual fly transition matrices.
    % - avgMatrix: Average transition matrix.
    % - behaviorLabels: Labels for the behaviors.
    % - numFlies: Number of flies.

    % Define colormap
    cmap = hot;  % Use the hot colormap to match the example

    % Generate and save heatmaps for individual flies
    for flyNum = 1:numFlies
        fig = figure('Visible', 'off');  % Create heatmap without showing it
        imagesc(transitionMatrices{flyNum});  % Display matrix as image
        colormap(cmap);  % Apply colormap
        colorbar;  % Add colorbar
        caxis([0, 1]);  % Normalize color scale to [0, 1]
        xticks(1:numel(behaviorLabels));
        yticks(1:numel(behaviorLabels));
        xticklabels(behaviorLabels);
        yticklabels(behaviorLabels);
        xtickangle(45);  % Rotate x-axis labels
        ylabel('From');
        xlabel('To');
        title(['Fly ', num2str(flyNum), ' Transition Matrix']);
        
        % Save figure as PNG
        saveas(fig, fullfile(outputDir, sprintf('heatmap_flyNum_%d.png', flyNum)));
        close(fig);  % Close figure to free memory
    end

    % Generate and save heatmap for the average matrix
    fig = figure('Visible', 'off');  % Create figure in the background
    imagesc(avgMatrix);  % Display the average matrix as a heatmap
    colormap(cmap);  % Apply colormap
    colorbar;  % Add colorbar
    caxis([0, 1]);  % Normalize the color scale to [0, 1]
    xticks(1:numel(behaviorLabels));  % Set x-ticks to match the labels
    yticks(1:numel(behaviorLabels));  % Set y-ticks to match the labels
    xticklabels(behaviorLabels);  % Apply behavior labels to x-axis
    yticklabels(behaviorLabels);  % Apply behavior labels to y-axis
    xtickangle(45);  % Rotate x-axis labels for better readability
    ylabel('From');  % Y-axis label
    xlabel('To');  % X-axis label
    title('Average Transition Matrix');  % Heatmap title

    % Save figure as PNG
    saveas(fig, fullfile(outputDir, 'heatmap_avgMatrix.png'));  % Save as heatmap_avgMatrix.png
    close(fig);  % Close figure to free memory

    % Generate custom heatmaps for "Touch" and "Long Distance Approach"
    customBehaviors = {'Touch', 'Long Distance Approach'};  % Behaviors to filter

    for flyNum = 1:numFlies
        generateCustomHeatmap(outputDir, transitionMatrices{flyNum}, behaviorLabels, customBehaviors, sprintf('heatmap_custom_flyNum_%d.png', flyNum), flyNum);
    end

    % Generate custom heatmap for the average matrix
    generateCustomHeatmap(outputDir, avgMatrix, behaviorLabels, customBehaviors, 'heatmap_custom_avgMatrix.png', 'Average');
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
    selectedMatrix = matrix(selectedRows, :);  % Filter rows, keep all columns
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

