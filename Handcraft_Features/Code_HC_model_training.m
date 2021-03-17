% Code for Training the SVR and RF on Handcrafted features

% load PM region HC feature data
% data_Normal = readtable('Data_files/Normal_stat_PM.xls','TreatAsEmpty',{'.','NA'});
% data_Cancer = readtable('Data_files/Cancer_stat_PM.xls','TreatAsEmpty',{'.','NA'});
% data_Benign = readtable('Data_files/Benign_stat_PM.xls','TreatAsEmpty',{'.','NA'});

% load BR region HC feature data
% data_Normal = readtable('Data_files/Normal_stat_BR.xls','TreatAsEmpty',{'.','NA'});
% data_Cancer = readtable('Data_files/Cancer_stat_BR.xls','TreatAsEmpty',{'.','NA'});
% data_Benign = readtable('Data_files/Benign_stat_BR.xls','TreatAsEmpty',{'.','NA'});

% load whole MLO HC feature data
data_Normal = readtable('Data_files/Normal_stat_BR_PM.xls','TreatAsEmpty',{'.','NA'});
data_Cancer = readtable('Data_files/Cancer_stat_BR_PM.xls','TreatAsEmpty',{'.','NA'});
data_Benign = readtable('Data_files/Benign_stat_BR_PM.xls','TreatAsEmpty',{'.','NA'});

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
%     'expected-improvement-plus'))

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
e=Ytest-Yfit;
MAE=mae(e);
MAE2=(sum(abs(Ytest-Yfit))/length(Ytest))
MSE = loss(mdl,testData,Ytest);
Errors=[MAE MSE]
% Errors=table(MAE,MSE,'VariableNames',{'MAE','MSE'})

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