function [ results ] = svmExperiment(DATA_FILE_NAME, NUMBER_FOR_PCA_TRAIN,...
    NUMBER_FOR_SVM_TRAIN, NUMBER_FOR_EIGEN, FEATURE_METHODS, SVM_KERNEL, outputFilePath)
%This function takes different parameters of PCA + SVM as inputs and run
%experiments. Write experiments to files. Returns a summary of parameters and results
    
    % contains trainImages, trainLabels, testImages, testLabels
    % trainImages and testImages are 28 * 28 * 1 * number_of_images(60000/10000) 
    %    gray scale unit8 images
    % trainLabels and testLabels are 1 * number_of_images(60000/10000) 
    load(DATA_FILE_NAME);
    
    % Accuracy records SVM accuracy
    accuracy = zeros(length(NUMBER_FOR_PCA_TRAIN), length(NUMBER_FOR_EIGEN), length(NUMBER_FOR_SVM_TRAIN), length(FEATURE_METHODS), length(SVM_KERNEL));
    % Compare to nearest accuracy, used for debug
    nearestAccuracy = zeros(length(NUMBER_FOR_PCA_TRAIN), length(NUMBER_FOR_EIGEN), length(NUMBER_FOR_SVM_TRAIN), length(FEATURE_METHODS), length(SVM_KERNEL));
    % raw accuracy data from lib SVM
    recordAccuracy = [];
    
    resultSummary = fopen(outputFilePath, 'w');
    
    'Experiments with PCA'
    
    fprintf(resultSummary, 'Feature|\t\tPCA num|\t\t\tSVM num|\t\tEigen Num|\t\tKernel|\t\tSVM Accuracy\n');
    
    for m = 1: length(FEATURE_METHODS)
        if strcmp(FEATURE_METHODS{m}, 'hog') %I use precomputed hog feature to speed up
            load('precomputed_HoG_MNIST.mat');
            trainFeatures = trainHog;
            testFeatures = testHog;
        else
            trainFeatures = imageFeature( trainImages, FEATURE_METHODS{m});
            testFeatures = imageFeature( testImages, FEATURE_METHODS{m});
        end
        
        trainFeaturesCopy = trainFeatures;
        trainLabelsCopy = trainLabels;
        
        for k = 1:length(NUMBER_FOR_SVM_TRAIN)
        svmNum = NUMBER_FOR_SVM_TRAIN(k);
        [trainFeatures, trainLabels] = pickData(trainFeaturesCopy, trainLabelsCopy, svmNum);
        
            for i = 1:length(NUMBER_FOR_PCA_TRAIN)

                pcaNum = NUMBER_FOR_PCA_TRAIN(i);

                % pick how many data we need for training PCA and convert 3d images to 1d vectors
                [pickedFeatures, pickedLabels] = pickData(trainFeatures, trainLabels, pcaNum);
                [mean, eigenVectors] = hw1FindEigendigits( pickedFeatures );
                'compute eigenvectors over'

                for j = 1:length(NUMBER_FOR_EIGEN)

                    numEigen = NUMBER_FOR_EIGEN(j);            

                    %Convert data to the format for libsvm
                    projectedTrain = prejectedToEigen(trainFeatures, mean, eigenVectors, numEigen);
                    projectedTest = prejectedToEigen(testFeatures, mean, eigenVectors, numEigen);
                    [trainData, trainLabels] = dataFormatForSVM(projectedTrain, trainLabels);
                    [testData, testLabels] = dataFormatForSVM(projectedTest, testLabels);

                    trainData = rescaleToZeroOne(trainData);
                    testData = rescaleToZeroOne(testData);
                    
                    for q = 1:length(SVM_KERNEL) 
                        % kernel is specify by a number 
                        % run libsvmtrain in matlab to see details
                        kernelType = SVM_KERNEL(q);
                        'train svm'
                        svmModel = libsvmtrain(trainLabels, trainData, ['-q -t ', num2str(kernelType)]);

                        'test'
                        [predictedLebels, testAccuracy, decisionValues] = libsvmpredict(testLabels, testData, svmModel);
                        %nearestAccuracy(i, j, k, m, q) = testFeaturesByNearest(trainData, trainLabels, testData, testLabels); % This line is test for debug
                        %fprintf(['nearest neighbor accuracy = ', num2str(nearestAccuracy(i, j, k, m, q)), '\n' ]); % for debug
                        
                        accuracy(i, j, k, m, q) = testAccuracy(1) / 100;
                        recordAccuracy = [recordAccuracy; testAccuracy];

                        %Print result in both screen and file.
                        fprintf('Feature|\t\tPCA num|\t\t\tSVM num|\t\tEigen Num|\t\tKernel|\t\tSVM Accuracy\n');
                        fprintf([FEATURE_METHODS{m}, '\t\t', num2str(pcaNum), '\t\t', ...
                            num2str(svmNum), '\t\t', num2str(numEigen), '\t\t', num2str(kernelType), ...
                            '\t\t', num2str(accuracy(i, j, k, m)), '\n']);
                        
                        fprintf(resultSummary, [FEATURE_METHODS{m}, '\t\t', num2str(pcaNum), '\t\t', ...
                            num2str(svmNum), '\t\t', num2str(numEigen), '\t\t', num2str(kernelType), ...
                            '\t\t', num2str(accuracy(i, j, k, m)), '\n']);
                       
                    end
                end
            end
        end
    end
    
    % Record parameters and accuracies in .mat file
    save([outputFilePath, '.mat'], 'NUMBER_FOR_PCA_TRAIN', 'NUMBER_FOR_SVM_TRAIN', 'NUMBER_FOR_EIGEN', ...
        'FEATURE_METHODS', 'SVM_KERNEL', 'accuracy', 'nearestAccuracy', 'recordAccuracy');
    % You can also see human readable results in file
    fclose(resultSummary);
    
    results = {NUMBER_FOR_PCA_TRAIN, NUMBER_FOR_SVM_TRAIN, NUMBER_FOR_EIGEN, ...
        FEATURE_METHODS, SVM_KERNEL, accuracy, nearestAccuracy, recordAccuracy};
end

