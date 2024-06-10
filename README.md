# Twitch_Shiny_Dashboard

## Table of Contents
- [Description](#description)
- [File Structure](#file-structure)
- [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Local Installation](#local-installation)
- [Results](#results)
- [Acknowledgements](#acknowledgements)

## Description
This Twitch Dashboard is an interactive Shiny application designed to visualize and analyze Twitch global and top 200 games viewership [data](https://www.kaggle.com/datasets/rankirsh/evolution-of-top-games-on-twitch/data?select=Twitch_game_data.csv) monthly from January 2016 - March 2023. This [dashboard](https://audichandra.shinyapps.io/Twitch_Dashboard/) helps users explore Twitch's game streaming landscape from streamers' and viewers' sides, enabling streamers and marketers to make informed decisions to optimize their channels.

## File Structure
```php
Twitch_Shiny_Dashboard/
│
├── global.R          # Global variables and library imports
├── server.R          # Server logic of the Shiny application
├── ui.R              # User interface of the Shiny application
├── data_input/       # Folder containing data files used in the dashboard
├── Twitch.Rproj      # R project file for RStudio
└── README.md         # Documentation for using and navigating the dashboard
```

## Getting Started

### Prerequisites
- R (version 4.0.0 or higher)
- RStudio 
- Shiny package in R


### Local Installation

To set up and run the dashboard locally:

1. Clone this repository to your local machine:
   
```bash
git clone https://github.com/audichandra/Twitch_Shiny_Dashboard.git
```
2. Open **Twitch.Rproj** in RStudio
3. Install required R packages if not already installed:
   
```bash
# Install packages for the Twitch Dashboard
install.packages("shiny")           # For creating interactive web apps
install.packages("shinydashboard")  # Dashboarding framework for Shiny
install.packages("DT")              # For displaying tables interactively
install.packages("dplyr")           # Data manipulation
install.packages("ggplot2")         # Data visualization
install.packages("ggpubr")          # 'ggplot2' based publication ready plots
install.packages("scales")          # Graphical scales mapping data to aesthetics
install.packages("glue")            # Interpreted string literals
install.packages("plotly")          # Interactive plots
install.packages("lubridate")       # Date and time manipulation
install.packages("zoo")             # S3 Infrastructure for Regular and Irregular Time Series
install.packages("shinyWidgets")    # Extra widgets for Shiny
install.packages("tidyr")           # Tidy data manipulation
install.packages("tidyverse")       # Easily install and load the 'tidyverse' packages
install.packages("stringr")         # String manipulation
install.packages("tm")              # Text mining
install.packages("htmlwidgets")     # HTML widgets for R
install.packages("reshape2")        # Reshape data
install.packages("hexbin")          # Hexagonal binning plots
```
4. Run the application from RStudio by opening either **ui.R** or **server.R** and clicking 'Run App'.

## Results

![Games Popularity Tracker]((https://github.com/audichandra/Twitch_Shiny_Dashboard/blob/main/img/twitchshiny.png)

you can also access the [dashboard](https://audichandra.shinyapps.io/Twitch_Dashboard/) directly and you can get some results such as: 
- Global games metric trends such as viewership and streaming
- Top 10 trending game visualizations
- Games popularity tracker metric as shown above
- Correlation between features  

## Acknowledgements
- **Authors**: Audi Chandra.
- **License**: [MIT License](https://github.com/audichandra/Twitch_Shiny_Dashboard/blob/main/LICENSE.txt).
- **Kaggle Dataset**: We appreciate the dataset compilers for their contribution. Access the original dataset [here](https://www.kaggle.com/datasets/rankirsh/evolution-of-top-games-on-twitch/data?select=Twitch_game_data.csv).

