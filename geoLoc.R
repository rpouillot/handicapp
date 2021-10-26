# Geocoding a csv column of "addresses" in R

#load ggmap
library(ggmap)
myKey <- readLines(con=file("myKey.txt"))
register_google(key = myKey)

setwd("C:\\Users\\PouillotRegis\\OneDrive\\HandicApp")
data <- read_excel("tourisme-handicap-etablissements-05052020.xlsx")

adresses <- paste0(data$`NOM ETABLISSEMENT`,", ",
                   data$ADRESSE,", ",
                   data$CP, " ", data$COMMUNE,", ",
                   data$DEPARTEMENT, "FRANCE")
n <- length(adresses)

geocoded <- NULL
geocoded$adresses <- adresses
geocoded$lon <- rep(NA, n)
geocoded$lat <- rep(NA, n)
geocoded$googleAdress <- rep(NA, n)
geocoded <- as.data.frame(geocoded)

# Loop through the addresses to get the latitude and longitude of each address and add it to the
# origAddress data frame in new columns lat and lon
for(i in 1:n)
{
  # Print("Working...")
  print(i)
  print(adresses[i])
  result <- try(geocode(adresses[i], output = "latlona", source = "google"))
  print(result)
  if(!inherits(result,"try-error")){
    geocoded$lon[i] <- as.numeric(result[1])
    geocoded$lat[i] <- as.numeric(result[2])
    geocoded$googleAdress[i] <- as.character(result[3])
  }
  
}

# Write a CSV file containing origAddress to the working directory
write.csv(geocoded, "geocoded.csv", row.names=FALSE)
