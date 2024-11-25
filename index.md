# Creating interactive visualisations: plotly, DT and flextable 
#### *Created by Emma House*
---
![image](https://github.com/user-attachments/assets/cc144fed-ef51-473e-914f-99edd798a0af)
*Credits: WWF*

## Learning outcomes:
#### 1. To understand the importance of interactive infographics for widening your audience range
#### 2. To confidently use pakcages such as DT and flextable to produce a basic interactive tables
#### 3. To confidently produce interactive and animated graphs
#### 4. To understand data patterns more efficiently and easily from interactive infographics

## Tutorial aims: 
1. Introducing the importance of interactive visualisations
2. Background checks
3. Wrangling the data
4. Form a well presented interactive table
5. Produce a graph
6. Making this graph interactive
7. Using this graph to make an animation

** In this tutorial we will be using data from [this repository](https://github.com/EdDataScienceEES/tutorial-emmmahouse.git). Click on that link too access the repository and download the Puffin data used to follow the tutorial directly, or use your own data. **

## 1. Introducing the importance of interactive visualisations 
We all know traditional static charts and graphs are useful as infographics, but interactive visuals offer more flexibility and excitement in data science. We can zoom in on details, observe changes over time and explore data in depth ... how exciting I hear you cry! In all seriousness, if you want your data and graphs to stand out in the crowd, this is the tutorial for you! These interactive infographics are ideal for wesbites that reach out to the general public as the audience. The interactive nature makes it appealing for a wider range of readers. If you are interested in careers associated with public engagment and data science, these are the most engaging graphs to help you out. There are a range of packages we will be delving into that help you break down complex datasets into more appealing and easily understandable animated infographics. You can personalise the data to fit a particular theme, you want barbie? We can make that happen.  Overall, these are super handy packages that can help elevate your data presentation, now let's get into it ...

## 2. Background checks 
To execute all of these exciting interactive infographics, we need to make sure you are set up to code them. Essentially, this is the admin faff before getting into the nitty gritty code.  
Here's a list of things to do before we get started:

##### A. Set your working directory
As I'm sure you know by now, the working directory is the folder where your script operates from, where it looks for files to read or write. Therefore my working directory will differ to yours, so do edit the code below...

```
# Set your working directory, this will be different for you depending on your filepath to the downloaded repository 
setwd("~/Downloads/tutorial-emmmahouse")
```
##### B. Install packages and download libraries needed for the tutorial
We install packages so we can download them, to utilise their functions whilst coding. The main packages to highlight for this tutorial are the 'DT', 'flextable', 'plotly'. These are all key to aiding the process of interactivity within coding.

```
# Install packages 
install.packages("tidyverse")    # Helps us clean the data
install.packages("DT")           # Renders the interactive tables in reports 
install.packages("flextable")    # Helps us make attractive and formatted tables for output in word, powerpoint or HTML 
install.packages("ggplot2")      # Helps us create the beautiful graphs
install.packages("dplyr")        # Provides a range of functions to help manipulate data
install.packages("plotly")       # Creates the interactive graphs, even 3D plots or geographic maps
install.packages("htmlwidgets")  # Allows us to create HTML based interactive inforgraphics


# Download libraries 
library(tidyverse)
library(DT)
library(flextable)
library(ggplot2)
library(dplyr)
library(plotly)
library(htmlwidgets)

```
##### C. Load in the data you would like to use for this tutorial (see above for the link to the repository with the Atlantic Puffin data)
The data used below is a segment of the dataset from Living Planet Index - a free open source database containing populations of hundreds of species across the world. 
```
# Load the puffin data 
atlantic_puffin <- read.csv("data/atlantic_puffin.csv")
```
![image](https://github.com/user-attachments/assets/ebebbc96-5487-4a3c-ad1c-2adf6daba4ec)
*Credits: WWF*

## 3. Wrangling the data
This is another step that adequately prepares the data for the interactive table and graphs. Let's have a look at the layout and structure of this dataset. 

```
# Data overview
str (atlantic_puffin)
summary (atlantic_puffin)
```
So we have different populations of Atlantic Puffins across different countries that have been measured over the years. Each population measured has it's own id, which is tracked over years. Currently, the puffin data is in wide format but we want it in long format, with the NAs removed and population sizes rounded, to make life easier for ourselves when we begin to plot graphs. When opening the dataset, you can see there are characters mixed with the numeric years eg X1982, thus we will aim to remove the X to make life easier for ourselves. Moreover, when making this new dataset, we do not need to use all of the original columns, eg the family, genus and species are unnecessary when we know all the species we are looking at are Atlantic Puffins. Therefore we can select the columns we would like for future manipulation - making future data manipulations that much easier down the line. 

Some of the most important packages for data wrangling include: 


| Function | Meaning          | 
|----------|----------        |
| pivot        | Allows you to create a new column| 
| mutate | Allows you to edit non numeric characters from values|
| parse_number | Allows you to reshape data from long format to wide format |
| filter | Allows you to select rows that meet specific conditions |
| select | Allows you to choose which columns you would like to keep in a new dataset |
| rename | Allows you change the name(s) of columns |


If you are wrangling your own data, see if you can try and use these functions. If you are struggling, Coding Club do some [excellent tutorials](https://ourcodingclub.github.io/tutorials/data-manip-intro/) on data manipulation to help you along. 


```
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


```

## 4. Creating a simple interactive table
PHEW! All that background data wrangling is done, now we can focus on our first aim: to make a simple interactive table. 


```
# Creating a simple interactive data table 
datatable(puffin_data,                        # This is the data set we will be using in the table
          options = list(                     # We want the table in a list format of data
            pageLength = 10,                  # Each page has 10 rows of values
            searching = TRUE,                 # We can add a search bar
            lengthChange = FALSE))            # We cannot change the number of rows displayed per page
 
saveWidget(datatable(puffin_data), "interactive_table.html")   # Saving the interactive table to a HTML file 


```
Easy peasy! You now should have a table that looks similar to this...

<iframe "figures/interactive_table.html" ="https://github.com/EdDataScienceEES/tutorial-emmmahouse/blob/master/figures/interactive_table.html" width = "800" height = "600"></iframe>


But we can do more adjusting to this table to make it even better ....
```
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

```
Now you should have something that looks like this: 
New and improved table:

<iframe "figures/improved_interactive_table" ="https://github.com/EdDataScienceEES/tutorial-emmmahouse/blob/master/figures/improved_interactive_table.html" width = "800" height = "600"></iframe>


## 5. Creating an interactive scatter plot

- intro
- code
- output
- what is logging and why do we do it ? add a text box underneath

## 6. Making an animation 
