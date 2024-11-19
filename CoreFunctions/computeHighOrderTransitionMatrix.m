function [transitionMatrix, filteredStates] = computeHighOrderTransitionMatrix(M, k)
    % computeHighOrderTransitionMatrix: Compute the higher-order Markov transition matrix.
    %
    % Inputs:
    %   M - Binary behavior matrix (numBehaviors x numFrames)
    %   k - Order of the Markov Chain
    %
    % Outputs:
    %   transitionMatrix - Transition probability matrix for kth-order
    %   filteredStates - Unique k-length sequences with valid transitions

    % Extract the Behavior Sequence
    [numBehaviors, numFrames] = size(M);
    sequence = zeros(1, numFrames); % Represents the sequence of active behaviors per frame.
    for t = 1:numFrames
        activeBehaviors = find(M(:, t));
        if ~isempty(activeBehaviors)
            sequence(t) = activeBehaviors(1); % Use the first active behavior
        end
    end
    
    % Create state space for k-order, excluding sequences containing 0
    validStates = [];
    for t = 1:(numFrames - k)
        state = sequence(t:t+k-1);
        if all(state > 0)  % Only include states that contain no 0
            validStates = [validStates; state]; % Collect valid k-length states
        end
    end
    [uniqueStates, ~, stateIndex] = unique(validStates, 'rows', 'stable');
    
    % Initialize higher-order transition matrix
    numStates = size(uniqueStates, 1);
    transitionCounts = zeros(numStates, numBehaviors);
    
    % Count transitions between states
    for t = 1:(numFrames - k)
        currentState = stateIndex(find(ismember(uniqueStates, sequence(t:t+k-1), 'rows'), 1));
        nextBehavior = sequence(t + k);
        if nextBehavior > 0
            transitionCounts(currentState, nextBehavior) = transitionCounts(currentState, nextBehavior) + 1;
        end
    end
    
    % Filter out rows with no transitions
    nonZeroRows = any(transitionCounts, 2);
    filteredStates = uniqueStates(nonZeroRows, :);
    filteredCounts = transitionCounts(nonZeroRows, :);
    
    % Normalize counts to get probabilities for the filtered matrix
    transitionMatrix = zeros(size(filteredCounts));
    for i = 1:size(filteredCounts, 1)
        rowSum = sum(filteredCounts(i, :));
        if rowSum > 0
            transitionMatrix(i, :) = filteredCounts(i, :) / rowSum;
        end
    end
end