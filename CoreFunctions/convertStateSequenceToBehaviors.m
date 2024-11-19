function behaviorSequences = convertStateSequenceToBehaviors(stateCells, behaviorLabels)
    % Convert numeric state sequences into human-readable behavior sequences.
    %
    % Inputs:
    %   stateCells - Cell array of numeric sequences as strings (e.g., {'1 2', '3 4'}).
    %   behaviorLabels - Predefined behavior names corresponding to numeric indices.
    %
    % Output:
    %   behaviorSequences - Cell array of behavior sequences as strings (e.g., {'Walk Jump', 'Sing Stop'}).

    behaviorSequences = cell(size(stateCells));
    
    for i = 1:length(stateCells)
        % Split the numeric sequence (e.g., '1 2') into an array of numbers
        numericSequence = str2num(stateCells{i}); %#ok<ST2NM> 
        
        % Map each number to its corresponding behavior name
        behaviorSequence = strjoin(behaviorLabels(numericSequence), ', ');
        
        % Store the result
        behaviorSequences{i} = behaviorSequence;
    end
end
