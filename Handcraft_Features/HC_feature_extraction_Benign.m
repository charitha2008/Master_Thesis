% Code to extract handcrafted features from Benign images
% image folder loaction
location_Benign = '/Users/dilukshidissanayake/Desktop/Thesis/Code/DDSM_Mini/New_Images/Benign/*.png';       %  folder in which your images exists

ds_Benign = imageDatastore(location_Benign);
bFiles = length(ds_Benign.Files);


% code to read filenames from datastore and store in string array to match with excel
% data.
str_B = strings;
a3=1;
for k = 1:bFiles
    [img3,info] = readimage(ds_Benign,k);
    str_B(a3) = info.Filename;
    a3=a3+1;
end

L3 = length( str_B );
str3_B = strings;
a6=1;

for k3 = 1:L3
    str2_B = split(str_B(k3),"/");
    str3_B(a6)=str2_B(10);%make sure to change the value according to the file path
    a6=a6+1;
end

% code to read excelsheets and extract rows matching file names in
% datastore

T_B = readtable('Data_files/List_Benign.xlsx');
rows = (contains(T_B.fileName,str3_B));
T1_B=T_B(rows,:);

% load the trained Unet Network
load('Data_files/net2.mat');

% Table to store extracted features
T = array2table(zeros(0,8), 'VariableNames',{'fileName','meanIntensity','staDev','entropy','Contrast','Correlation','Energy','Homogeneity'});

% code to extract features
for i = 1:length(ds_Benign.Files)
    testImage = readimage(ds_Benign,i);
    [testImage2 info4] = readimage(ds_Benign,i);
    imageSize2=[32 32];
    info3 = imfinfo(info4.Filename);
    
    %code to obtain the file name
    a=1;
    fileName = strings;
    fileName(a) = info3.Filename;
    L = length( fileName );
    fileName3 = strings;
    
    
    for k3 = 1:L
        fileName2 = split(fileName(k3),"/");
        fileName3=fileName2(10);%change value according to the file location
    end
    
    imageSize3=[info3.Height info3.Width];
    testImage = imresize(testImage,imageSize2);
    
    C = semanticseg(testImage,net);%segmenting the image
    C3=uint8(C);
    Aseg1 = zeros(size(testImage),'like',testImage);
    Aseg2 = zeros(size(testImage),'like',testImage);
    BW = C3 == 2;% 1 for background, 2 for PM and 3 for BR
    BW = repmat(BW,[1 1 3]);
    Aseg1(BW) = testImage(BW);
    Aseg2(~BW) = testImage(~BW);% use Aseg2 to remove background and take only PM & BR
    
    Aseg3=imresize(Aseg1,imageSize3);% use Aseg2 insted of Asge1 to remove background and take only PM & BR
    imshowpair(Aseg3,testImage2,'montage')
    
    %masking the original images
    Mask = Aseg3(:,:,1)>0;
    testImage2=double(testImage2);
    Segmented = testImage2.*repmat(Mask,[1,1,3]);
    Segmented = uint8(Segmented);
    
    %     resize segmented images before feature extraction
    Segsize=[224 224];
    Segmented = imresize(Segmented,Segsize);
    
    if size(Segmented,3)==3
        Segmented2=rgb2gray(Segmented);%convert to gray  before feature extraction
        glcms = graycomatrix(Segmented2);
        stats = graycoprops(glcms);
        meanIntensity = mean2(Segmented2);
        staDev = std2(Segmented2);
        entro=entropy(Segmented2);
    end
    
    subplot(2,3,1), imshow(uint8(testImage2)),title('Original Image');
    subplot(2,3,2), imshow(Aseg3),title('Probable PM Region');
    subplot(2,3,3), imshow(Mask),title('Mask = PM>0');
    subplot(2,3,4), imshow(Segmented),title('Segmented = A.*Mask');
    subplot(2,3,5), imshow(Segmented2),title('Segmented Gray');
    
    
    T2=table(cellstr(fileName3),meanIntensity,staDev,entro,stats.Contrast,stats.Correlation,stats.Energy,...
        stats.Homogeneity,'VariableNames',{'fileName','meanIntensity','staDev','entropy',...
        'Contrast','Correlation','Energy','Homogeneity'});
    T=[T;T2];
end
% remove view column from the table
T1_B.View=[];

% join the tables to store features and age in one table
T3 = join(T,T1_B);

% writetable(T3,'Benign_stat_PM.xls');% to save the final table in xls files
% writetable(T3,'Benign_stat_BR.xls');
% writetable(T3,'Benign_stat_BR_PM.xls');