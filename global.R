library(shiny)
library(shinydashboard)
library(DT)
library(dplyr) # transformasi data
library(ggplot2) # visualisasi
library(ggpubr)
library(scales) # untuk tampilan digit (memberikan koma dll)
library(glue)
library(plotly) 
library(lubridate) # working with datetime
library(zoo)
options(shiny.maxRequestSize=200*1024^2)

# Load your dataset here
tw <- read.csv("data_input/Twitch_game_data.csv")
gl <- read.csv("data_input/Twitch_global_data.csv") 

gl <- rename(gl, Year = year)

tw1 <- tw %>%
  mutate(Year_Month = paste(Year, sprintf("%02d", Month), sep="-"))

gl1 <- gl %>%
  mutate(Year_Month = paste(Year, sprintf("%02d", Month), sep="-"))

tw1$Year_Month <- as.yearmon(tw1$Year_Month, format="%Y-%m")
gl1$Year_Month <- as.yearmon(gl1$Year_Month, format="%Y-%m")

formattedValue <- function(value) {
  format(value, big.mark = ",", scientific = FALSE)
}
tw2 <- tw1
tw1$Game <- iconv(tw1$Game, from = "CP1252", to = "UTF-8")
tw1$Game <- iconv(tw1$Game, from = "latin1", to = "UTF-8")
tw2$Game <- gsub("–", "-", tw1$Game)
tw2 <- tw2[tw2$Game != "", ]
tw2$Game <- gsub("Pokémon", "Pokemon", tw2$Game)
tw2$Game <- gsub("Ragnarök", "Ragnarok", tw2$Game)