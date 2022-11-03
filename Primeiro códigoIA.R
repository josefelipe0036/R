setwd("~/MACHINE LEARNING/Machine Learning with R, tidyverse and mlr")

###Primeiro código 
numberofLegs<- c(4,4,0)
climbTrees<-c(T,F,T)

for(i in 1:3){
  if (numberofLegs[i] == 4) {
    if (climbTrees[i])
      print("cat") 
    else print("dog")
    }else print("snake")
}    