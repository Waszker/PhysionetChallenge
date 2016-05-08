function calculate_norm_vector(folder, input, saved_features, output)
%
%% Calculates normalization vector for read data.
%% folder - folder in which audio samples are kept
%% input - .csv file with audio samples filenames, located in folder
%% saved_features - name of file containing saved features (use '' if none)
%% output - name of the file to which save the calculated vector
%
path = strcat(folder, input);
file_content = textread(path, '%s', 'whitespace', ',');
filenames = file_content(1:2:end);
filenames = filenames';
data = zeros(length(filenames), get_features_number());

% Parallel computations - calculate features or...
if exist(strcat(folder, saved_features), 'file') ~= 2
    parpool();
    parfor i=1:length(filenames)
        filename = filenames(i);
        features = get_features(strcat(folder, filename));
        disp(strcat('Finished reading ', filename));
    end
    delete(gcp);
else
    % ... load them if already saved
    features = load(strcat(folder, saved_features));
    data = features.data;
end

% Calulate norm vector and save it
max_vector = max(data);
min_vector = min(data);
norm_vector = struct('max_vector', max_vector, 'min_vector', min_vector);
save(strcat(folder, output), 'norm_vector');


end