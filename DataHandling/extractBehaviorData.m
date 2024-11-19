function [filesNames, numBehaviors, behaviorLabels, numFlies] = extractBehaviorData(folderPath)
    % extractBehaviorData: Extracts file names, behavior labels, and the number
    % of flies from a specified folder containing scores files.
    %
    % Inputs:
    % - folderPath: Path to the folder containing the scores files.
    %
    % Outputs:
    % - filesNames: A cell array containing the full paths of the behavior score files.
    % - numBehaviors: The number of behaviors (derived from the number of files).
    % - behaviorLabels: A cell array of capitalized behavior labels extracted from the file names.
    % - numFlies: The number of flies determined from one of the score files.

    % Check if the provided folder path exists
    if ~isfolder(folderPath)
        error('The provided folder path does not exist: %s', folderPath);
    end

    % Find all scores files in the folder matching the pattern 'scores_*.mat'
    scoresPattern = fullfile(folderPath, 'scores_*.mat');
    scoresFiles = dir(scoresPattern);
    
    if isempty(scoresFiles)
        error('No scores files found in the folder: %s', folderPath);
    end

    % Store the full file paths
    filesNames = fullfile(folderPath, {scoresFiles.name});

    % Determine the number of behaviors based on the number of score files
    numBehaviors = numel(filesNames);

    % Initialize a cell array to store behavior labels
    behaviorLabels = cell(numBehaviors, 1);

    % Loop through each score file and extract the behavior name
    for behaviorIdx = 1:numBehaviors
        behaviorLabels{behaviorIdx} = extractLabel(scoresFiles(behaviorIdx).name);
    end

    % Capitalize each behavior label for consistency
    behaviorLabels = capitalizeBehaviorLabels(behaviorLabels);

    % Load one of the score files to determine the number of flies
    % Assumes each file contains a matrix 'allScores.postprocessed'
    loadedData = load(filesNames{1});
    if isfield(loadedData, 'allScores') && isfield(loadedData.allScores, 'postprocessed')
        scoresMatrix = loadedData.allScores.postprocessed;
    else
        error('The file %s does not contain the expected variable ''allScores.postprocessed''.', filesNames{1});
    end

    % The number of flies is the number of columns in the score matrix
    numFlies = size(scoresMatrix, 2);

    % Display a success message with folder path
    disp('Successfully extracted file names, behavior labels, and metadata from');
end

function label = extractLabel(fileName)
    % extractLabel: Extracts behavior label from a score file name.
    %
    % Inputs:
    % - fileName: Name of the score file (e.g., 'scores_grooming.mat').
    %
    % Output:
    % - label: Extracted behavior label (e.g., 'Grooming').
    
    label = strrep(fileName, 'scores_', '');  % Remove 'scores_' prefix
    label = strrep(label, '.mat', '');        % Remove '.mat' extension
    label = strrep(label, '_', ' ');          % Replace underscores with spaces
end

function capitalizedLabels = capitalizeBehaviorLabels(behaviorLabels)
    % capitalizeBehaviorLabels: Capitalizes each word in the behavior labels.
    %
    % Inputs:
    % - behaviorLabels: A cell array of behavior labels.
    %
    % Output:
    % - capitalizedLabels: A cell array of behavior labels with each word capitalized.

    capitalizedLabels = cell(size(behaviorLabels));
    for i = 1:length(behaviorLabels)
        % Split the label into individual words
        words = strsplit(behaviorLabels{i}, ' ');

        % Capitalize each word
        capitalizedWords = cellfun(@(word) [upper(word(1)), lower(word(2:end))], words, 'UniformOutput', false);

        % Join the words back together
        capitalizedLabels{i} = strjoin(capitalizedWords, ' ');
    end
end
