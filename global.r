
 if(Sys.info()[1] == "Windows") {
   setwd("C:\\Users\\PouillotRegis\\OneDrive\\HandicApp\\handicapp")
   #setwd("C:\\Users\\Widjeuss\\Documents\\R\\Handicap")
   library(readxl)
   data <- readxl::read_excel("dataH2020.xlsx")
   dataH <- subset(data,!is.na(lat)) 
   saveRDS(dataH,"data/dataH2020")
 } 

rm(list=ls())
dataH <- readRDS("data/dataH2020")

dataH$ACTIVITE[is.na(dataH$ACTIVITE)] <- "Non Précisé / Autre"
Activite <- levels(factor(dataH$ACTIVITE))

library(shiny)
library(leaflet)
library(RColorBrewer)
library(shinythemes)
library(DT)

dataH$Courriel <- paste0("<a href=mailto:",dataH$EMAILCONTACT,">",dataH$EMAILCONTACT,"</a>")
dataH$Site <- paste0("<a href=http://",dataH$SITEWEB,">",dataH$SITEWEB,"</a>")
