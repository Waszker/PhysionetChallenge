function classify_entries(folder, input, classifier_path, output)
%
% Function that runs classification on provided set of data.
%
% INPUTS:
% folder: path to provided data ending with '/'
% input: filename of .csv file containing data about files to classify
% classifier_path: path to file containing saved classifier, that needs to
% be loaded
% output: file to write answers to
%
model_struct = load(classifier_path);

if exist(strcat(folder, 'saved_features.mat'), 'file') == 0
    data = get_entries_features(folder, input);
else
    features = load(strcat(folder, 'saved_features.mat'));
    data = features.data;
end

% Now classify
[results, ~] = predict(model_struct.model, data);
if isa(model_struct.model, 'TreeBagger')
    % RF returns results in a cell array instead of numeric vector
    % Conversion needed
    results = cellfun(@(x)str2double(x), results);
end

% Save the results
save(strcat(folder, output), 'results', '-ascii');

end

function data = get_entries_features(folder, input)

path = strcat(folder, input);
file_content = textread(path, '%s', 'whitespace', ',');
filenames = file_content(1:2:end);
filenames = filenames';
data = zeros(length(filenames), 20);

% Parallel computations
parpool();
parfor i=1:length(filenames)
    filename = filenames(i);
    features = get_features(strcat(folder, filename));
    data(i,:) = features;
    disp(strcat('Finished reading ', filename));
end
delete(gcp);

end