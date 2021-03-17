%Code for training SVR and RF on handcrafted BR and PM, which has 14 features.

%load handcrafted PM data
data_Normal_PM = readtable('Data_files/Normal_stat_PM.xls','TreatAsEmpty',{'.','NA'});
data_Cancer_PM = readtable('Data_files/Cancer_stat_PM.xls','TreatAsEmpty',{'.','NA'});
data_Benign_PM = readtable('Data_files/Benign_stat_PM.xls','TreatAsEmpty',{'.','NA'});

%load handcrafted BR data
data_Normal_BR = readtable('Data_files/Normal_stat_BR.xls','TreatAsEmpty',{'.','NA'});
data_Cancer_BR = readtable('Data_files/Cancer_stat_BR.xls','TreatAsEmpty',{'.','NA'});
data_Benign_BR = readtable('Data_files/Benign_stat_BR.xls','TreatAsEmpty',{'.','NA'});

% remove missing values
data_Normal_PM = rmmissing(data_Normal_PM);
data_Cancer_PM = rmmissing(data_Cancer_PM);
data_Benign_PM = rmmissing(data_Benign_PM);
data_Normal_BR = rmmissing(data_Normal_BR);
data_Cancer_BR = rmmissing(data_Cancer_BR);
data_Benign_BR = rmmissing(data_Benign_BR);

% Join BR and PM into one table using the filename as the key variable
dataN=join(data_Normal_PM,data_Normal_BR,'Keys','fileName');
dataC=join(data_Cancer_PM,data_Cancer_BR,'Keys','fileName');
dataB=join(data_Benign_PM,data_Benign_BR,'Keys','fileName');


s = RandStream('mlfg6331_64');% For reproducibility
rng(1);

% Random datasampling using stratified sampling to select same 
% number of data from each category
dataN = datasample(s,dataN,height(data_Normal_PM),'Replace',false);
dataC = datasample(s,dataC,height(data_Normal_PM),'Replace',false);
dataB= datasample(s,dataB,height(data_Normal_PM),'Replace',false);

% Since each table as diffrent variable named after joinig the tables, 
% changed the variable names to have common Varible names.
dataN.Properties.VariableNames{'meanIntensity_data_Normal_PM'} = 'MI_1';
dataN.Properties.VariableNames{'staDev_data_Normal_PM'} = 'SD_1';
dataN.Properties.VariableNames{'entropy_data_Normal_PM'} = 'Entropy_1';
dataN.Properties.VariableNames{'Contrast_data_Normal_PM'} = 'Contrast_1';
dataN.Properties.VariableNames{'Correlation_data_Normal_PM'} = 'Correlation_1';
dataN.Properties.VariableNames{'Energy_data_Normal_PM'} = 'Energy_1';
dataN.Properties.VariableNames{'Homogeneity_data_Normal_PM'} = 'Homogeneity_1';
dataN.Properties.VariableNames{'Age_data_Normal_PM'} = 'Age_1';
dataN.Properties.VariableNames{'meanIntensity_data_Normal_BR'} = 'MI_2';
dataN.Properties.VariableNames{'staDev_data_Normal_BR'} = 'SD_2';
dataN.Properties.VariableNames{'entropy_data_Normal_BR'} = 'Entropy_2';
dataN.Properties.VariableNames{'Contrast_data_Normal_BR'} = 'Contrast_2';
dataN.Properties.VariableNames{'Correlation_data_Normal_BR'} = 'Correlation_2';
dataN.Properties.VariableNames{'Homogeneity_data_Normal_BR'} = 'Homogeneity_2';
dataN.Properties.VariableNames{'Energy_data_Normal_BR'} = 'Energy_2';
dataN.Properties.VariableNames{'Age_data_Normal_BR'} = 'Age_2';

