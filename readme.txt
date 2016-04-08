
Requirement for runing my code

	In this work, we used Matlab. Our SVM tool is from 
	LIBSVM (http://www.csie.ntu.edu.tw/~cjlin/libsvm) and we used library 
	VLFeat (http://www.vlfeat.org/) 
	for computing image feature Histograms of Oriented Gradients (HOG). 
	LIBSVM has executable files and we attached them in ./src so you don't need to
	install them. But you need to have Matlab in your computer and install VLFeat to 
	your Matlab. 



Run the code:

	There are 3 steps to run my code:
	1. Put the file digits.mat under folder ./MNIST (or change the DATA_DIR 
	and DATA_FILE_NAME in ./src/main.m and ./src/precomputed_HoG_MNIST.mat to
	where you put your data)

	2. Run the experiments:
		run ./src/main.m in Matlab

		Time cost:
		The main.m has two stages. 
			First, pre-computing HoG feature for MNIST, about 3 hours
			Second, do experiments, about 1.5 hours

		The pre-computing HoG features will be generated in ./src/precomputed_HoG_MNIST.mat
		If you have the file ./src/precomputed_HoG_MNIST.mat in the folder ./src
		The main function will not pre-compute. So from your second running, you cost 1.5 hour.
		It can save time. I put the precomputing data in the folder but not upload to Github


Result format:

	Then there will be five human readable result files generated under ./output

	1. baseline.result
		we don't use PCA and use linear kernel or SVM as baseline
	2. differentPCAtrainingSizes.result
	    change the number of images used for PCA training
	3. differentSVMtrainingSizes.result
	    change the number of images used for SVM training
	4. differentEigenUsed.result
		change the number of eigenvectores used for POCA
	5. differentKernels.result
		change the type of kernels




	All result files are text files with format:
	
		first line:
		parameter/attributes names
		
		second line to the end:
		numbers indicate what we used in the experiments. 

	For example, in differentSVMtrainingSizes.result

	Feature|		PCA num|			SVM num|		Eigen Num|		Kernel|		SVM Accuracy
	hog		600		1000		50		0		0.9474
	hog		600		10000		50		0		0.9737
	hog		600		60000		50		0		0.9796
	raw		600		1000		50		0		0.8587
	raw		600		10000		50		0		0.9082
	raw		600		60000		50		0		0.9244 

	the 2nd line means we use hog feature, 600 images for PCA training, 1000 images for SVM training, 
	50 eigenvectors, kernel types 0 (means linear kernel), get accuracy 0.9474, which means 94.74%

	the 4th line means we use Features as 'raw' (raw image). 600 images for PCA training, 1000 images for SVM training, 50 eigenvectors, kernel types 0 (means linear kernel), get accuracy 0.8687, which means 86.87%
 

