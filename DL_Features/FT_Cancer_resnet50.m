% Code to extract features using ResNet50 from Cancer images

% Specify the folder to extarct the features from
imds=imageDatastore('/Users/dilukshidissanayake/Desktop/Thesis/Code/DDSM_Mini/SegImages_BR_Cancer/');

net = resnet50;
inputSize = net.Layers(1).InputSize;
% analyzeNetwork(net)
augimds = augmentedImageDatastore(inputSize(1:2),imds,'ColorPreprocessing','gray2rgb');
layer = 'fc1000';%activation layer
features = activations(net,augimds,layer,'OutputAs','rows');

% code to read filenames from datastore and store in string array to match with excel
% data.
nFiles = length(imds.Files);
str_N = strings;
a=1;
for k = 1:nFiles
    [img1,info] = readimage(imds,k);
    str_N(a) = info.Filename;
    a=a+1;
end
L = length( str_N );
str3_N = strings;
a4=1;
for k3 = 1:L
    str2_N = split(str_N(k3),"/");
    str3_N(a4)=str2_N(9);%change value according to the file location
    a4=a4+1;
end

% code to read excelsheets and extract rows matching file names in
% datastore
T_N = readtable('List_Cancer.xlsx');%Data file with Age
rows = (contains(T_N.fileName,str3_N));
T1_N=T_N(rows,:);

T = array2table(zeros(0,2), 'VariableNames',{'fileName','Age'});

% extract corresponding Age values for each image in imagedatastore 
for k = 1:nFiles
    [img1,info] = readimage(imds,k);
    if ismember(str3_N(k),T1_N.fileName)
        row1 = find(ismember(T1_N.fileName,str3_N(k)));
        info.Label=table2array(T1_N(row1,3));
        T2=table(cellstr(info.Filename),info.Label,'VariableNames',{'fileName','Age'});
        T=[T;T2];
    end
end
%convert feature data to a table
fT=array2table(features);

% Concat features data with the Age
Last_table=[T fT];%saved this table varible 
