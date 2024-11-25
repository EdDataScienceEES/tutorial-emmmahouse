# Creating interactive visualisations: DT, flextable, plotly and gganimate
## Created by Emma House 
### 21/11/2024

# Set your working directory, this will be different for you depending on your filepath to the downloaded repository 
setwd("~/Downloads/tutorial-emmmahouse")

# Install packages 
install.packages("tidyverse")    # Helps us clean the data
install.packages("DT")           # Renders the interactive tables in reports 
install.packages("flextable")    # Helps us make attractive and formatted tables for output in word, powerpoint or HTML 
install.packages("ggplot2")      # Helps us create the beautiful graphs
install.packages("dplyr")        # Provides a range of functions to help manipulate data
install.packages("plotly")       # Creates the interactive graphs, even 3D plots or geographic maps
install.packages("gganimate")    # Adds animations to static plots, especially used with time series data
install.packages("htmlwidgets")  


# Download libraries 
library(tidyverse)
library(DT)
library(flextable)
library(ggplot2)
library(dplyr)
library(plotly)
library(gganimate)
library(htmlwidgets)

# Load the puffin data 
atlantic_puffin <- read.csv("data/atlantic_puffin.csv")

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

datatable(puffin_data,                                                      # The dataset for the table 
          filter = "top",                                                   # Adds a search bar at the top of each column 
            options = list(                                                 # We want the table in a list format of data
              pageLength = 10,                                              # Each page has 10 rows of values
              searching = TRUE,                                             # Still have that search bar at the top 
              lengthChange = FALSE)) %>%                                    # We cannot change the number of rows displayed per page
  formatStyle ('population',                                                # Formatting the population column
               backgroundColor = styleInterval(10, c('red', 'white')))      # Adding colour red to any population values below 10

saveWidget(datatable(puffin_data), "improved_interactive_table.html") # Saving the improved interactive table to a HTML file

# Creating a basic interactive scatter plot 
plot_ly(data = puffin_data,                   # Using the puffin data
        x = ~year,                            # Year on the x axis
        y = ~population,                      # Population size on the y axis
        color = ~country.list,                # Each country has a new colour 
        type = 'scatter',                     # Type of graph is scatter plot 
        mode = 'markers')                     # Each data point will be marked

saveWidget(plot, "interactive_scatter.html") 

# This looks a little ... odd. That one point in Norway, 1979, is skewing the data so we can't see the patterns as clearly.
# Let's try and log the populations to help observe more patterns in the data.
# Whilst we are at it, we can make some further adjustments ... 

plot_ly(data = puffin_data,                                                                                     # Using the puffin data
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

saveWidget(plot, "improved_interactive_scatter.html") 

## If we want to spice up this graph and make it more accessible for those of younger ages... we can make ANIMATIONS 
### potentially delete this? 
p <- ggplot(puffin_data, aes(x = year, y = population, colour = country.list))+
  geom_point(show.legend = FALSE, alpha = 0.7)+
  scale_color_viridis_d()+
  scale_size(range = c(2.12))+
  scale_y_log10() +
  labs(x = "Years", y = "Population(Log Scale)")

gif <- p +transition_time(year) +
  labs (title = "year: {frame_time}")

animate(gif)

getwd()
setwd("C:/Users/emmak/OneDrive - University of Edinburgh/year 3/DATA SCIENCE/data science github page/tutorial-emmmahouse")
anim_save("puffin_animation.gif", animation = gif)
  
  
  
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
