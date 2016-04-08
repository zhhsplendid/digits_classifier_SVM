function [ feature] = imageFeature( images, method)
% This function extracts feature of images and then output the feature
    RAW_IMAGE = 'raw';
    HOG = 'hog'; CELL_SIZE = 4; 
    % HOG is a kind of image features which calculates histogram of 
    % gradient in image regions. We use VL_FEAT code in 
    % http://www.vlfeat.org/install-matlab.html for computing the feature
    % see the website and install VL_FEAT before using HoG to run this
    % function.
    
    [x, y, d, k] = size(images); 
    
    if nargin < 2 % User doesn't specify method for extracting features
        method = RAW_IMAGE;
    end
    
    if strcmp(method, RAW_IMAGE) 
        feature = double(reshape(images, x * y * d, k));
    elseif strcmp(method, HOG)
        feature = [];
        for i = 1:k
            %i
            hog = vl_hog(single(images(:,:,:,i)), CELL_SIZE);
            [r, c, dim] = size(hog);
            feature = [feature, reshape(hog, [r * c * dim, 1])];
        end
    end

end