dataB.Properties.VariableNames{'meanIntensity_data_Benign_PM'} = 'MI_1';
dataB.Properties.VariableNames{'staDev_data_Benign_PM'} = 'SD_1';
dataB.Properties.VariableNames{'entropy_data_Benign_PM'} = 'Entropy_1';
dataB.Properties.VariableNames{'Contrast_data_Benign_PM'} = 'Contrast_1';
dataB.Properties.VariableNames{'Correlation_data_Benign_PM'} = 'Correlation_1';
dataB.Properties.VariableNames{'Energy_data_Benign_PM'} = 'Energy_1';
dataB.Properties.VariableNames{'Homogeneity_data_Benign_PM'} = 'Homogeneity_1';
dataB.Properties.VariableNames{'Age_data_Benign_PM'} = 'Age_1';
dataB.Properties.VariableNames{'meanIntensity_data_Benign_BR'} = 'MI_2';
dataB.Properties.VariableNames{'staDev_data_Benign_BR'} = 'SD_2';
dataB.Properties.VariableNames{'entropy_data_Benign_BR'} = 'Entropy_2';
dataB.Properties.VariableNames{'Contrast_data_Benign_BR'} = 'Contrast_2';
dataB.Properties.VariableNames{'Correlation_data_Benign_BR'} = 'Correlation_2';
dataB.Properties.VariableNames{'Homogeneity_data_Benign_BR'} = 'Homogeneity_2';
dataB.Properties.VariableNames{'Energy_data_Benign_BR'} = 'Energy_2';
dataB.Properties.VariableNames{'Age_data_Benign_BR'} = 'Age_2';

dataC.Properties.VariableNames{'meanIntensity_data_Cancer_PM'} = 'MI_1';
dataC.Properties.VariableNames{'staDev_data_Cancer_PM'} = 'SD_1';
dataC.Properties.VariableNames{'entropy_data_Cancer_PM'} = 'Entropy_1';
dataC.Properties.VariableNames{'Contrast_data_Cancer_PM'} = 'Contrast_1';
dataC.Properties.VariableNames{'Correlation_data_Cancer_PM'} = 'Correlation_1';
dataC.Properties.VariableNames{'Energy_data_Cancer_PM'} = 'Energy_1';
dataC.Properties.VariableNames{'Homogeneity_data_Cancer_PM'} = 'Homogeneity_1';
dataC.Properties.VariableNames{'Age_data_Cancer_PM'} = 'Age_1';
dataC.Properties.VariableNames{'meanIntensity_data_Cancer_BR'} = 'MI_2';
dataC.Properties.VariableNames{'staDev_data_Cancer_BR'} = 'SD_2';
dataC.Properties.VariableNames{'entropy_data_Cancer_BR'} = 'Entropy_2';
dataC.Properties.VariableNames{'Contrast_data_Cancer_BR'} = 'Contrast_2';
dataC.Properties.VariableNames{'Correlation_data_Cancer_BR'} = 'Correlation_2';
dataC.Properties.VariableNames{'Homogeneity_data_Cancer_BR'} = 'Homogeneity_2';
dataC.Properties.VariableNames{'Energy_data_Cancer_BR'} = 'Energy_2';
dataC.Properties.VariableNames{'Age_data_Cancer_BR'} = 'Age_2';

% join all data in one table
data = [dataN;dataC;dataB];
% remove filename since its not needed 
data.fileName = [];
% remove Age_1 since only one age column should be there
data.Age_1 = [];

% Change Age_2 varibale name to Age
data.Properties.VariableNames{'Age_2'} = 'Age';

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
mdl = fitrsvm(Xtrain,Ytrain,'KernelFunction','gaussian',...
    'OptimizeHyperparameters',{'BoxConstraint','KernelScale','Epsilon','Standardize'},...
    'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName',...
    'expected-improvement-plus'))
% RF model
% t = templateTree('Reproducible',true);
% mdl = fitrensemble(Xtrain,Ytrain,'Method','Bag','OptimizeHyperparameters',...
%     {'NumLearningCycles','MinLeafSize','MaxNumSplits'},'Learners',t, ...
%     'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName','expected-improvement-plus'))

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
title('Predicted Vs Actual: SVR')
xlabel('Actual Age')
ylabel('Predicted Age')
legend('Predicted','Fitted line','Actual')