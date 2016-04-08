function [ outData ] = rescaleToZeroOne( data )
% This function rescale data to rang [0, 1]
    outData = (data - repmat(min(data,[],1),size(data,1),1))*spdiags(1./(max(data,[],1)-min(data,[],1))',0,size(data,2),size(data,2));

end

