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
francia_ballottaggio_2022 <- left_join(francia_secondo_turno_2022,redditi_2019_comuni_francia, by="CODGEO") %>%
  mutate_if(is.numeric, round, 2)

francia_ballottaggio_2022$TP6019 <- sapply(francia_ballottaggio_2022$TP6019, as.character) 

francia_ballottaggio_2022$TP6019[is.na(francia_ballottaggio_2022$TP6019)] <- ""


#Creo due nuove colonne con il risultato

francia_ballottaggio_2022 <- francia_ballottaggio_2022 %>%
  mutate(Vantaggio_Macron=ifelse(MACRON.exp < "50.00","",
                                        ifelse(MACRON.exp == "50.00", "pari",
                                        ifelse(MACRON.exp > "50.00" & MACRON.exp <="54.99","Macron 1",
                                        ifelse(MACRON.exp > "54.99" & MACRON.exp <= "59.99","Macron 2",
                                               ifelse(MACRON.exp > "59.99" & MACRON.exp <= "64.99","Macron 3",
                                                      ifelse(MACRON.exp > "64.99" & MACRON.exp <= "69.99","Macron 4",
                                                             ifelse(MACRON.exp > "69.99" & MACRON.exp <= "74.99","Macron 5",
                                                                    ifelse(MACRON.exp > "74.99","Macron 6","")))))))))%>%
  mutate(Vantaggio_LePen=ifelse(LE.PEN.exp < "50.00","",
                                ifelse(LE.PEN.exp == "50.00", "pari",
                                       ifelse(LE.PEN.exp > "50.00" & LE.PEN.exp <="54.99","Le Pen 1",
                                        ifelse(LE.PEN.exp > "54.99" & LE.PEN.exp <= "59.99","Le Pen 2",
                                               ifelse(LE.PEN.exp > "59.99" & LE.PEN.exp <= "64.99","Le Pen 3",
                                                      ifelse(LE.PEN.exp > "64.99" & LE.PEN.exp <= "69.99","Le Pen 4",
                                                             ifelse(LE.PEN.exp > "69.99" & LE.PEN.exp <= "74.99","Le Pen 5",
                                                                    ifelse(LE.PEN.exp > "74.99","Le Pen 6","")))))))))%>%
  unite(Risultato, c("Vantaggio_Macron", "Vantaggio_LePen"), sep = "")



write.csv(francia_ballottaggio_2022, "ballottaggio_Francia_22.csv",fileEncoding="UTF-8")