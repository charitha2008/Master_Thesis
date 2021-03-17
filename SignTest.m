ResNet_BR_PM_RF=load('DL_Features/signTableResNet+BR+PM+RF');
ResNet_BR_RF=load('DL_Features/signTableResNet+BR+RF');
ResNet_BR_PM_SVR=load('DL_Features/signTableResNet+BR+PM+SVR');
ResNet_BR_SVR=load('DL_Features/signTableResNet+BR+SVR');

ResNet_BR_PM_RF=ResNet_BR_PM_RF.signTable;
ResNet_BR_RF=ResNet_BR_RF.signTable;
ResNet_BR_PM_SVR=ResNet_BR_PM_SVR.signTable;
ResNet_BR_SVR=ResNet_BR_SVR.signTable;

% [p,h,stats] = signrank(ResNet_BR_PM_RF.signAE,ResNet_BR_RF.signAE,'alpha',0.05,'tail','left','method','exact')
% [p,h,stats] = signrank(ResNet_BR_PM_RF.signAE,ResNet_BR_RF.signAE,'alpha',0.01,'tail','left','method','approximate')
% [h,p] = ttest(signTableResNet3.signAE,signTableResNet4.signAE)
% [p2,h2,stats2] = signrank(ResNet_BR_PM_SVR.signAE,ResNet_BR_SVR.signAE,'alpha',0.05,'tail','left','method','exact')
% [p2,h2,stats2] = signrank(ResNet_BR_PM_SVR.signAE,ResNet_BR_SVR.signAE,'alpha',0.01,'tail','left','method','approximate')

[p,h,stats] = ranksum(ResNet_BR_RF.signAE,ResNet_BR_PM_RF.signAE,'alpha',0.05,'tail','left','method','approximate')
[p2,h2,stats2] = ranksum(ResNet_BR_SVR.signAE,ResNet_BR_PM_SVR.signAE,'alpha',0.05,'tail','left','method','approximate')
