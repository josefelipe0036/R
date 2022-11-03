setwd("~/MACHINE LEARNING/Machine Learning with R, tidyverse and mlr")
require(mlr)
require(tidyverse)
data(diabetes, package = "mclust")
diabetes_tib<-as.tibble(diabetes)
head(diabetes_tib)
summary(diabetes_tib)


ggplot(diabetes_tib, aes(glucose, insulin, col= class))+
  geom_point()+
  theme_bw()
ggplot(diabetes_tib, aes(sspg, insulin, col=class))+
  geom_point()+
  theme_bw()
ggplot(diabetes_tib, aes( sspg, glucose, col= class))+
  geom_point()+
  theme_bw()

#####
#### KNN
###
diabete_task<- makeClassifTask(data=diabetes_tib, target= "class")
knn<- makeLearner("classif.knn", par.vals = list("k"=2))
knn_model<- train(knn, diabete_task)
knn_pred <- predict(knn_model, newdata =  diabetes_tib)
performance(knn_pred, measures = list(mmce, acc))


#####
####performing holdout cv
###


holdout<- makeResampleDesc(method = "Holdout", split=2/3, stratify = T )
holdoutCV<- resample(learner = knn, task = diabete_task, resampling = holdout,                     measures= list(mmce, acc))
holdoutCV$aggr
calculateConfusionMatrix(holdoutCV$pred, relative = T)


#####
####performing K-Fold CV
###


KFold<- makeResampleDesc(method = "RepCV", folds=10, reps=50, stratify = T)
KFoldCV <- resample(learner = knn, task =  diabete_task, resampling = KFold, measures =  list(mmce, acc))
calculateConfusionMatrix(KFoldCV$pred, relative = T)


#####
####performing leave-one-out CV melhor para pequenos datasets
###

