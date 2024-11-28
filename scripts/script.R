# Creating interactive visualisations: DT, plotly and leaflet
## Created by Emma House 
### 21/11/2024

# Purpose of the script 
# Your name, date and email 

# Set your working directory, this will be different for you depending on your filepath to the downloaded repository 
setwd("~/Downloads/tutorial-emmmahouse")

# Install packages 
install.packages("tidyverse")    # Helps us clean the data
install.packages("DT")           # Renders the interactive tables in reports 
install.packages("ggplot2")      # Helps us create the beautiful graphs
install.packages("dplyr")        # Provides a range of functions to help manipulate data
install.packages("plotly")       # Creates the interactive graphs, even 3D plots or geographic maps
install.packages("htmlwidgets")  # Allows us to create HTML based interactive infographics
install.packages ("leaflet")     # Creates interactive maps 


# Download libraries 
library(tidyverse)
library(DT)
library(ggplot2)
library(dplyr)
library(plotly)
library(htmlwidgets)
library(leaflet)

# Load the puffin data 
atlantic_puffin <- read.csv("data/atlantic_puffin.csv")



# Data overview
str (atlantic_puffin)
summary (atlantic_puffin)

# Data wrangling  
# Okay, this may look scary but when you break it all down I promise it isn't so bad!


puffin_data <- atlantic_puffin %>% 
  pivot_longer (cols=25:69, names_to = "Year", values_to = "Population") %>%         # Transforms the data from wide to long format 
  mutate (Year = parse_number(Year),                                                 # Converts the values in year to numeric                    
          Year.Scale = Year - min(Year),                                             # Scaling the year 
          Population = round(Population)) %>%                                        # Rounding the population values
  filter(is.finite(Population), !is.na(Population)) %>%                              # Removing any NA values from the data
  select (Common.Name, Region, Country.list, id, Year, Population, Year.Scale) %>%   # Selecting what columns we need in the final dataset
  rename_with(tolower)                                                               # Renaming the columns so they are lowercase: improving coding etiquette 


# Creating a simple interactive data table 
datatable(puffin_data,                        # This is the data set we will be using in the table
          options = list(                     # We want the table in a list format of data
            pageLength = 10,                  # Each page has 10 rows of values
            searching = TRUE,                 # We can add a search bar
            lengthChange = FALSE))            # We cannot change the number of rows displayed per page
 
saveWidget(datatable(puffin_data), "interactive_table.html")   # Saving the interactive table to a HTML file 

## Nice work! We now have a simple table, interactive with a search bar and 10 rows per page - pretty cool !!
## But I want to make this look even more attractive and change the names of the columns, what more can I do...

improved_table <- datatable(puffin_data,                                                      # The dataset for the table 
          filter = "top",                                                   # Adds a search bar at the top of each column 
            options = list(                                                 # We want the table in a list format of data
              pageLength = 10,                                              # Each page has 10 rows of values
              searching = TRUE,                                             # Still have that search bar at the top 
              lengthChange = FALSE)) %>%                                    # We cannot change the number of rows displayed per page
  formatStyle ('population',                                                # Formatting the population column
               backgroundColor = styleInterval(10, c('red', 'white')))      # Adding colour red to any population values below 10

saveWidget(improved_table, "improved_interactive_table.html")               # Saving the improved interactive table to a HTML file

# Creating a basic interactive scatter plot 
plot <- plot_ly(data = puffin_data,                   # Using the puffin data
        x = ~year,                            # Year on the x axis
        y = ~population,                      # Population size on the y axis
        color = ~country.list,                # Each country has a new colour 
        type = 'scatter',                     # Type of graph is scatter plot 
        mode = 'markers')                     # Each data point will be marked

saveWidget(plot, "interactive_scatter.html") 

# This looks a little ... odd. That one point in Norway, 1979, is skewing the data so we can't see the patterns as clearly.
# Let's try and log the populations to help observe more patterns in the data.
# Whilst we are at it, we can make some further adjustments ... 

improved_plot <- plot_ly(data = puffin_data,                                                                                     # Using the puffin data
        x = ~year,                                                                                              # Year on the x axis
        y = ~log(population),                                                                                   # The logged population size on the y axis
        color = ~country.list,                                                                                  # Each country has a new colour 
        text = ~paste("Country:", country.list, "<br>Population:", population),                                 # The text shown when mouse hovers over data point 
        type = 'scatter',                                                                                       # Type of graph is scatter plot 
        mode = 'markers') %>%                                                                                   # Each data point will be marked
  layout(title = "Atlantic Puffin population over the years in different countries",                            # Title of the graph  
         xaxis = list(title = "Years",                                                                          # X axis title 
                     showgrid = FALSE,                                                                          # Removing the x axis gridlines
                     zeroline = TRUE,                                                                           # Keeping the x axis line 
                     linecolor = 'black'),                                                                      # Ensuring x axis line is black 
        yaxis = list(title = "Population (Log Scale)",                                                          # y axis title  
                     type = "log",                                                                              # Logging the y axis 
                     showgrid = FALSE,                                                                          # Removing the y axis gridlines
                     zeroline = TRUE,                                                                           # Keeping the y axis line             
                     linecolor = 'black',                                                                       # Ensuring y axis line is black 
                     tickmode = "linear",                                                                       # Ticks on the y axis will be uniformly spread out
                     dtick = 1))                                                                                # The difference between each tick will be log1

