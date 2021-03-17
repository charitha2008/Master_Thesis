% Code to create segmented images for deep learning and save them in
% another folder
% Loaction to the Normal image folder
location_Normal = '/Users/dilukshidissanayake/Desktop/Thesis/Code/DDSM_Mini/New_Images/Normal/*.png';       %  folder in which your images exists
ds_Normal = imageDatastore(location_Normal);

% load trained Unet network
load('/Users/dilukshidissanayake/Desktop/Thesis/Code/DDSM_Mini/net2.mat');


for i = 1:length(ds_Normal.Files)
    testImage = readimage(ds_Normal,i);
    [testImage2 info4] = readimage(ds_Normal,i);
    imageSize2=[32 32];
    info3 = imfinfo(info4.Filename);
    
    a=1;
    fileName = strings;
    fileName(a) = info3.Filename;
    L = length( fileName );
    fileName3 = strings;
    
    
    for k3 = 1:L
        fileName2 = split(fileName(k3),"/");
        fileName3=fileName2(10);%change value according to the file location
    end
    fileName3 = erase(fileName3,".png");
    imageSize3=[info3.Height info3.Width];
    testImage = imresize(testImage,imageSize2);
    C = semanticseg(testImage,net);
    C3=uint8(C);
    Aseg1 = zeros(size(testImage),'like',testImage);
    Aseg2 = zeros(size(testImage),'like',testImage);% use Aseg2 to remove background and take only PM & BR
    
    BW = C3 == 2;%1 for background, 2 for PM and 3 for BR
    BW = repmat(BW,[1 1 3]);
    Aseg1(BW) = testImage(BW);
    Aseg2(~BW) = testImage(~BW);
    
    Aseg3=imresize(Aseg1,imageSize3);% use Aseg2 instead of Asge1 to remove background and take only PM & BR
    
    Mask = Aseg3(:,:,1)>0;
    testImage2=double(testImage2);
    Segmented = testImage2.*repmat(Mask,[1,1,3]);
    Segmented = uint8(Segmented);
    Segmented = rgb2gray(Segmented);
    
    %write the segmeneted images to the given location
    imwrite(Segmented , strcat('/Users/dilukshidissanayake/Desktop/Thesis/Code/DDSM_Mini/SegImages_PM_Normal/', num2str(fileName3), '.png'), 'png');
%     imwrite(Segmented , strcat('/Users/dilukshidissanayake/Desktop/Thesis/Code/DDSM_Mini/SegImages_BR_Normal/', num2str(fileName3), '.png'), 'png');
%     imwrite(Segmented , strcat('/Users/dilukshidissanayake/Desktop/Thesis/Code/DDSM_Mini/SegImages_BR_PM_Normal/', num2str(fileName3), '.png'), 'png');
    
end
