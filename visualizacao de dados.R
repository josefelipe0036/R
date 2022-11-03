setwd("~/MACHINE LEARNING/Machine Learning with R, tidyverse and mlr")
require(ggplot2)
require(dplyr)
data(iris)
Plot<-iris%>%
  ggplot(aes(x= Sepal.Length, y= Sepal.Width))+
  geom_point()
Plot

Plot+
  geom_density2d()+
  geom_smooth()


ggplot(iris, aes(Sepal.Length, Sepal.Width, shape= Species))+
  geom_point()+
  theme_bw()

ggplot(iris, aes(Sepal.Length, Sepal.Width, col= Species))+
  geom_point()+
  theme_bw()

ggplot(iris, aes(Sepal.Length, Sepal.Width))+
  facet_wrap(~Species)+
  geom_point()+
  theme_bw()