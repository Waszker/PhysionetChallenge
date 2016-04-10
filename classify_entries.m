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
path = strcat(folder, input);
file_content = textread(path, '%s', 'whitespace', ',');
filenames = file_content(1:2:end);
filenames = filenames';
model_struct = load(classifier_path);
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

% Now classify
[results, ~] = predict(model_struct.model, data);
%% TODO: RF method returns strings in cell array instead of numeric vector...

% Save the results
save(strcat(folder, output), 'results', '-ascii');

end