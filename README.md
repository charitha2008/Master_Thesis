# Master_Thesis
AI-based Age Estimation from Mammograms

Background: Age estimation has attracted attention because of its various clinical and medical applications. There are many studies on human age estimation from biomedical images such as X-ray images, MRI, facial images, dental images etc. However, there is no research done on mammograms for age estimation. Therefore, in our research, we focus on age estimation from mammogram images.

Objectives: The purpose of this study is to make an AI-based model for estimating age from mammogram images based on the pectoral muscle segment and check its accuracy. At first, we segment the pectoral muscle from mammograms. Then we extract deep learning features and handcrafted features from the pectoral muscle segment as well as other regions for comparison. From these features, we built models to estimate the age.

Methods: We have selected an experiment method to answer our research question. We have used the U-net model for pectoral muscle segmentation. After that, we have extracted handcrafted features and deep learning features from pectoral muscle using ResNet-50 and Xception. Then we trained Support Vector Regression and Random Forest models to estimate the age based on the pectoral muscle of mammograms. Finally, we observed how accurately these models are in estimating the age by comparing the MSE and MAE values. We have considered breast region (BR) and the whole MLO to answer our research question.

Results: The MAE values for both SVR and RF models from handcrafted features is around 10 in years in all cases. On the other hand, with deep learning features MAE is less as compared to handcrafted features. In our experiment, the least observed error value for MAE was around 8.4656 years for the model that extracted the features from the whole MLO using ResNet50 and SVR as the regression model.

Conclusions: We have concluded that the breast region (BR) is more accurate in estimating the age compared to PM by having least MAE and MSE values in its models. Moreover, we were able to observe that handcrafted feature models are not as accurate as deep feature models in estimating the age from mammograms.

Full text available at: http://bth.diva-portal.org/smash/record.jsf?pid=diva2:1451390
