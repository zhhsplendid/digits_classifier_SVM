function [ outImages, outLabels ] = pickData(images, labels, num)
% This function picks the original data from course website. We don't use
% all of them for training. By change the method in head of this function
% you can choose pick data randomly or just first num data.
% Input:
%   original data of images and labels from course website
%   how many data you want to output
% Output:
%   images and labels.

    FIRST = 1;
    RANDOM = 2;
    
    method = FIRST;
    
    totalNum = size(images, 4);
    if method == FIRST
        outImages = images(:,1:num);
        outLabels = labels(1:num);
    elseif method == RANDOM
        perm = randperm(totalNum);
        pick = perm(1:num);
        outImages = images(:,pick);
        outLabels = labels(pick);
    end
end

