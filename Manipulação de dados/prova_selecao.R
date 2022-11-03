library(readxl)
library(tidyverse)
countries <- read_excel("~/Área de Trabalho/countries.xlsx")
human_freedom<-read_xlsx("~/Área de Trabalho/human_freedom.xlsx")#lendo os dados
medals_olympics<- read_xlsx("~/Área de Trabalho/medals_olympics.xlsx")
hapiness_report<-read_xlsx("~/Área de Trabalho/hapiness_report.xlsx")

summary(human_freedom)

##limpando humam_freedom Método1
#human_freedom$hf_score= ifelse(is.na(human_freedom$hf_score),
                               #mean(human_freedom$hf_score, na.rm = T),
                               #human_freedom$hf_score)
#human_freedom$hf_score==0.0 #verificando se há alguma observação zerada
#human_freedom$hf_score<0 #verificando se há alguam obs menor do que zero

##limpando humam_freedom pelo metodo2, usando como referência hf_rank
human_freedom<-filter(human_freedom, !is.na(human_freedom$hf_rank))
is.na(human_freedom)


####Questão 2

Total<-medals_olympics$`Gold Medal`+medals_olympics$`Silver Medal`+medals_olympics$`Bronze Medal`
medals_olympics=mutate(medals_olympics,Total)

####Questão 3
#A regra usada para classificação seria a quantidade de medalhas de ouro

(top<-head(arrange(medals_olympics, desc('Gold Medal')),10))


ggplot(top) +
  aes(x = Country, weight = `Gold Medal`) +
  geom_bar(fill = "#FF8C00") +
  labs(
    x = "Países",
    y = "Quantidade de medalhas",
    title = "Ranking dos países nas Olímpiadas",
    subtitle = "Medalha de ouro",
    caption = "Medals_olympics"
  ) +
  coord_flip() +
  theme_classic()



####Questão 4
                    
ggplot(countries) +
  aes(x = Region, y = `Literacy (%)`) +
  geom_boxplot(shape = "circle", fill = "#22B290") +
  labs(title = "Literacy per region", caption = "Countries") +
  coord_flip()+
  theme_classic()

region_literacy<-countries%>%
  group_by(Region)%>%
  summarise(mean_region = mean(`Literacy (%)`))


ggplot(region_literacy) +
  aes(x = Region, weight = mean_region) +
  geom_bar(fill = "#4682B4") +
  labs(
    x = "Regiões",
    y = "Taxa média de alfabetização",
    title = "Média de alfabetização por região",
    caption = "countries"
  ) +
  coord_flip() +
  theme_classic()








###5


phone_per1000<-head(arrange(countries,desc(`Phones (per 1000)`)),5)%>%
  select(Country, 'Phones (per 1000)')


ggplot(phone_per1000) +
  aes(x = Country, weight = `Phones (per 1000)`) +
  geom_bar(fill = "#014654") +
  labs(
    x = "Países",
    y = "Número de celulares a cada mil habitantes.",
    title = "Os cinco países com maior número de celulares a cada mil habitantes.",
    caption = "Countries"
  ) +
  theme_classic()



###6

human_freedom%>%
  filter(year == 2018)%>%
  head()


###7
(grafico_brasil<-human_freedom%>%
  filter(countries=="brazil")%>%
  select(year, countries, hf_score)%>%
  ggplot() +
  aes(x = year, y = hf_score) +
  geom_line(size = 2.5, colour = "#EF562D") +
  labs(title = "A evolução do hf_score (human freedom score) do Brasil",
       caption = "human_ffredom") +
  theme_minimal() +
  xlim(2007L, 2018L))


###8
region_pop<-countries%>%
  group_by(Region)%>%
  summarise(pop_region = mean(Population))
head(arrange(region_pop, desc(pop_region)),1)


###9

  
cor(countries$Population, countries$`Net migration`)


###10
(bronze<-head(
  arrange(medals_olympics, 
          desc(medals_olympics$`Bronze Medal`)),10))


ggplot(bronze) +
  aes(x = Country, weight = `Bronze Medal`) +
  geom_bar(fill = "#FF8C00") +
  labs(
    x = "Países",
    y = "Quantidade de medalhas",
    title = "Ranking dos países nas Olímpiadas",
    subtitle = "Medalha de bronze",
    caption = "Medals_olympics"
  ) +
  coord_flip() +
  theme_classic()



###11
medals_olympics[,2:4]= scale(medals_olympics[,2:4])
countries[,3:20]= scale(countries[,3:20])
human_freedom$womens_freedom = as.numeric(human_freedom$womens_freedom)
human_freedom[,5:12]= scale(human_freedom[,5:12])
hapiness_report[,3:9]= scale(hapiness_report[,3:9])

####12
countries<-filter(countries,!is.na(countries$Deathrate))

cor(countries$Birthrate, countries$Deathrate)


#### 13

cor(hapiness_report$Generosity, countries$Agriculture)


###14 
###
###
###


### 15


ggplot(human_freedom) +
 aes(x = countries, y = pf_ss_homicide) +
 geom_boxplot(shape = "circle", fill = "#B22222") +
 coord_flip() +
 theme_minimal()


equador<-human_freedom%>%
  filter(countries== "ecuador")
range(equador$pf_ss_homicide)
diff(range(equador$pf_ss_homicide))


###16



human_freedom%>%
  select(countries, hf_score, year, hf_rank)%>%
  filter(countries=="unitedstates")%>%
  view()



###17
base<-inner_join(countries, medals_olympics, by= "Country")
cor(base$Population, base$`Gold Medal`)


###18


teste<-select(hapiness_report, !'GDP per capita')
teste<- teste%>%
  rename(Country= Countryorregion)
base<-inner_join(base, teste, by= "Country")

base<-rename(human_freedom, Country= countries)%>%
  inner_join(base, human_freedom, by = "Country")
cor(base$`GDP ($ per capita)`, base$`Gold Medal`)
cor(base$`Literacy (%)`, base$`Gold Medal`)

###19

cor(countries$`Coastline (coast/area ratio)`, countries$Agriculture)
cor(countries$`Coastline (coast/area ratio)`, countries$Industry)


###20

base_medalha<-countries%>%
  select(Country, Region)%>%
  inner_join(medals_olympics, by= "Country")


region_medalha<-base_medalha%>%
  group_by(Region)%>%
  summarise(medalha_region = sum(Total))



ggplot(region_medalha) +
  aes(x = Region, weight = medalha_region) +
  geom_bar(fill = "#FF8C00") +
  labs(title = "Medalhas por região") +
  theme_classic()