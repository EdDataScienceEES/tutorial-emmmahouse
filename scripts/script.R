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
          Year_Scale = Year - min(Year),                                             # Scaling the year 
          Population = round(Population)) %>%                                        # Rounding the population values
  filter(is.finite(Population), !is.na(Population)) %>%                              # Removing any NA values from the data
  select (Common.Name, Region, Country.list, id, Year, Population, Year_Scale)    # Selecting what columns we need in the final dataset


# Creating a simple interactive data table 
datatable(puffin_data,                        # This is the dataset we will be using in the table
          options = list(                     # We want the table in a list format of data
            pageLength = 10,                  # Each page has 10 rows of values
            searching = TRUE,                 # We can add a searchbar
            lengthChange = FALSE))            # We cannot change the number of rows displayed per page
 
saveWidget(datatable(puffin_data), "interactive_table.html")   # Saving the interactive table to a HTML file 

## Nice work! We now have a simple table, interactive with the search bar and 10 rows per page - pretty cool !!
## But I want to make this look even more attractive and change the names of the columns, what more can I do... 


datatable(puffin_data,
          options = list(
            pageLength = 10,
            searching = TRUE,
            lengthChange = FALSE, 
            buttons = c('copy', 'csv', 'excel', 'pdf', 'print')))  # We can add buttons 



# Creating an interactive scatterplot 
plot_ly(data = puffin_data,
        x = ~Year,
        y = ~Population 
        color = ~Country.list)


