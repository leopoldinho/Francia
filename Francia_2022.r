#Packages
library(tidyverse)
library(googlesheets4)

#Dependencies
francia_secondo_turno_2022 <- read.csv("https://raw.githubusercontent.com/leopoldinho/Francia/main/p2022-resultats-communes-t2.csv", encoding = "UTF-8")%>%
  select(CODGEO=X.U.FEFF.CodeInsee,Commune,Abstentions_ins,MACRON.exp,LE.PEN.exp)
redditi_2019_comuni_francia <- read.csv2("https://raw.githubusercontent.com/leopoldinho/Francia/main/cc_filosofi_2019_COM.CSV")%>%
  select(CODGEO,MED19, TP6019)


#ANALISI
#Unisco i due dataset
francia_ballottaggio_2022 <- left_join(francia_secondo_turno_2022,redditi_2019_comuni_francia, by="CODGEO")

francia_ballottaggio_2022$TP6019 <- sapply(francia_ballottaggio_2022$TP6019, as.character) 

francia_ballottaggio_2022$TP6019[is.na(francia_ballottaggio_2022$TP6019)] <- ""


write.csv(francia_ballottaggio_2022, "ballottaggio_Francia_22.csv",fileEncoding="UTF-8")