function [ outData, outLabels] = dataFormatForSVM(inData, inLabels)
% This function converts data to format for LibSVM
    
    % Libsvm's training & test labels are number of images * 1 double matrices
    [x, y] = size(inLabels);
    outLabels = double(reshape(inLabels, x * y, 1));
    
    % Libsvm's training & test data are number of images * m double matrices
    dataSize = size(inData);
    if length(dataSize) == 4 % (height, width, dim, num)
        outData = double(reshape(inData, [], x*y))';
    else % already (num * m) or (m * num)
        if size(inData, 1) == x*y
            outData = double(inData);
        else
            outData = double(inData)';
        end
    end
    
end

