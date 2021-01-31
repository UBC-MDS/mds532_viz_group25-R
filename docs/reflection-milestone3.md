## Reflection on the interactive app

Based on the milestone 3 instructions and peer’s feedbacks, we have successfully implemented a working skeleton of our proposed dashboard in R and added some minor improvements in response to suggestions.

Our interactive app is a visualization tool to display violent crimes of 68 U.S. cities over 45 years from 1975 to 2015. We have two plots in this app. The one on the left by default is set to display the evolution of total violent crimes of the city Los Angeles over 45 years. By adding four lines here, this plot also demonstrates the evolution of each category of crimes. The other one on  the right is a bar chart that by default is set to display violent crime in four categories of the city Los Angeles in 2015. And each bar has been annotated with label for a quick review.

We also have implemented a control panel on the left that can facilitate a user to update the bar chart geological and chronically. The bar chart will eventually display the counts of different type of crimes per 100k in the city and the year of interest.

The control panel consists of three dropdown menus. From top to bottom, they respectively allow a user to choose a state from the “State” menus, a city from the “City” menus, a year from the “Year” menu.

The two plots made by altair have been replaced with ggplot in this new version. One challenge arise in this process. It seems that dash is more generally used in Python rather than R. When searching on the internet for help, the amount of results for R is less than Python. 

The peer feedbacks gave an insight into different perspective for the same problem that we were tryingto solve. We are going to aestheticly make the dashboard visually more comfortable and readable, including modify titles and labels, and add additional interactive features.



