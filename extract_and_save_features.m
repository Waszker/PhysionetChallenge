function extract_and_save_features(folder, input, saved_features, output, norm_vector)
%
%% Extracts features from files in specified path
%%
%% folder - folder in which files are stored (ending with '/'
%% input - .csv file with all audio filenames listed
%% saved_features - file in which features are stored (use '' if none)
%% output - filename in folder to which save extracted features
%% norm_vector - full path to the file containg normalization vector
%
path = strcat(folder, input);
file_content = textread(path, '%s', 'whitespace', ',');
filenames = file_content(1:2:end);
filenames = filenames';
data = zeros(length(filenames), 20);

% Parallel computations
if exist(strcat(folder, saved_features), 'file') ~= 2
    parpool();
    parfor i=1:length(filenames)
        filename = filenames(i);
        features = get_features(strcat(folder, filename));
        data(i,:) = features;
        disp(strcat('Finished reading ', filename));
    end
    delete(gcp);
else
    features = load(strcat(folder, saved_features));
    data = features.data;    
end

% Normalize features (if requested)
if exist(norm_vector, 'file') == 2
    norm = load(norm_vector);
    norm = norm.norm_vector;
    max_vector = norm.max_vector;
    min_vector = norm.min_vector;
    for i = 1 : length(data(:,1))
        data(i, :) = (data(i, :) - min_vector) ./ (max_vector - min_vector);
    end
end

% Save the results
save(strcat(folder, output), 'data');

end