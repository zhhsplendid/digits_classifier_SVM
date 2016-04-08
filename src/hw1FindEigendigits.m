function [m, V] = hw1FindEigendigits( A )
% Input: 
%   an (x by k) matrix A (where x is the total number of 
%   pixels in an image and k is the number of training images) 
% return:
%   a vector m of length x containing the mean column vector of A 
%   an (x by k) matrix V that contains k eigenvectors of the covariance matrix of A 
%   (after the mean has been subtracted). These are sorted in descending order 
%   by eigenvalue and normalized 
% Note that we assume k < x
    [x, k] = size(A);
    m = sum(A, 2) / k;
    afterSubMean = A - repmat(m, 1, k);
    %C = A'*A; %size k * k
    C = afterSubMean' * afterSubMean;
    
    [eigenVectors, eigenValues] = eig(C); 
    
    [sortValues, sortPos] = sort(abs(diag(eigenValues)), 'descend');
    sortedVectors = eigenVectors(:,sortPos);
    
    V = A * sortedVectors;

end

