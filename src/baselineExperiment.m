function [ baseline, testNearest ] = baselineExperiment( DATA_FILE_NAME, NUMBER_FOR_SVM_TRAIN, outputFilePath )
% We use SVM on raw data, without PCA, linear kernel: u'*v 
% without PCA to run experiment as baseline
%
% Returns accuracy for different numbers of training set.

    baseline = zeros(length(NUMBER_FOR_SVM_TRAIN));
    testNearest = zeros(length(NUMBER_FOR_SVM_TRAIN));
    'Baseline experiment: raw image data with SVM without PCA'
    
    
    resultSummary = fopen(outputFilePath, 'w');
    
    fprintf(resultSummary, 'SVM Num|\t\tSVM Accuracy\n');
    % contains trainImages, trainLabels, testImages, testLabels
    % trainImages and testImages are 28 * 28 * 1 * number_of_images(60000/10000) 
    %    gray scale unit8 images
    % trainLabels and testLabels are 1 * number_of_images(60000/10000) 
    load(DATA_FILE_NAME);
    
    trainFeatures = imageFeature( trainImages, 'raw');
    testFeatures = imageFeature( testImages, 'raw');
    
    trainFeaturesCopy = trainFeatures;
    trainLabelsCopy = trainLabels;
    for k = 1:length(NUMBER_FOR_SVM_TRAIN)
        svmNum = NUMBER_FOR_SVM_TRAIN(k);
        [pickedFeatures, pickedLabels] = pickData(trainFeaturesCopy, trainLabelsCopy, svmNum);
        [trainData, trainLabels] = dataFormatForSVM(pickedFeatures, pickedLabels);
        [testData, testLabels] = dataFormatForSVM(testFeatures, testLabels);
        
        'train'
        trainData = rescaleToZeroOne(trainData);
        testData = rescaleToZeroOne(testData);
        svmModel = libsvmtrain(trainLabels, trainData, '-q -t 3');
        'test'
        
        
        [predictedLebels, testAccuracy, decisionValues] = libsvmpredict(testLabels, testData, svmModel);
        %testNearest(k) = testFeaturesByNearest(trainData, trainLabels, testData, testLabels); % for debug
        %fprintf(['nearest neighbor accuracy = ', num2str(testNearest(k)), '\n' ]); % for debug
        
        baseline(k, 1) = testAccuracy(1) / 100;
        
        fprintf('SVM Num|\tSVM Accuracy\n');
        fprintf([num2str(svmNum), '\t\t', num2str(baseline(k)), '\n']');
        
        fprintf(resultSummary, [num2str(svmNum), '\t\t', num2str(baseline(k)), '\n']);
    end
    
    % Record parameters and accuracies in .mat file
    save([outputFilePath, '.mat'], 'NUMBER_FOR_SVM_TRAIN', 'baseline', 'testNearest');
    % You can also see human readable results in file
    fclose(resultSummary);
end

