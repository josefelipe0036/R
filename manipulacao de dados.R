setwd("~/MACHINE LEARNING/Machine Learning with R, tidyverse and mlr")

require(tidyverse)
data(CO2)
CO2tib<- as.tibble(CO2)
head(CO2)
arranged_data<-CO2%>%
  select(1,2,3,5)%>% #seleciona as variáveis
  filter(uptake>16)%>%# filtra
  group_by(Plant)%>%#agrupa de acordo com plant
  summarize(meanUP= mean(uptake), sdUP=sd(uptake))%>%#cria duas coluna, média e dp
  mutate(coeficiente_variacao= (sdUP/meanUP)*100)%>%#cria coluna coef
  arrange(coeficiente_variacao)#ordena
arranged_data