function precomputeImageFeatures( input_args )
    DATA_DIR = '../MNIST/';
    DATA_FILE_NAME = [DATA_DIR, 'digits.mat'];
       
    load(DATA_FILE_NAME);
    
    testHog = imageFeature(testImages, 'hog');
    trainHog = imageFeature(trainImages, 'hog');
    save('precomputed_HoG_MNIST.mat', 'trainHog', 'testHog');
end

