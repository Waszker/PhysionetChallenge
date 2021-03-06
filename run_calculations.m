function run_calculations(should_extract_features, features_filename, output)
%
%% Runs all required calculations: features extraction, normalization, training classifiers
%% and classifying data.
%%
%% should_extract_features - 0 if previously saved features should be used, 1 otherwise
%% features_filename - name of the file where extracted features are stored
%% output - filename for the file containing results
%
folder = 'validation/';
input = 'REFERENCE.csv';
filename_base = strsplit(features_filename, '.');
filename_base = filename_base{1};

% Extract and normalize data if needed
if should_extract_features == 1
    disp('Extracting features (without normalization)');
    extract_and_save_features(folder, input, features_filename, features_filename, '');
    disp('Finished extracting features');
    
    disp('Beginning features normalization');
    new_features_filename = strcat(filename_base, '_normalized.mat');
    calculate_norm_vector(folder, input, features_filename, strcat('norm_vector_', filename_base));
    extract_and_save_features(folder, input, features_filename, new_features_filename, strcat('validation/norm_vector_', filename_base, '.mat'));
    disp('Ended normalization');
end
features_filename = strcat(filename_base, '_normalized.mat');

% Now train classifier
classifiers = {'svm', 'rf', 'knn'};
disp('Beginning training classifiers');
for i = 1:3
    train_classifier(folder, input, features_filename, strcat(filename_base, classifiers{i}, '.mat'), classifiers{i});
end
disp('Ended training classifiers');

% Now classify
disp('Running classification');
for i = 1:3
    result_file = strcat(classifiers{i}, '_', output);
    classifier_path = strcat(folder, strcat(filename_base, classifiers{i}, '.mat'));
    classify_entries(folder, input, classifier_path, features_filename, result_file);
end

% Extract features from test sets if needed
folder = 'Training/training-';
letters = ['a', 'b', 'c', 'd', 'e'];

if should_extract_features == 1 
    for i = 1:5
        path = strcat(folder, letters(i), '/');
        disp('Extracting features (with normalization) from test sets');
        extract_and_save_features(path, input, '', features_filename, strcat('validation/norm_vector_', filename_base, '.mat'));
        disp('Finished extracting features');
    end
end

% Now run classification on test sets
for i = 1:5
    path = strcat(folder, letters(i), '/');
    disp('Descending into folder');
    disp(path);
    for j = 1 : 3
        result_file = strcat(classifiers{j}, '_', output);
        classifier_path = strcat('validation/', strcat(filename_base, classifiers{j}, '.mat'));
        classify_entries(path, input, classifier_path, features_filename, result_file);
    end
end

end