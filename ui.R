#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shinydashboard)
library(shinyWidgets)
source("global.R")

dashboardPage(
  dashboardHeader(title = "Twitch Analytics Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("home")),
      menuItem("Global", tabName = "global", icon = icon("twitch")),
      menuItem("Trending", tabName = "trending", icon = icon("gamepad")),
      menuItem("Popularity", tabName = "popularity", icon = icon("line-chart")),
      menuItem("Correlation", tabName = "correlation", icon = icon("area-chart")),
      menuItem("Dataset", tabName = "dataset", icon = icon("database"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "home",
              # Add your content for the Home page
              fluidRow(
                  tags$h1("Twitch Global & Top 200 Games Dashboard", style = "font-size: 24px; margin-bottom: 20px;margin-left: 20px;"),
                    tags$div(
                             infoBox("Total Hours Watched", value = formattedValue(sum(gl$Hours_watched)),icon = icon("play-circle"), color = "aqua"),
                             infoBox("Max Peak Viewers", value = formattedValue(max(gl$Peak_viewers)), icon = icon("users"), color = "green"),
                             infoBox("Average Games Streamed", value = formattedValue(round(mean(gl$Games_streamed))),icon = icon("gamepad"), color = "yellow")
                    ),
                    tags$div(
                        style = "font-size: 18px;margin-left: 20px;",  # Adjust the font size for the description here. 
                        tags$p("The dashboard data is drawn from 2 ",
                             a(href='https://www.kaggle.com/datasets/rankirsh/evolution-of-top-games-on-twitch/data?select=Twitch_game_data.csv', "datasets"), 
                             " in 2016 January – 2023 March:"), 
                        tags$p("- Twitch global data which there is one observation per month that contains the general statistics about viewership on twitch. The columns are:"),
                        tags$ul(
                          tags$li("Year - Year in question"),
                          tags$li("Month - Month in question"),
                          tags$li("Hours_watched - Total hours watched in the platform"),
                          tags$li("Avg_viewers  -  Avg viewers on the platform"),
                          tags$li("Peak_viewers - Peak viewers at one instant"),
                          tags$li("Streams - Number of streams on the platform"),
                          tags$li("Avg_channels - Average channels on one instant on the platform"),
                          tags$li("Games_streamed - Total unique games streamed"),
                          tags$li("Viewer_ratio - Viewer to channel ration (average)")
                        ),
                        tags$p("- Twitch top 200 game data in which we find 200 observations per month representing the top games or categories on twitch for that month. The columns are:"),
                        tags$ul(
                          tags$li("Rank - Rank in the month (1 - 200)"),
                          tags$li("Game - Name of game or category"),
                          tags$li("Month - Month in question"),
                          tags$li("Year - Year in question"),
                          tags$li("Hours_watched - Hours watched on twitch"),
                          tags$li("Hours_streamed - Hours streamed on twitch"),
                          tags$li("Peak_viewers - Maximum viewers at one instant"),
                          tags$li("Peak_channels - Maximum channels at one instant"),
                          tags$li("Streamers - Amount of streamers who streamed the game"),
                          tags$li("Avg_viewers - Average viewers"),
                          tags$li("Avg_channels - Average amount of channels"),
                          tags$li("Avg_viewer_ratio - Average amount of viewer per channel")
                        )
                    )
              )
      ),
      tabItem(tabName = "global",
              # Add your content for the Global page
              fluidRow(
                tags$h1("Twitch General Trend", style = "font-size: 24px; margin-bottom: 20px;margin-left: 20px;"),
                column(8,
                       wellPanel(
                         fluidRow(
                           column(6,
                                  selectInput("metric", "Choose a metric:",
                                              choices = c("Hours Watched" = "Hours_watched",
                                                          "Avg Viewers" = "Avg_viewers",
                                                          "Peak Viewers" = "Peak_viewers",
                                                          "Streams" = "Streams",
                                                          "Avg Channels" = "Avg_channels",
                                                          "Number of Games Streamed" = "Games_streamed",
                                                          "Viewers Ratio" = "Viewer_ratio"),
                                              selected = "Hours_watched"),
                                  airDatepickerInput(
                                    inputId = "date_range",
                                    label = "Select Date Range:",
                                    range = TRUE,
                                    view = "months",
                                    minView = "months",
                                    minDate = "2016-01-01",
                                    maxDate = "2023-03-31",
                                    value = c("2016-01-01", "2023-03-31")
                                  )
                           ),
                           column(6,
                                  h4("Metric Description"),
                                  
                                  conditionalPanel(
                                    condition = "input.metric === 'Hours_watched'",
                                    p("Total hours watched in the platform")
                                  ),
                                  
                                  conditionalPanel(
                                    condition = "input.metric === 'Avg_viewers'",
                                    p("Avg viewers on the platform")
                                  ),
                                  
                                  conditionalPanel(
                                    condition = "input.metric === 'Peak_viewers'",
                                    p("Peak viewers at one instant")
                                  ),
                                  
                                  conditionalPanel(
                                    condition = "input.metric === 'Streams'",
                                    p("Number of streams on the platform")
                                  ),
                                  
                                  conditionalPanel(
                                    condition = "input.metric === 'Avg_channels'",
                                    p("Average channels on one instant on the platform")
                                  ),
                                  
                                  conditionalPanel(
                                    condition = "input.metric === 'Games_streamed'",
                                    p("Total unique games streamed")
                                  ),
                                  
                                  conditionalPanel(
                                    condition = "input.metric1 === 'Viewer_ratio'",
                                    p("Viewer to channel ration (average)")
                                  ),
                                  
                                  actionButton("reset", "Reset")
                           )
                         )
                       )
                ),
                
                fluidRow(
                  column(12,
                         plotlyOutput("global_plot")
                  )
                )
              )
      ),
      tabItem(tabName = "trending",
              # Add your content for the Trending page
              fluidRow(
                tags$h1("Twitch Top 10 Games", style = "font-size: 24px; margin-bottom: 20px;margin-left: 20px;"),
                column(8,
                       wellPanel(
                         fluidRow(
                           column(6,
                                  selectInput("metric1", "Choose a metric:",
                                              choices = c("Hours Watched" = "Hours_watched",
                                                          "Hours streamed" = "Hours_streamed",
                                                          "Peak Viewers" = "Peak_viewers",
                                                          "Peak Channels" = "Peak_channels",
                                                          "Streamers" = "Streamers",
                                                          "Avg Viewers" = "Avg_viewers",
                                                          "Avg Channels" = "Avg_channels",
                                                          "Avg Viewers Ratio" = "Avg_viewer_ratio"),
                                              selected = "Hours_watched"),
                                  airDatepickerInput(
                                    inputId = "date_range1",
                                    label = "Select Date Range:",
                                    range = TRUE,
                                    view = "months",
                                    minView = "months",
                                    minDate = "2016-01-01",
                                    maxDate = "2023-03-31",
                                    value = c("2016-01-01", "2023-03-31")
                                  )
                           ), 
                           column(6,
                                  h4("Metric Description"),
                                  
                                  conditionalPanel(
                                    condition = "input.metric1 === 'Hours_watched'",
                                    p("Hours watched on Twitch")
                                  ),
                                  
                                  conditionalPanel(
                                    condition = "input.metric1 === 'Hours_streamed'",
                                    p("Hours streamed on Twitch")
                                  ),
                                  
                                  conditionalPanel(
                                    condition = "input.metric1 === 'Peak_viewers'",
                                    p("Maximum viewers at one instant")
                                  ),
                                  
                                  conditionalPanel(
                                    condition = "input.metric1 === 'Peak_channels'",
                                    p("Maximum channels at one instant")
                                  ),
                                  
                                  conditionalPanel(
                                    condition = "input.metric1 === 'Streamers'",
                                    p("Amount of streamers who streamed the game")
                                  ),
                                  
                                  conditionalPanel(
                                    condition = "input.metric1 === 'Avg_viewers'",
                                    p("Average viewers")
                                  ),
                                  
                                  conditionalPanel(
                                    condition = "input.metric1 === 'Avg_channels'",
                                    p("Average amount of channels")
                                  ),
                                  
                                  conditionalPanel(
                                    condition = "input.metric1 === 'Avg_viewer_ratio'",
                                    p("Average amount of viewer per channel")
                                  ),
                                  actionButton("reset1", "Reset")
                           )
                         )
                       )
                ), 
                fluidRow(
                  column(12,
                         plotlyOutput("top_games_plot")
                  )
                )
              )
                         
      ),
      tabItem(tabName = "popularity",
              fluidRow(
                tags$h1("Popularity Tracker", style = "font-size: 24px; margin-bottom: 20px;margin-left: 20px;"),
                column(10,
                       wellPanel(
                         fluidRow(
                           column(6,
                                  selectInput("metric2", "Choose a metric:",
                                              choices = c("Hours Watched" = "Hours_watched",
                                                          "Hours streamed" = "Hours_streamed",
                                                          "Peak Viewers" = "Peak_viewers",
                                                          "Peak Channels" = "Peak_channels",
                                                          "Streamers" = "Streamers",
                                                          "Avg Viewers" = "Avg_viewers",
                                                          "Avg Channels" = "Avg_channels",
                                                          "Avg Viewers Ratio" = "Avg_viewer_ratio"),
                                              selected = "Hours_watched"),
                                  airDatepickerInput(
                                    inputId = "date_range2",
                                    label = "Select Date Range:",
                                    range = TRUE,
                                    view = "months",
                                    minView = "months",
                                    minDate = "2016-01-01",
                                    maxDate = "2023-03-31",
                                    value = c("2016-01-01", "2023-03-31")
                                  )
                           ), 
                           column(6,
                                  selectizeInput("games", "Choose Games:", 
                                                 choices = unique(tw2$Game), 
                                                 multiple = TRUE ,
                                                 options = list(maxItems = 5)),
                                  h4("Metric Description"),
                                  
                                  conditionalPanel(
                                    condition = "input.metric2 === 'Hours_watched'",
                                    p("Hours watched on Twitch")
                                  ),
                                  
                                  conditionalPanel(
                                    condition = "input.metric2 === 'Hours_streamed'",
                                    p("Hours streamed on Twitch")
                                  ),
                                  
                                  conditionalPanel(
                                    condition = "input.metric2 === 'Peak_viewers'",
                                    p("Maximum viewers at one instant")
                                  ),
                                  
                                  conditionalPanel(
                                    condition = "input.metric2 === 'Peak_channels'",
                                    p("Maximum channels at one instant")
                                  ),
                                  
                                  conditionalPanel(
                                    condition = "input.metric2 === 'Streamers'",
                                    p("Amount of streamers who streamed the game")
                                  ),
                                  
                                  conditionalPanel(
                                    condition = "input.metric2 === 'Avg_viewers'",
                                    p("Average viewers")
                                  ),
                                  
                                  conditionalPanel(
                                    condition = "input.metric2 === 'Avg_channels'",
                                    p("Average amount of channels")
                                  ),
                                  
                                  conditionalPanel(
                                    condition = "input.metric2 === 'Avg_viewer_ratio'",
                                    p("Average amount of viewer per channel")
                                  ),
                                  actionButton("reset2", "Reset")
                           )
                         )
                       )
                ), fluidRow(
                  column(12,
                         plotlyOutput("popularity_plot")
                  )
                )
              )                                  
      ),
      tabItem(tabName = "correlation",
              # Add your content for the Correlation page
              fluidRow(
                tags$h1("Features Relationships", style = "font-size: 24px; margin-bottom: 20px;margin-left: 20px;"),
                column(12,
                       wellPanel(
                         fluidRow(
                           column(4,
                                  title = "Controls",
                                  selectInput("x_axis_choice", "Choose X Axis:", 
                                              choices = c("Hours Watched" = "Hours_watched",
                                                          "Hours streamed" = "Hours_streamed",
                                                          "Peak Viewers" = "Peak_viewers",
                                                          "Peak Channels" = "Peak_channels",
                                                          "Streamers" = "Streamers",
                                                          "Avg Viewers" = "Avg_viewers",
                                                          "Avg Channels" = "Avg_channels",
                                                          "Avg Viewers Ratio" = "Avg_viewer_ratio"),
                                              selected = "Hours_watched"),
                                  selectInput("y_axis_choice", "Choose Y Axis:", 
                                              choices = c("Hours Watched" = "Hours_watched",
                                                          "Hours streamed" = "Hours_streamed",
                                                          "Peak Viewers" = "Peak_viewers",
                                                          "Peak Channels" = "Peak_channels",
                                                          "Streamers" = "Streamers",
                                                          "Avg Viewers" = "Avg_viewers",
                                                          "Avg Channels" = "Avg_channels",
                                                          "Avg Viewers Ratio" = "Avg_viewer_ratio"),
                                              selected = "Hours_watched"),
                                  ), 
                           column(4,
                                  airDatepickerInput(
                                    inputId = "date_range3",
                                    label = "Select Date Range:",
                                    range = TRUE,
                                    view = "months",
                                    minView = "months",
                                    minDate = "2016-01-01",
                                    maxDate = "2023-03-31",
                                    value = c("2016-01-01", "2023-03-31")
                                  )
                                  ),
                           column(4,
                                  h4("X - Metric Description"),
                                  conditionalPanel(
                                    condition = "input.x_axis_choice === 'Hours_watched'",
                                    p("Hours watched on Twitch")
                                  ),
                                  
                                  conditionalPanel(
                                    condition = "input.x_axis_choice === 'Hours_streamed'",
                                    p("Hours streamed on Twitch")
                                  ),
                                  
                                  conditionalPanel(
                                    condition = "input.x_axis_choice === 'Peak_viewers'",
                                    p("Maximum viewers at one instant")
                                  ),
                                  
                                  conditionalPanel(
                                    condition = "input.x_axis_choice === 'Peak_channels'",
                                    p("Maximum channels at one instant")
                                  ),
                                  
                                  conditionalPanel(
                                    condition = "input.x_axis_choice === 'Streamers'",
                                    p("Amount of streamers who streamed the game")
                                  ),
                                  
                                  conditionalPanel(
                                    condition = "input.x_axis_choice === 'Avg_viewers'",
                                    p("Average viewers")
                                  ),
                                  
                                  conditionalPanel(
                                    condition = "input.x_axis_choice === 'Avg_channels'",
                                    p("Average amount of channels")
                                  ),
                                  
                                  conditionalPanel(
                                    condition = "input.x_axis_choice === 'Avg_viewer_ratio'",
                                    p("Average amount of viewer per channel")
                                  ),
                                  
                                  h4("Y - Metric Description"),
                                  conditionalPanel(
                                    condition = "input.y_axis_choice === 'Hours_watched'",
                                    p("Hours watched on Twitch")
                                  ),
                                  
                                  conditionalPanel(
                                    condition = "input.y_axis_choice === 'Hours_streamed'",
                                    p("Hours streamed on Twitch")
                                  ),
                                  
                                  conditionalPanel(
                                    condition = "input.y_axis_choice === 'Peak_viewers'",
                                    p("Maximum viewers at one instant")
                                  ),
                                  
                                  conditionalPanel(
                                    condition = "input.y_axis_choice === 'Peak_channels'",
                                    p("Maximum channels at one instant")
                                  ),
                                  
                                  conditionalPanel(
                                    condition = "input.y_axis_choice === 'Streamers'",
                                    p("Amount of streamers who streamed the game")
                                  ),
                                  
                                  conditionalPanel(
                                    condition = "input.y_axis_choice === 'Avg_viewers'",
                                    p("Average viewers")
                                  ),
                                  
                                  conditionalPanel(
                                    condition = "input.y_axis_choice === 'Avg_channels'",
                                    p("Average amount of channels")
                                  ),
                                  
                                  conditionalPanel(
                                    condition = "input.y_axis_choice === 'Avg_viewer_ratio'",
                                    p("Average amount of viewer per channel")
                                  ), 
                                  actionButton("reset3", "Reset")
                                  )
                )
                       ),
                fluidRow(
                  column(12,
                         plotlyOutput("correlation_plot")
                )
                       )
                )
              )
      ),
      tabItem(tabName = "dataset",
              fluidRow(
                tags$h1("Top 200 Datatable", style = "font-size: 24px; margin-bottom: 20px;margin-left: 20px;")), 
              DTOutput("datatable")
      )
    )
  )
)
