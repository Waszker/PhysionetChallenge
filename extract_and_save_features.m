function extract_and_save_features(folder, input, output, norm_vector)
%
%% TODO: Add description.
%
path = strcat(folder, input);
file_content = textread(path, '%s', 'whitespace', ',');
filenames = file_content(1:2:end);
filenames = filenames';
data = zeros(length(filenames), 20);

% Parallel computations
if exist(strcat(folder, 'saved_features.mat'), 'file') ~= 2
    parpool();
    parfor i=1:length(filenames)
        filename = filenames(i);
        features = get_features(strcat(folder, filename));
        data(i,:) = features;
        disp(strcat('Finished reading ', filename));
    end
    delete(gcp);
else
    features = load(strcat(folder, 'saved_features.mat'));
    data = features.data;    
end

% Normalize features (if requested)
if exist(strcat(folder, norm_vector), 'file') == 2
    norm = load(strcat(folder, norm_vector));
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