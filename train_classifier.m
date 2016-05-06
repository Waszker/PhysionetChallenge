function train_classifier(folder, input, output, classifier)
%
% Function that trains certain classifier on given data set.
%
% INPUTS:
% folder: path to provided data ending with '/'
% input: filename of .csv file containing data in two rows. First row
% contains names of .wav files, the second one -1 or 1 value depending on the
% PCG status
% output: file to write svm trained model to. The path for this model will
% be the same as input one
% classifier: one of available classifiers to train (accepted keywords are
% 'svm', 'rf', 'knn')
%
valid_classifiers = {'svm', 'rf', 'knn'};
validatestring(classifier, valid_classifiers);

% If everything is good, proceed to calculations
path = strcat(folder, input);
file_content = textread(path, '%s', 'whitespace', ',');
filenames = file_content(1:2:end); % read filenames
results = csvread(path, 0, 1); % read correct answers for data

data = zeros(length(filenames), 20);
filenames = filenames';

% Parallel computations
if exist(strcat(folder, 'saved_features_normalized.mat'), 'file') ~= 2
    parpool();
    parfor i=1:length(filenames)
        filename = filenames(i);
        features = get_features(strcat(folder, filename));
        data(i,:) = features;
        disp(strcat('Finished reading ', filename));
    end
    delete(gcp);
else
    features = load(strcat(folder, 'saved_features_normalized.mat'));
    data = features.data;    
end

% Create classifiers
if strcmp(classifier, valid_classifiers(1))
    model = fitcsvm(data, results, 'KernelFunction', 'rbf');
elseif strcmp(classifier, valid_classifiers(2))
    model = TreeBagger(100, data, results);
elseif strcmp(classifier, valid_classifiers(3))
    model = fitcknn(data, results);
end

save_file = strcat(folder, output);
save(save_file, 'model');
disp('*** FINISHED ***');
end