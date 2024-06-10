#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyWidgets)
library(shinydashboard)
library(DT)
library(dplyr) # transformasi data
library(ggplot2) # visualisasi
library(ggpubr)
library(scales) # untuk tampilan digit (memberikan koma dll)
library(glue)
library(plotly) 
library(lubridate) # working with datetime
library(tidyr)
library(tidyverse)
library(stringr)
library(tm)
library(htmlwidgets)
library(reshape2)
library(hexbin)
library(zoo)

# Define server logic required to draw a histogram
function(input, output, session) {
  
  # For the dataset tab
  output$datatable <- renderDT({
    datatable(tw) # or gl based on your preference or user choice
  })
  
  # Observe the reset button click and reset inputs to default values
  observeEvent(input$reset, {
    updateSelectInput(session, "metric", selected = "Hours_watched")
    updateAirDateInput(session, "date_range", 
                              value = c("2016-01-01", "2023-03-31"))
  })
  
  # Other render functions for your plots and tables will go here
  output$global_plot <- renderPlotly({
    req(input$metric, input$date_range)
    
    # Parse the date_range values to get the start and end year/month
    if(length(input$date_range) == 1) {
      # Only one date is selected
      start_date <- as.Date(input$date_range[1])
      end_date <- start_date
    } else {
      # Both start and end dates are selected
      start_date <- as.Date(input$date_range[1])
      end_date <- as.Date(input$date_range[2])
    }
    
    
    start_year <- as.numeric(format(start_date, "%Y"))
    start_month <- as.numeric(format(start_date, "%m"))
    end_year <- as.numeric(format(end_date, "%Y"))
    end_month <- as.numeric(format(end_date, "%m"))
    
    # Check if the metric exists in the dataset
    if(!(input$metric %in% names(gl1))) {
      return(NULL) # Exit if not found
    }
    
    # Filter the dataset using parsed values
    filtered_data <- gl1 %>%
      filter((Year > start_year | (Year == start_year & Month >= start_month)) &
               (Year < end_year | (Year == end_year & Month <= end_month)))
    # If 'x_axis' is not in the dataset, we need to create it:
    # I'm assuming the 'Year' and 'Month' are columns in your dataset and represent the date
    filtered_data$x_axis <- as.Date(paste0(filtered_data$Year, "-", sprintf("%02d", filtered_data$Month), "-01"))
    
    p <- filtered_data %>%
      plot_ly(x = ~x_axis, y = ~get(input$metric), type = 'scatter', mode = 'lines+markers', 
              line = list(color = '#1f77b4', width = 2.5), 
              marker = list(size = 6, color = '#1f77b4')) %>%
      layout(title = glue("Twitch General Metric by {input$metric} from {start_year}-{start_month} until {end_year}-{end_month}"),
             plot_bgcolor = "#f4f4f4", # light gray background
             xaxis = list(title = "Time",
                          gridcolor = "white", 
                          gridwidth = 2,
                          zerolinewidth = 2,
                          zerolinecolor = "lightgray"),
             yaxis = list(title = "Value", 
                          tickformat = ",",
                          gridcolor = "white",
                          gridwidth = 2,
                          zerolinewidth = 2,
                          zerolinecolor = "lightgray"),
             template = "plotly_white") # use the plotly_white template for a modern look
    
    return(p) 
  })
  
  # Observe the reset button click and reset inputs to default values
  observeEvent(input$reset1, {
    updateSelectInput(session, "metric1", selected = "Hours_watched")
    updateAirDateInput(session, "date_range1", 
                              value = c("2016-01-01", "2023-03-31"))
  })
  
  # Top Games plot rendering
  output$top_games_plot <- renderPlotly({
    req(input$metric1, input$date_range1)
    
    # Parse the date_range values to get the start and end year/month
    if(length(input$date_range1) == 1) {
      # Only one date is selected
      start_date1 <- as.Date(input$date_range1[1])
      end_date1 <- start_date1
    } else {
      # Both start and end dates are selected
      start_date1 <- as.Date(input$date_range1[1])
      end_date1 <- as.Date(input$date_range1[2])
    }
    
    
    start_year1 <- as.numeric(format(start_date1, "%Y"))
    start_month1 <- as.numeric(format(start_date1, "%m"))
    end_year1 <- as.numeric(format(end_date1, "%Y"))
    end_month1 <- as.numeric(format(end_date1, "%m"))
    
    # Ensure the metric is a column in the dataframe
    if (!(input$metric1 %in% names(tw1))) {
      stop(paste("Metric", input$metric1, "not found in the dataset"))
    }
    
    # Filter based on selected year range and month
    data_games <- tw1 %>% 
      filter((Year > start_year1 | (Year == start_year1 & Month >= start_month1)) &
               (Year < end_year1 | (Year == end_year1 & Month <= end_month1))) %>%
      group_by(Game) %>% 
      summarise(SumMetric = sum(!!sym(input$metric1), na.rm = TRUE)) %>%  # add na.rm = TRUE to handle potential NA values
      ungroup() %>%
      arrange(-SumMetric) %>%  # Sort in descending order 
      head(10) 
    
    # Order 'Game' by 'SumMetric'
    data_games$Game <- factor(data_games$Game, levels = rev(data_games$Game))
    
    # Bar plot
    p1 <- data_games %>%
      plot_ly(y = ~Game, x = ~SumMetric, type = 'bar', marker = list(color = 'rgb(0, 102, 204)')) %>%
      layout(title = glue("Top 10 Games by {input$metric1} from {start_year1}-{start_month1} until {end_year1}-{end_month1}"),
             xaxis = list(title = input$metric1, tickformat = ","),
             yaxis = list(title = "Game"), 
             plot_bgcolor = 'rgba(240,240,240,1)', # Adjust background color
             margin = list(l = 100)) # Adjust left margin for game names)
    
    return(p1) 
  })
  
  # Add reset functionality
  observeEvent(input$reset2, {
    updateSelectizeInput(session, "games", selected = character(0))
    updateSelectInput(session, "metric2", selected = "Hours_watched")
    updateAirDateInput(session, "date_range2", 
                              value = c("2016-01-01", "2023-03-31"))
  })
  
  # Render the time series line plot
  output$popularity_plot <- renderPlotly({
    req(input$metric2, input$date_range2)
    
    # Parse the date_range values to get the start and end year/month
    if(length(input$date_range2) == 1) {
      # Only one date is selected
      start_date2 <- as.Date(input$date_range2[1])
      end_date2 <- start_date2
    } else {
      # Both start and end dates are selected
      start_date2 <- as.Date(input$date_range2[1])
      end_date2 <- as.Date(input$date_range2[2])
    }
    
    
    start_year2 <- as.numeric(format(start_date2, "%Y"))
    start_month2 <- as.numeric(format(start_date2, "%m"))
    end_year2 <- as.numeric(format(end_date2, "%Y"))
    end_month2 <- as.numeric(format(end_date2, "%m"))
    
    # Check if any games are selected
    if(length(input$games) == 0) {
      return(plot_ly() %>%
               layout(title = "Please select a game to view its popularity trend."))
    }
    
    # Filter the dataset for the selected games
    selected_data <- tw2[tw2$Game %in% input$games, ]
    
    # Convert the Year and Month to Date format
    selected_data$Date <- as.Date(paste(selected_data$Year, selected_data$Month, "01", sep = "-"))
    
    # Subset the data based on the selected time range
    start_date <- as.Date(paste(start_year2, start_month2, "01", sep = "-"))
    end_date <- as.Date(paste(end_year2, end_month2, "01", sep = "-"))
    subset_data <- subset(selected_data, Date >= start_date & Date <= end_date)
    
    # Define a distinct color palette
    color_palette <- colorRampPalette(RColorBrewer::brewer.pal(8, "Set1"))(length(unique(subset_data$Game)))
    
    # Create the initial plotly object
    p2 <- plot_ly(data = subset_data, x = ~Date, y = ~get(input$metric2), color = ~Game, colors = color_palette, type = 'scatter', mode = 'lines+markers') %>%
      add_markers(size = 6, opacity = 0.7, showlegend = FALSE) %>%
      add_lines(line = list(width = 2), showlegend = FALSE) %>%
      layout(
        title = glue("Game Popularity by {input$metric2} from {start_year2}-{start_month2} until {end_year2}-{end_month2}"),
        xaxis = list(title = "Date"),
        yaxis = list(title = input$metric2)
      )
    
    return(p2)
  })
  
  # Add reset functionality
  observeEvent(input$reset3, {
    updateSelectInput(session, "x_axis_choice", selected = "Hours_watched")
    updateSelectInput(session, "y_axis_choice", selected = "Hours_watched")
    updateAirDateInput(session, "date_range3", 
                              value = c("2016-01-01", "2023-03-31"))
  })
  
  output$correlation_plot <- renderPlotly({
    req(input$date_range3)
    
    # Parse the date_range values to get the start and end year/month
    if(length(input$date_range3) == 1) {
      # Only one date is selected
      start_date3 <- as.Date(input$date_range3[1])
      end_date3 <- start_date3
    } else {
      # Both start and end dates are selected
      start_date3 <- as.Date(input$date_range3[1])
      end_date3 <- as.Date(input$date_range3[2])
    }
    
    start_year3 <- as.numeric(format(start_date3, "%Y"))
    start_month3 <- as.numeric(format(start_date3, "%m"))
    end_year3 <- as.numeric(format(end_date3, "%Y"))
    end_month3 <- as.numeric(format(end_date3, "%m"))
    
    # Filter the dataset based on selected years and months
    filtered_data <- tw %>%
      filter(Year >= start_year3, Year <= end_year3) %>%
      filter(!(Year == start_year3 & Month < start_month3)) %>%
      filter(!(Year == end_year3 & Month > end_month3))
    
    # Create scatter plot with plot_ly
    p <- plot_ly(data = filtered_data, 
                 x = ~filtered_data[[input$x_axis_choice]], 
                 y = ~filtered_data[[input$y_axis_choice]], 
                 type = "scatter", 
                 mode = "markers", 
                 marker = list(size = 5, opacity = 0.5)) %>% # Adjust point size and opacity
      layout(
        title = glue("Scatter plot from from {start_year3}-{start_month3} until {end_year3}-{end_month3}"), 
        xaxis = list(
          title = input$x_axis_choice, 
          type = "log" # Set x-axis to log scale
        ), 
        yaxis = list(
          title = input$y_axis_choice, 
          type = "log" # Set y-axis to log scale
        ),
        backgroundcolor = "white", # Set background color
        gridcolor = "lightgray" # Set grid color
      )
    
    p
  })
}
