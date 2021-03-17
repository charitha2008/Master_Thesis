% Code for Training the SVR and RF on deep features

% PM deep features from resnet50. Load the saved feature table
% Normal=load('Tab_Resnet50_PM_Normal.mat');
% Cancer=load('Tab_Resnet50_PM_Cancer.mat');
% Benign=load('Tab_Resnet50_PM_Benign.mat');

% BR deep features from resnet50. Load the saved feature table
Normal=load('Tab_Resnet50_BR_Normal2.mat');
Cancer=load('Tab_Resnet50_BR_Cancer2.mat');
Benign=load('Tab_Resnet50_BR_Benign2.mat');

% BR and PM deep features from resnet50. Load the saved feature table
% Normal=load('Tab_Resnet50_BR_PM_Normal.mat');
% Cancer=load('Tab_Resnet50_BR_PM_Cancer.mat');
% Benign=load('Tab_Resnet50_BR_PM_Benign.mat');

% BR and PM deep features from Xception. Load the saved feature table
% Normal=load('Tab_Xception_BR_PM_Normal.mat');
% Cancer=load('Tab_Xception_BR_PM_Cancer.mat');
% Benign=load('Tab_Xception_BR_PM_Benign.mat');

% BR deep features from Xception. Load the saved feature table
% Normal=load('Tab_Xception_BR_Normal.mat');
% Cancer=load('Tab_Xception_BR_Cancer.mat');
% Benign=load('Tab_Xception_BR_Benign.mat');

% PM deep features from Xception. Load the saved feature table
% Normal=load('Tab_Xception_PM_Normal.mat');
% Cancer=load('Tab_Xception_PM_Cancer.mat');
% Benign=load('Tab_Xception_PM_Benign.mat');

% Access the feature table
data_Normal=Normal.Last_table;
data_Cancer=Cancer.Last_table;
data_Benign=Benign.Last_table;

% standardize the missing values if any
data_Normal = standardizeMissing(data_Normal,-99);
data_Cancer= standardizeMissing(data_Cancer,-99);
data_Benign= standardizeMissing(data_Benign,-99);

% remove missing values
data_Normal = rmmissing(data_Normal);
data_Cancer = rmmissing(data_Cancer);
data_Benign = rmmissing(data_Benign);

s = RandStream('mlfg6331_64');% For reproducibility
rng(1);

% Random datasampling using stratified sampling to select same 
% number of data from each category
dataN = datasample(s,data_Normal,height(data_Normal),'Replace',false);
dataC = datasample(s,data_Cancer,height(data_Normal),'Replace',false);
dataB= datasample(s,data_Benign,height(data_Normal),'Replace',false);

% join all data in one table
data = [dataN;dataC;dataB];

% remove filename since its not needed
data.fileName = [];

% Partition the data:train 70% and test 30%
H = height(data);
rng(1);% For reproducibility
c = cvpartition(H,'HoldOut',0.3);
idxTrain = training(c);
idxTest = test(c);
trainData = data(idxTrain,:);
testData = data(idxTest,:);

% Assign X and Y for the model training
Ytrain=trainData.Age;
trainData.Age=[];
Xtrain=trainData;

rng(1); % For reproducibility

% SVR model
% mdl = fitrsvm(Xtrain,Ytrain,'KernelFunction','gaussian',...
%     'OptimizeHyperparameters',{'BoxConstraint','KernelScale','Epsilon','Standardize'},...
%     'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName',...
%     'expected-improvement-plus'));

% RF model
t = templateTree('Reproducible',true);
mdl = fitrensemble(Xtrain,Ytrain,'Method','Bag','OptimizeHyperparameters',...
    {'NumLearningCycles','MinLeafSize','MaxNumSplits'},'Learners',t, ...
    'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName','expected-improvement-plus'))

% estimating the age on test data
Ytest=testData.Age;
testData.Age=[];
Xtest=testData;
Yfit = predict(mdl,Xtest);

% Calculate error values and display
e=Yfit-Ytest;
MAE=mae(e);
MSE = loss(mdl,testData,Ytest);
Errors=[MAE MSE]

% Plot Actual Vs Predicted
err=table(Yfit,Ytest);
B=sortrows(err);
figure
scatter(B.Ytest,B.Yfit,'filled','r')
h2 = lsline;
h2.LineWidth = 2;
h2.Color = 'b';
hold on
x = linspace(18,90);
y = linspace(18,90);
plot(x,y,'g','LineWidth',2);
xlim([18,90]);
ylim([18,90]);
title('Predicted Vs Actual: RF')
xlabel('Actual Age')
ylabel('Predicted Age')
legend('Predicted','Fitted line','Actual')

signAE=abs(Ytest-Yfit);
signSE=(Ytest-Yfit).^2;