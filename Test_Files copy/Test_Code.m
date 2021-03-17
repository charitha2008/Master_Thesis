% Age 65 prediction from normal

%load Unet segmantation model
load('Unet_Seg_model')
%Testing the data for one image
testImage= imread('1169_A_0446_1.LEFT_MLO.LJPEG.1_highpass.png');
info3 = imfinfo('1169_A_0446_1.LEFT_MLO.LJPEG.1_highpass.png');
testImage2=testImage;
imageSize2=[32 32];%for resizing the image before Unet segmentaion
imageSize3=[info3.Height info3.Width];%for resizing back to the original size

% resizing the image before Unet segmentaion
testImage = imresize(testImage,imageSize2);

% segmenting the image
C = semanticseg(testImage,net);
C3=uint8(C);

% for extracting the PM+BR from the image
Aseg1 = zeros(size(testImage),'like',testImage);
Aseg2 = zeros(size(testImage),'like',testImage);
BW = C3 == 1;%1 for background 2 for PM and 3 for BR
BW = repmat(BW,[1 1 3]);
Aseg1(BW) = testImage(BW);
Aseg2(~BW) = testImage(~BW);%without background if BW=1
Aseg3=imresize(Aseg2,imageSize3);%resize back to original

% masking
Mask = Aseg3(:,:,1)>0;
A=double(testImage2);
Segmented = A.*repmat(Mask,[1,1,3]);
Segmented = uint8(Segmented); 

subplot(2,3,1), imshow(uint8(A)),title('Original Image');
subplot(2,3,2), imshow(Aseg3),title('Probable Region');
subplot(2,3,3), imshow(Mask),title('Mask');
subplot(2,3,4), imshow(Segmented),title('Segmented = A.*Mask');
% Code to extract features using ResNet50 from Normal images


% extract features from the given image using ResNet50
net = resnet50;
inputSize = net.Layers(1).InputSize;
segResized=imresize(Segmented,[inputSize(1) inputSize(2)]);%resize image for feature extraction
layer = 'fc1000';%activation layer
features = activations(net,segResized,layer,'OutputAs','rows');%1000 features

%---------Code for extracting the Actual age from the Excel sheets--------
a=1;
fileName = strings;
fileName(a) = info3.Filename;
L = length( fileName );
fileName3 = strings;

for k3 = 1:L
    fileName2 = split(fileName(k3),"/");
    fileName3=fileName2(9);%change value according to the file location
end

T_N = readtable('List_Normal.xlsx');%Data file with Age
rows = (contains(T_N.fileName,fileName3));
T1_N=T_N(rows,:);

T = table(T1_N.fileName,T1_N.Age,'VariableNames',{'fileName','Age'});

%---------------END Age extraction---------------------------------

%convert feature data to a table
fT=array2table(features);

% Concat features data with the Age
Last_table=[T fT];

% ---Passing the feature table to the model and estimating the age------
Last_table.fileName=[];
Actual_age=Last_table.Age;
Last_table.Age=[];
X_features=Last_table;%1000 features

% load the best model for age estimation
load('resnet50bestmdl.mat');

Yfit = predict(mdl,X_features)
ages=table(Actual_age,Yfit,'VariableNames',{'Actual','Predicted'})
