function extract_and_save_features(folder, input, output)
%
%% TODO: Add description.
%
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

% Save the results
save(strcat(folder, output), 'data');

end