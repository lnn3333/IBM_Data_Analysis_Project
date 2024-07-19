# Bike Sharing Predictor
## Table content
1. Ojective
2. Tech Stack
3. About the data source
4. Project Details
5. Credits

## 1. Ojective
- Use attribute information of weather data to build predictive models(linear regression, multi-linear regression, model with polynomial terms, regulation terms) to predict the number of bike sharing depend on location

## 2. Tech Stack
- Import and clean data: R
- Maninpulating and Analysis Data: SQL
- Build interactive app: Shinny

## 3. About the Data Source
### Source
**i. Weather Data**
- Open Weather API Data
    - Use HTTP request 
    - Data provide forecast for every 3 hours over the next 5 days

**ii. Bike sharing Data**
- Global Bike Sharing Systems Dataset
- Seoul Bike Sharing Demand Data Set
- World Cities Data

### Variable
**Predictor variables:**
- Date: year-month-day
- Rented Bike count: Count of bikes rented each hour
- Hour: Hour of the day
- Temperature: Temperature in Celsius
- Humidity: Percentage
- Windspeed: m/s
- Visibility: 10m
- Dew point temperature: Celsius
- Solar radiation: MJ/m2
- Rainfall: mm
- Snowfall: cm
- Seasons: Winter, Spring, Summer, Autumn
- Holiday: Holiday/No holiday
- Functional Day: NoFunc (Non Functional Hours), Fun (Functional hours)

**Target variable:** Number of bike sharing

## 4. Project Details
1. Collecting and Understanding Data
- Gather data from multiple sources.
- Understand the nature and structure of the data.

2. Data Wrangling and Preparation
- Clean and prepare the data using regular expressions and Tidyverse.

3. Exploratory Data Analysis
- Perform exploratory data analysis with SQL.
- Visualize the data using Tidyverse and ggplot2.

4. Modeling the Data
- Perform linear regressions using Tidymodels.

5. Building an Interactive Dashboard
- Create an interactive dashboard using R Shiny.


## 5. Credits
- This is part of IBM R Capstone Project course
- Relevant Paper and Citation Request:
    - Sathishkumar V E, Jangwoo Park, and Yongyun Cho. Using data mining techniques for bike sharing demand prediction in metropolitan city. Computer Communications, Vol.153, pp.353-366, March, 2020
    - Sathishkumar V E and Yongyun Cho. A rule-based model for Seoul Bike sharing demand prediction using weather data. European Journal of Remote Sensing, pp. 1-18, Feb, 2020

