function calculate_norm_vector(folder, input, output)
%
%% TODO: Add description
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
        disp(strcat('Finished reading ', filename));
    end
    delete(gcp);
else
    features = load(strcat(folder, 'saved_features.mat'));
    data = features.data;
end

% Calulate norm vector and save it
max_vector = max(data);
min_vector = min(data);
norm_vector = struct('max_vector', max_vector, 'min_vector', min_vector);
save(strcat(folder, output), 'norm_vector');


end