# Creating interactive visualisations: DT and plotly 
#### *Created by Emma House*
---
![image](https://github.com/user-attachments/assets/cc144fed-ef51-473e-914f-99edd798a0af)
*Credits: WWF*

## Learning outcomes:
#### 1. To understand the importance of interactive infographics for widening your audience range
#### 2. To confidently use packages such as DT to produce a basic interactive table
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

**In this tutorial we will be using data from [this repository](https://github.com/EdDataScienceEES/tutorial-emmmahouse.git). Click on that link too access the repository and download the Puffin data used to follow the tutorial directly, or use your own data.**

## 1. Introducing the importance of interactive visualisations 
We all know traditional static charts and graphs are useful as infographics, but interactive visuals offer more **flexibility** and **excitement** in data science. We can zoom in on details, observe changes over time and explore data in depth ... how exciting I hear you cry! In all seriousness, if you want your data and graphs to stand out in the crowd, this is the tutorial for you! These interactive infographics are ideal for wesbites that reach out to the **general public** as the audience. The interactive nature makes it **appealing** for a wider range of readers. If you are interested in careers associated with **public engagment and data science**, these are the most engaging graphs to help you out. There are a range of packages we will be delving into that help you break down complex datasets into **easily understandable** animated infographics. You can **personalise** the data to fit a particular theme, you want barbie? We can make that happen.  Overall, these are super handy packages that can help elevate your data presentation, now let's get into it ...

## 2. Background checks 
To execute all of these exciting interactive infographics, we need to make sure you are set up to code them. Essentially, this is the admin faff before getting into the nitty gritty code.  
Here's a list of things to do before we get started:

#### A. Set your working directory
As I'm sure you know by now, the working directory is the folder where your script operates from, where it looks for files to read or write. Therefore my working directory will differ to yours, so do edit the code below...

```
# Set your working directory, this will be different for you depending on your filepath to the downloaded repository 
setwd("~/Downloads/tutorial-emmmahouse")
```
#### B. Install packages and download libraries needed for the tutorial
We install packages so we can download them, to utilise their functions whilst coding. The main packages to highlight for this tutorial are the 'DT' and 'plotly'. These are all key to aiding the process of interactivity within coding.

```
# Install packages 
install.packages("tidyverse")    # Helps us clean the data
install.packages("DT")           # Renders the interactive tables in reports 
install.packages("ggplot2")      # Helps us create the beautiful graphs
install.packages("dplyr")        # Provides a range of functions to help manipulate data
install.packages("plotly")       # Creates the interactive graphs, even 3D plots or geographic maps
install.packages("htmlwidgets")  # Allows us to create HTML based interactive inforgraphics


# Download libraries 
library(tidyverse)
library(DT)
library(ggplot2)
library(dplyr)
library(plotly)
library(htmlwidgets)

```
#### C. Load in the data you would like to use for this tutorial (see above for the link to the repository with the Atlantic Puffin data)
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
So we have different populations of Atlantic Puffins across different countries that have been measured over the years. Each population measured has it's own id, which is tracked over years. Currently, the puffin data is in **wide format** but we want it in **long format**, with the NAs removed and population sizes rounded, to make life easier for ourselves when we begin to plot graphs. When opening the dataset, you can see there are characters mixed with the numeric years eg X1982, thus we will aim to remove the Xs. Moreover, when making this new dataset, we do not need to use all of the original columns, eg the family, genus and species are unnecessary when we know all the species we are looking at are Atlantic Puffins. Therefore we can select the columns we would like for future manipulation. 

Some of the **most important packages** for data wrangling include: 


| Function | Meaning          | 
|----------|----------        |
| pivot        | Allows you to create a new column| 
| mutate | Allows you to edit non numeric characters from values|
| parse_number | Allows you to reshape data from long format to wide format |
| filter | Allows you to select rows that meet specific conditions |
| select | Allows you to choose which columns you would like to keep in a new dataset |
| rename | Allows you change the name(s) of columns |


If you are wrangling your own data, see if you can try and use these functions. If you are struggling, Coding Club do some [excellent tutorials](https://ourcodingclub.github.io/tutorials/data-manip-intro/) on data manipulation to help you along or to jog your memory of what further functions can be applied. 


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
PHEW! All that background data wrangling is done, now we can focus on our first aim: to make a *simple interactive table*. 

Data tables in general, are **fundamental tools** when it comes to data analysis. They provide an excellent **oveview of the data set** without any manipulation. They are prefect for **organising data** in a manner that is **accessible** for more people. Imagine handing your mother an excel spreadsheet and then a beautiful clear table with the exact same information. She will be far more likely to engage with and understand the latter. Hopefully this emphasises the importance of tables, especially when analysing larger datasets. 

Now lets take this a step further and talk about interactive tables. These let the audience **engage with the data directly**, allow them to filter through values, finding their own conclusions. It adds an element of **fun** for those who have no background in data analysis and makes the data even more accessible than it already was. 

Now there are several ways to create an interactive table, different functions that can be used. In this tutorial we will cover the use of **DT** which allows a range of table features that allows customised interactions. You piece together the code based on how you would like the table to look: 

i. We would like the table in a **list format**\
ii. We would like **10 rows of data per page**, otherwise it would be too overwhelming\
iii. We would like a **search bar** to aid data observations for the audience\

This *criteria* we have made can be easily transferred into code, specifically, into a 'list' as seen below. 


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



<iframe src ="figures/interactive_table.html" width = "800" height = "600"></iframe>



But we can do more adjusting to this table to make it more **professional and accessible** for a wider range of audiences. Maybe we want more options to search data within the table, or to add colour certain values to observe patterns more easily. 

These are simple edits to the code using *'filter = "top"'* to adjust the search bars and *'formatStyle'* to add in a pop of colour to your chosen values. We want the population values to come up in colour, so we select the 'population' within the formatStyle function. *'styleInterval'* is the function required for defining the colour scheme for the values in the columns and your chosen number eg *'10'* will be the breakpoint. This means the first colour chosen, *'red'* will be used for values below 10 and the latter colour will be for those values after 10. So, say we wanted all colours after 10 to be green, we can simply change the code from *'white'* to *'green'*, as you will see below. This is a fantastic tool for sorting data into catagories - here we can easily see the worryingly low puffin populations as they are coloured in red. 


```

## Developing the data table even further ...


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

<iframe src ="figures/improved_interactive_table.html" width = "800" height = "600"></iframe>



Adding **colour** to puffin populations **below the value of 10** highlights patterns in the data more easily. We can observe that mostly puffin populations in **Canada and Russia** have lower levels, as they show up in red. We can also see after skimming through the data, that Russia has one of the largest sets for puffins out of all the countries. Observations like this can be helpful before settling into graph making.


NB. Here are some further options for interactive data tables ... 


| Package     | Explanation                                                                                                                                | 
|-------------|--------------------------------------------------------------------------------------------------------------------------------------------|
| DT          | Easy to use, sorts and searches larger datasets efficiently. Filters catagorical and numeric data, allowing independent sarching for users.| 
| reactable   | More modern tabling system, less feature rich than DT but more user friendly interface.                                                    |
| formattable | Provides in cell visualisation for dataframes, adding colored scales and bars as indicators of the values in the cells                     |
| flextable   | Word and powerpoint compatible tables, for reports. You can add images, merge cells and apply themes.                                      |

*Please note you cannot use two of these functions for one table. Some are not compatible to work together eg DT and reactable.*

For more information on graphs, [this website](https://medium.com/number-around-us/data-at-your-fingertips-crafting-interactive-tables-in-r-b4ae5ca7a71d#:~:text=Adding%20features%20like%20sorting%2C%20filtering,can%20make%20their%20own%20discoveries) is super handy at overviewing the different customisations you can get through different packages. 

## 5. Creating an interactive scatter plot
Before we think about plotting we need to distinguish a research question - what are we aiming to show on this graph? We have puffin populations, countries, years and much more - an interesting question might be to look at *how these puffin populations are changing over time across different countries*. WWF have reported a **decline in puffin populations**, with invasive species on the rise and food shortages. This makes our research question significant and a good investigation to display to the public to raise awareness of their threatened status. As previously mentioned, bringing graphs to life is an excellent way to *engage with a wider audience* - and this is the perfect opportunity to do so. Let's see what plotly can do...

Plotly is the perfect packages for creating interactive charts. You can easily turn a static ggplot2 into an interactive one with only a few simple edits to the code! Instead of ggplot, we use plot_ly, inputting the data as we usually do and defining the x and y axis variables. We add a '~' before the variables we want to plot on the graph, to reference the column from the puffin_data dataset. We also need to define the type of graph and the design of the datapoints on the graph. The interactive features include **hover effects, sliders and buttons** - all super cool techniques to captivate the audience. 

As we are investigating the puffin populations over time across different countries, the independent variable on the x axis will be the years, whilst the dependent variable is the puffin population sizes on the y axis. Meanwhile, we can distribute colours for each country, to visually observe the differences across the world. 

```
# Creating a basic interactive scatter plot 
plot <- plot_ly(data = puffin_data,           # Using the puffin data
        x = ~year,                            # Year on the x axis
        y = ~population,                      # Population size on the y axis
        color = ~country.list,                # Each country has a new colour 
        type = 'scatter',                     # Type of graph is scatter plot 
        mode = 'markers')                     # Each data point will be marked

saveWidget(plot, "interactive_scatter.html") 
```
So what does this look like? Well, you should have something that looks a little bit like this: 


<iframe src ="figures/interactive_scatter.html" width = "800" height = "600"></iframe>

But this looks a little ... odd. That one point in Norway, 1979, is **skewing the data** so we can't see the patterns as clearly. Let's try and log the populations to help observe more patterns in the data. 

*What is logging data and why do we do it, I hear you cry!*
Log transformation is a **data transformation technique**, usually used when the original data is skewed or does not follow a normal distribution pattern. Each variable x is replaced with log(x) - so they represent the same values in relation to one another but instead on a log scale, so the graph would be **easier to read and patterns easier to define**. It makes our lives a whole lot easier, as you can clearly see the difference between the graph above, and the graph below. 

We can also make some further adjustments to the graph to improve presentation. 

We can adjust what is stated when yoUr mouse hovers over points with this simple code:
```
text = ~paste("country:", country.list, "<br>Population:", population)
```
The text holds a string of information for each data point. In this example, each point will have information on the specific country and the population of puffins seen at that point in tha year. Another technique to present this information is using 'hoverinfo' which does the same thing: 

```
text = ~country, 
    hoverinfo = "text",
```
This presents only the name of the country when hovering over a point. 

To make this graph look more professional, we can remove the gridlines and emphasise the clean axis lines, to create a clear graph. With a line of code to represent each of these points. 
```
showgrid = FALSE, # Removes gridlines
zeroline = TRUE,  # Retains the axis lines
linecolor = 'black' # Ensures axis lines are black
```
We can also create a title for the graph and edit the axis labels. You may be getting deja vu, because this is the same code for a ggplot - if you are struggling with these, head to coding club's tutorial on (creating graphs with ggplot)[https://ourcodingclub.github.io/tutorials/datavis/].

Now, I have added a little extra to the end of the code so the ticks on the y axis are more even, after the logging. *tickmode* and *dtick* are useful settings to control the appearance of ticks on an axis. Tickmode can be adjusted to linear, array or auto, depending on the dataset you have. Linear results in regular intervals for the ticks, array allows you to choose the positioning of the ticks at specific values and auto plot the ticks automatically. *dtick* defines the spacing between the ticks, so below is an example of log(1) spacing, as the y axis is the logged population. 

```
tickmode = "linear",
dtick = 1
``` 

If we combine all these new features, we get this code: 
``` 
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
  ```

The improved graph looks a lot better and we can see the different puffin population patterns more clearly. Although it appears many of the populations are fairly stable over the years, it is key to remember each country has a different number of population datasets, decreasing the reliability of these conclusions. 

<iframe src ="figures/improved_interactive_scatter.html" width = "800" height = "600"></iframe>

## 6. Making an animation 
Amazing! We are nearly at the end now - you have successfully made an interactive table, interactive graph and learnt further tips along the way about different functions and packages that can also be used for similar results. To end this tutorial, we are going to attempt an animated plot, which can also be made with a package called gganimate, although it can also be made with plot_ly!

The only difference to the code for an animation is follows: 
```
frame =~year
```
This is the key animated feature, that allows the graph and data points to transition through different frames with years. Without the frame stated, this would be a static plot. 


```
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

```
This is the finished product! More mouse interactions to draw in the audience. 

<iframe src ="figures/puffin_animated_plot.html" width = "800" height = "600"></iframe>
