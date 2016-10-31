library(dplyr)

allzips <- readRDS("data/superzip.rds")
allzips$latitude <- jitter(allzips$latitude)
allzips$longitude <- jitter(allzips$longitude)
allzips$college <- allzips$college * 100
allzips$zipcode <- formatC(allzips$zipcode, width=5, format="d", flag="0")
row.names(allzips) <- allzips$zipcode

cleantable <- allzips %>%
  select(
    City = city.x,
    State = state.x,
    Zipcode = zipcode,
    Rank = rank,
    Score = centile,
    Superzip = superzip,
    Population = adultpop,
    College = college,
    Income = income,
    Lat = latitude,
    Long = longitude
  )

#polut$latitude <- jitter(polut$latitude)
#plout$longitude <- jitter(polut$longitude)


alldata <- read.csv('data/latest.csv', header=TRUE, sep=",") 
#no2$latitude <- jitter(no2$latitude)
#no2$longitude <- jitter(no2$longitude)

no2 <- subset(alldata, !is.na(no2))
no2 <- no2[c('latitude','longitude','no2')]

so2 <- subset(alldata, !is.na(so2))
so2 <- so2[c('latitude','longitude','so2')]

o3 <- subset(alldata, !is.na(o3))
o3 <- o3[c('latitude','longitude','o3')]

pm10 <- subset(alldata, !is.na(pm10))
pm10 <- pm10[c('latitude','longitude','pm10')]

pm25 <- subset(alldata, !is.na(pm25))
pm25 <- pm25[c('latitude','longitude','pm25')]

#poldata$college <- allzips$college * 100
#poldata$zipcode <- formatC(allzips$zipcode, width=5, format="d", flag="0")

 #poltable <- no2data %>%
 # select(
 #   long  = longitude,
 #   lat   = latitude,
 #   no_2  = no2,
 #   so_2  = so2,
 #   o_3   = o3,
 #   pm_10 = pm10,
 #   pm_25 = pm25
 # )

