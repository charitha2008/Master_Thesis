% load the Ground truth labels and change the paths
load('/Users/dilukshidissanayake/Desktop/Thesis/Code/DDSM_Mini/Images/gTruth.mat')
oldPathDataSource = "F:\BTH\MS SMES 4\Unet-data";
newPathDataSource = fullfile(pwd,"Images/unet-data");
alterPaths = {[oldPathDataSource newPathDataSource]};

oldPathPixelLabel = "F:\BTH\MS SMES 4\unet_data_3_labbled\PixelLabelData";
newPathPixelLabel = fullfile(pwd,"Images/PixelLabelData");
alterPaths1 = {[oldPathPixelLabel newPathPixelLabel]};
unresolvedPaths = changeFilePaths(gTruth,alterPaths);
unresolvedPaths1 = changeFilePaths(gTruth,alterPaths1)

%datastore for training and testing
% trainingData = pixelLabelImageDatastore(gTruth,'OutputSize',[32 32],'ColorPreprocessing','rgb2gray');
trainingData = pixelLabelImageDatastore(gTruth,'OutputSize',[64 64]);
trainingData2 = partitionByIndex(trainingData,[1:115]);
testingData = partitionByIndex(trainingData,[116:120]);

%Model creation
numClasses=3;
imageSize = [32 32 3];
lgraph = unetLayers(imageSize, numClasses);

% setting training options
initialLearningRate = 0.05;
maxEpochs = 150;
minibatchSize = 16;
l2reg = 0.0001;

options = trainingOptions('sgdm',...
    'InitialLearnRate',initialLearningRate, ...
    'Momentum',0.9,...
    'L2Regularization',l2reg,...
    'MaxEpochs',maxEpochs,...
    'MiniBatchSize',minibatchSize,...
    'LearnRateSchedule','piecewise',...    
    'Shuffle','every-epoch',...
    'GradientThresholdMethod','l2norm',...
    'GradientThreshold',0.05, ...
    'Plots','training-progress', ...
    'VerboseFrequency',20);

% train the network. This trained network is saved as net2
[net, info] = trainNetwork(trainingData2,lgraph,options);

%Evaluate the segmentation model
pxdsResults = semanticseg(testingData,net,"WriteLocation",tempdir);
metrics = evaluateSemanticSegmentation(testingData,pxdsResults)