function [ accuracy ] = testFeaturesByNearest(trainData, trainLabels, testData, testLabels)
% This function test features by nearest
    
    
    [numTest, projDim] = size(testData);
    [numTrain, projDim] = size(trainData);
    correctPred = 0;
    for i = 1: numTest
        test = testData(i,:); % i-th image
        
        % compute Euclidean distance to all train images.
        distances = sum((repmat(test, numTrain, 1) - trainData) .^ 2, 2);
        % size of distances is number of trainImages * 1;
        [minValue, minPos] = min(distances);
        
        prediction = trainLabels(minPos);
        groundTruth = testLabels(i);
        
        if prediction == groundTruth
            correctPred = correctPred + 1;
        end
    end
    accuracy = correctPred / numTest;
    
    
end

