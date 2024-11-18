function transitionMartix =  computeFirstOrderTransitionMatrix(M)
    % M: Binary behavior matrix (13 x numFrames)
    % transitionMartix: Transition probability matrix (13 x 13)

    % Number of behaviors
    numBehaviors = size(M, 1);

    % Initialize transition count matrix
    transitionCounts = zeros(numBehaviors, numBehaviors);

    % Loop through frames to count transitions for each behavior
    for t = 1:(size(M, 2) - 1)
        % Current frame behaviors
        currentFrame = find(M(:, t));
        % Next frame behaviors
        nextFrame = find(M(:, t + 1));
        
        % Count transitions from each active behavior in current frame
        % to each active behavior in the next frame
        for i = 1:length(currentFrame)
            for j = 1:length(nextFrame)
                transitionCounts(currentFrame(i), nextFrame(j)) = ...
                    transitionCounts(currentFrame(i), nextFrame(j)) + 1;
            end
        end
    end

    % Normalize rows to get transition probabilities
    transitionMartix = zeros(numBehaviors, numBehaviors);
    for i = 1:numBehaviors
        rowSum = sum(transitionCounts(i, :));
        if rowSum > 0
            transitionMartix(i, :) = transitionCounts(i, :) / rowSum;
        end
    end

end