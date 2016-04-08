function main(  )
% Using PCA and SVM to train and test in MNIST, a digit dataset
% We tried different sizes of train images for PCA and different numbers of eigenvalues 
% to see how PCA can influence SVM classification in MNIST
    
    %Data from assignment 1.
    DATA_DIR = '../MNIST/';
    DATA_FILE_NAME = [DATA_DIR, 'digits.mat'];
    
    % for experiments, we use 250, 300, 350, ...  images to train PCA
    NUMBER_FOR_PCA_TRAIN = 250:50:600; %250:50:600 for assignment 1
    
    % use different train images to train SVM
    NUMBER_FOR_SVM_TRAIN = [1000, 10000, 60000]; %[1000, 10000, 60000]
    
    % for experiments, we use 10, 20, ...  eigen values to test for SVM.
    NUMBER_FOR_EIGEN = 10:10:80; % 10:10:80 for assignment 1
    % different image features. 1 means raw image, 2 means HoG feature, a
    % image feature calculating the histogram of gradients in local regions
    FEATURE_METHODS = {'hog', 'raw'};
    
    % kernel types are spcified by numbers, run libsvmtrain -h for details
    SVM_KERNEL = 0:1:3;
   
    % for experiments, we will fix some parameters and change some to see impact
    FIXED_PCA = 600;
    FIXED_SVM = 60000;
    FIXED_EIGEN = 50;
    FIXED_FEATURE = {'hog'};
    FIXED_KERNEL = 0; %linear kernel function u' * v

    if ~exist('precomputed_HoG_MNIST.mat', 'file')
        fprintf('pre-compute image features');
        precomputeImageFeatures();
    end
    
    baselineExperiment(DATA_FILE_NAME, NUMBER_FOR_SVM_TRAIN, '../output/baseline.result');
    
    svmExperiment(DATA_FILE_NAME,  NUMBER_FOR_PCA_TRAIN, FIXED_SVM, ...
        FIXED_EIGEN, FIXED_FEATURE, FIXED_KERNEL, '../output/differentPCAtrainingSizes.result');
    
    svmExperiment(DATA_FILE_NAME, FIXED_PCA, NUMBER_FOR_SVM_TRAIN, ...
        FIXED_EIGEN, FEATURE_METHODS, FIXED_KERNEL, '../output/differentSVMtrainingSizes.result');
    
    svmExperiment(DATA_FILE_NAME, FIXED_PCA, FIXED_SVM, ...
        NUMBER_FOR_EIGEN, FIXED_FEATURE, FIXED_KERNEL, '../output/differentEigenUsed.result');
    
    svmExperiment(DATA_FILE_NAME, FIXED_PCA, NUMBER_FOR_SVM_TRAIN, ...
        FIXED_EIGEN, FIXED_FEATURE, SVM_KERNEL, '../output/differentKernels.result');
        
end