saveWidget(improved_plot, "improved_interactive_scatter.html") 
  
  
# If we want to take it one step further and make this graph more accessible for those of younger ages ... we can make it ANIMATED 
# We only need to add a few extra lines, as displayed: 

animated_plot <- puffin_data %>%                                                        
  plot_ly(                                                                              # Using plot_ly function for the animation 
    x =~year,                                                                     
    y =~log(population),                                                                                                                                
    color =~country.list,
    frame =~year,                                                                       # Creating the animation by specifying each frame corresponds to a different year                                                          
    text =~country.list,                                                                # When mouse hovers over data point, it will show the country
    hoverinfo = "text",                                                                 # Only the country name will be shown when hoving over point
    type = 'scatter',
    mode = 'markers') %>% 
  layout (title = "Atlantic Puffin population over the years in different countries",
          xaxis = list (title = "Years",
                        showgrid = FALSE,
                        zeroline = TRUE,
                        linecolor = 'black'),
          yaxis = list(title = "Population (Log Scale)", 
                       type = "log", 
                       showgrid = FALSE,
                       zeroline = TRUE,
                       linecolor = 'black'))

animated_plot

saveWidget(animated_plot, "puffin_animated_plot.html") 


#Creating the interactive map 

#create coordinates in new dataframe 
country_coords <- data.frame(                                                                       # Creating a new dataframe with coordinates for the countries
  country = c("Russian Federation", "Canada", "France", "Ireland", "United Kingdom", "Norway"),     # Combine the countries in the puffin_data set 
  lat = c(55.7558, 56.1304, 46.6034, 53.1424, 51.5074, 60.4720),                                    # Combine the latitude coordinates for each country 
  long = c(37.6176, -106.3468, 1.8883, -7.6921, -0.1278, 8.4689))                                   # Combine the longitude coordinates for each country 


# Merging coordinate data with the puffin data for a specific year eg 1970

map_data <- puffin_data %>%                                       # Making a new data set called map_data which will be the puffin_data and country_coords combined               
  filter(year == 1970) %>%                                        # Filter the puffin_data to only use one year of data in the map 
  left_join(country_coords, by = c("country.list" = "country"))   # Joining the puffin_data and country_coords data into one datase, through matching the country columns 

# Simple plain map 
leaflet() %>% 
  addTiles()

# What are the different addTiles?
names(providers)[1:5]

# Playing around with the different maps you can use
leaflet() %>% 
  addProviderTiles(provider = "OpenStreetMap.France")

# Adding a map with a specific view eg Taj Mahal
leaflet() %>%  
  addTiles () %>% 
  setView(lat = 27.1751, lng = 78.0421, zoom = 16)

# Simple map of markers on the countries we have data for
leaflet(map_data) %>% 
  addTiles() %>% 
  setView (lng = 0, lat = 20, zoom = 2) %>%
  addAwesomeMarkers (
    lng = ~long,
    lat = ~lat)

# A very cool map just made, but we can do more by adding different markers, with size based on the population of the puffins respecitvely
# Can also make it more interactive with hover effects! 

# Best and most improved edited map 
leaflet(map_data) %>%                                                    # Using the leaflet package, using the new dataset we made          
  addTiles() %>%                                                         # Adding default basemap tiles, the map background: weaves multiple map images together 
  setView(lng = 0, lat = 20, zoom = 2) %>%                               # Setting the initial view of the map, centering it near the equator and prime meridian, with a wide zoom
  addCircleMarkers(                                                      # Circle markers represent the data points 
    lng = ~long,                                                         # We add these markers based on the latitude and longitude of the countries
    lat = ~lat,
    radius = ~sqrt(population / 1),                                      # This scales the circles based on the population size of the puffins in each country (square root makes it more proportional)
    color = "blue",                                                      # Circles are blue 
    stroke = FALSE,                                                      # Outline of the circles removed
    fillOpacity = 0.5,                                                   # Sets transparency of the circle to 50%
    popup = ~paste("", country.list,                                     # Describes what will be seen when the circle data point is clicked
                   "<br>population: ",                                   # The country name and population will appear 
                   format(population, big.mark = ","))) %>%              # A comma will be used for values larger than 1,000
  addLegend("bottomright",                                               # Adds a legend to the map in the bottom right
    pal = colorNumeric("Blues", NULL),                                   # Creates a colour palette using the blue originally stated
    values = ~population,                                                # Population values generate the blue colour
    title = "Population size",                                           # Title of the legend is population size
    labFormat = labelFormat(big.mark = ","),                             # Formats the numbers in the legend so those more than 1,000 have commas where necessary
    opacity = 1)                                                         # Sets the opacity of the legend to 100




