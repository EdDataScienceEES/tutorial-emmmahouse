# Creating interactive visualisations: plotly, leaflet, DT, flextable and gganimate 
#### *Created by Emma House*
---

## Learning outcomes:
#### 1. To produce an interactive table 
#### 2. To produce a basic interactive graph (scatter graph) 
#### 3. To produce an animated graph 

## Tutorial aims: 
1. Introducing the importance of interactive visualisations
2. Downloading packages
3. Wrangling the data
4. Form a well presented interactive table
5. Produce a graph
6. Making this graph interactive
7. Using this graph to make an animation

** In this tutorial we will be using data from this repository. Click on this link to download the Puffin data used to follow the tutorial directly, or use your own data. **

## 1. Introducing the importance of interactive visualisations 
We all know traditional static charts and graphs are useful as infographics, but interactive visuals offer more flexibility and excitement in data science. We can zoom in on details, observe changes over time and explore data in depth ... how exciting I hear you cry! In all seriousness, if you want your data and graphs to stand out in the crowd, this is the tutorial for you! These interactive infographics are ideal for wesbites that reach out to the general public as the audience. The interactive nature makes it appealing for a wider range of readers. If you are interested in careers associated with public engagment and data science, these are the most engaging graphs to help you out. There are a range of packages we will be delving into that help you break down complex datasets into more engaging and easily understandable animated infographics. You can personalise the data to fit a particular theme, you want barbie? We can make that happen.  Overall, these are super handy packages that can help elevate your data presentation, now let's get into it ...

## 2. Setting the working directory, installing and downloading the packages 
To execute all of these exciting interactive infographics, we need to make sure you are set up to code them. Essentially, this is the admin faff before getting into the nitty gritty code. Firstly, we need to set your working directory, then install and download the packages necessary for this tutorial. 

```
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

# Download libraries 
library(tidyverse)
library(DT)
library(flextable)
library(ggplot2)
library(dplyr)
library(plotly)
library(gganimate) 
```
Time to load in the data you would like to use for this tutorial ...
```
# Load the puffin data 
atlantic_puffin <- read.csv("data/atlantic_puffin.csv")
```

## 3. Wrangling the data
This is another step that adequately prepares the data for the interactive table and graphs. Currently, the puffin data is in wide format but we want it in long format, with the NAs removed and population sizes rounded, to make life easier for ourselves.  
```
# Data wrangling  
# Okay, this may look scary but when you break it all down I promise it isn't so bad!

puffin_data <- atlantic_puffin %>% 
  pivot_longer (cols=25:69, names_to = "Year", values_to = "Population") %>%         # Transforms the data from wide to long format 
  mutate (Year = parse_number(Year),                                                 # Converts the values in year to numeric                    
          Year_Scale = Year - min(Year),                                             # Scaling the year 
          Population = round(Population)) %>%                                        # Rounding the population values
  filter(is.finite(Population), !is.na(Population)) %>%                              # Removing any NA values from the data
  select (Common.Name, Region, Country.list, id, Year, Population, Year_Scale) %>%   # Selecting what columns we need in the final dataset

```

## 4. Creating a simple interactive table
PHEW! All that background data wrangling is done, now we can focus on our first aim: to make a simple interactive table. 

```
# Creating a simple interactive data table 
datatable(puffin_data,                        # This is the dataset we will be using in the table
          options = list(                     # We want the table in a list format of data
            pageLength = 10,                  # Each page has 10 rows of values
            searching = TRUE,                 # We can add a searchbar
            lengthChange = FALSE))            # We cannot change the number of rows displayed per page
 

```
Easy peasy! You now should have a table that looks similar to this...

<iframe src="https://github.com/EdDataScienceEES/tutorial-emmmahouse/blob/master/figures/interactive_table.html" width = "800" height = "600"></iframe>

[Interactive Table](./interactive_table.html)


INSERT TABLE 

![image](https://github.com/user-attachments/assets/f6f4c9a6-28e0-4bdc-bf2e-6b8f6314ff65)


## 5. Creating an interactive scatter plot

- intro
- code
- output
- what is logging and why do we do it ? add a text box underneath

## 6. Making an animation 
