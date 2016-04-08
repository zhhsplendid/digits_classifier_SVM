function [ projectedData ] = prejectedToEigen( features, mean, ...
    eigenVectors, numEigen)
% This function takes in features and project the image to eigenvectors space


    subMean = features - repmat(mean, 1, size(features, 2));
    % size of submean is image dimension * number of images
    
    useEigenV = eigenVectors(:, 1:numEigen);
    % size of eigenVectors is image dimension * number of used eigen vectors
    
    projectedData = subMean' * useEigenV;
    % size of project are number of images * number of used eigen vectors
end

