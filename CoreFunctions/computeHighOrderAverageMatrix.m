function [averagedMatrix, allStates] = computeHighOrderAverageMatrix(transitionMatrices, behaviorLabels)
    % computeHighOrderAverageMatrix: Summarizes and averages high-order transition matrices across all flies.
    %
    % Inputs:
    %   transitionMatrices - Cell array containing structs with 'matrix' and 'states' for each fly.
    %   behaviorLabels - Predefined list of behaviors ensuring consistent column order.
    %
    % Outputs:
    %   averagedMatrix - Averaged high-order transition matrix including all unique sequences.
    %   allStates - Matrix where each row represents a unique sequence (state).

    % Extract all unique states across all flies
    allStates = [];
    for flyNum = 1:length(transitionMatrices)
        allStates = [allStates; transitionMatrices{flyNum}.states]; %#ok<AGROW>
    end
    allStates = unique(allStates, 'rows', 'stable');

    % Initialize the summarized matrix
    numStates = size(allStates, 1);
    numBehaviors = length(behaviorLabels);
    summarizedMatrix = zeros(numStates, numBehaviors);

    numFlies = length(transitionMatrices);

    % Loop through each fly and align its matrix to the global state space
    for flyNum = 1:numFlies
        flyStates = transitionMatrices{flyNum}.states;
        flyMatrix = transitionMatrices{flyNum}.matrix;

        % Map fly states to global states
        [~, stateIndices] = ismember(flyStates, allStates, 'rows');

        % Add transitions from the fly's matrix to the summarized matrix
        for i = 1:size(flyMatrix, 1)
            summarizedMatrix(stateIndices(i), :) = summarizedMatrix(stateIndices(i), :) + flyMatrix(i, :);
        end
    end

    disp('Summed high-order transition matrix created.');

    % Calculate the averaged matrix
    averagedMatrix = summarizedMatrix / numFlies;

    disp('Averaged high-order transition matrix created.');
end