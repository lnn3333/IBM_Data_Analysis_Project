# Install and import required libraries
require(shiny)
require(ggplot2)
require(leaflet)
require(tidyverse)
require(httr)
require(scales)
# Import model_prediction R which contains methods to call OpenWeather API
# and make predictions
source("model_prediction.R")


test_weather_data_generation<-function(){
  city_weather_bike_df<-generate_city_weather_bike_data()
  stopifnot(length(city_weather_bike_df)>0)
  print(city_weather_bike_df)
  return(city_weather_bike_df)
}

# Create a RShiny server

    # Render the leaflet map
shinyServer(function(input, output, session) {
  
  # Generate sample city weather and bike data
  city_weather_bike_df <- test_weather_data_generation()
  cities_max_bike <- generate_city_weather_bike_data()

  # Observe the dropdown selection
  observeEvent(input$city_dropdown,{
    # Filter the data based on the dropdown selection
    filtered_data <- if (input$city_dropdown == "All") {
      data <- city_weather_bike_df
    } else {
      data <- cities_max_bike %>% filter(CITY_ASCII == input$city_dropdown)
    }
    
    # Render the leaflet map
    output$city_bike_map <- renderLeaflet({
      if(input$city_dropdown == "ALL"){
        leaflet(data = filtered_data) %>% addTiles()%>%
          addCircleMarkers(
          lng = ~LNG,
          lat = ~LAT,
          radius = ~ifelse(BIKE_PREDICTION_LEVEL == 'small', 6, ifelse(BIKE_PREDICTION_LEVEL == 'medium', 10, 12)),
          color = ~ifelse(BIKE_PREDICTION_LEVEL == 'small', "green", ifelse(BIKE_PREDICTION_LEVEL == 'medium', "yellow", "red")),
          popup = ~LABEL
        )
      }
      else{
        leaflet(data = filtered_data) %>% addTiles()%>%
          addCircleMarkers(
          lng = ~LNG,
          lat = ~LAT,
          radius = ~ifelse(BIKE_PREDICTION_LEVEL == 'small', 6, ifelse(BIKE_PREDICTION_LEVEL == 'medium', 10, 12)),
          color = ~ifelse(BIKE_PREDICTION_LEVEL == 'small', "green", ifelse(BIKE_PREDICTION_LEVEL == 'medium', "yellow", "red")),
          popup = ~DETAILED_LABEL
        )
      }
        
    })
  })
  observeEvent(input$city_dropdown,{
    # Filter the data based on the dropdown selection
    current_time <- Sys.time()
    start_time <- current_time + as.difftime(3, units = "hours")
    
    filtered_data <- if (input$city_dropdown == "All") {
      data <- city_weather_bike_df %>% filter(FORECASTDATETIME > current_time && FORECASTDATETIME < start_time)
    } else {
      data <- city_weather_bike_df %>% 
        filter(CITY_ASCII == input$city_dropdown) %>%
        filter(FORECASTDATETIME > current_time && FORECASTDATETIME < start_time)
    }
    
    #Convert FORECASTDATETIME to POSIXct type
    filtered_data$FORECASTDATETIME <- as.POSIXct(filtered_data$FORECASTDATETIME)
    
    output$temp_line <- renderPlot({
      ggplot(filtered_data, aes(x = FORECASTDATETIME, y = TEMPERATURE)) +
        geom_line(color = "yellow") +
        geom_point() +
        geom_text(aes(label = round(TEMPERATURE, 1)), vjust = -0.5) +
        labs(title = "Temperature Trend", x = "Time 3 hour ahead", y = "Temperature (Celsius)")
    })
    
    output$bike_date_output <- renderText({
      click <- input$plot_click
      if (is.null(click)) {
        "Click on the plot to see the date and value here."
      } else {
        # Find the nearest point
        x<- click$x
        nearest_index = which.min((as.numeric(filtered_data$FORECASTDATETIME)-x))
        x <- filtered_data$FORECASTDATETIME[nearest_index]
        
        x <- format(x, "%Y-%m-%d")
        y <- round(sum(click$y, 2))
        paste("Datetime:", x, "\nBikeCount:", y)
      }
    })
    
    output$bike_line <- renderPlot({
      ggplot(filtered_data, aes(x = FORECASTDATETIME, y = BIKE_PREDICTION)) +
          geom_line()+
          geom_point()+
          geom_text(aes(label = BIKE_PREDICTION), vjust = -0.5)+
          labs(x = "Time 3 hours ahead", y = "Prediction Bike")
      })
    
    output$humidity_pred_chart <- renderPlot({
      ggplot(filtered_data,aes(x = HUMIDITY, y = BIKE_PREDICTION))+
          geom_point()+
          geom_smooth(method = "lm", formula = y ~ poly(x,4))
          
    })
  })
  
  
  
})


