library(readr)
library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashBootstrapComponents)
library(ggplot2)
library(plotly)
library(tidyverse)

app <- Dash$new(external_stylesheets = dbcThemes$BOOTSTRAP)

df  <- read.csv("data/processed/clean_data.csv",row.names = 1 )

app$layout(
  dbcContainer(
  list(
    htmlH2('U.S. City Crime Visualization'),
    htmlBr(),
    dbcRow(
      list (
        dbcCol(
          list(
            htmlDiv(id = 'input-area'),
            
            htmlH4('State:'),
            dccDropdown(
              id="state",
              value="California",
              options= df %>% pull(state_name) %>% unique() %>%  purrr::map(function(col) list(label = col, value = col)),
            ),
            
            htmlH4('City:'),
            dccDropdown(
              id="city",
              value="Los Angeles",
              options= df %>%filter(state_name == "California") %>% select(city_name) %>% pull %>% unique() %>%  purrr::map(function(col) list(label = col, value = col)),
            ),
            
            htmlH4('Year:'),
            dccDropdown(
              id="year",
              value=2015,
              options= df %>% pull(year) %>% unique() %>%  purrr::map(function(col) list(label = col, value = col)),
            )
            
          )
          ,md = 2),
        
        dbcCol(
          list(
            htmlDiv(id = 'output-area'),
            dccGraph(id='plot-area')
          ) 
          ,md = 5),
        
        dbcCol(
          list(
            htmlDiv(id = 'output-area2'),
            dccGraph(id='plot-area2'),
            htmlH4('Year Range'),
            dccRangeSlider(
              id="yrange",
              min = 1975,
              max = 2015,
              marks = list(
                '1975' = '1975',
                '1980' = '1980',
                '1985' = '1985',
                '1990' = '1990',
                '1995' = '1995',
                '2000' = '2000',
                '2005' = '2005',
                '2010' = '2010',
                '2015' = '2015'
              ),
              value= list(1975, 2015),  # REQUIRED to show the plot on the first page load
            )       
          ) 
        )
        
      )
     )
   ) 
  )   
)

app$callback(
  output("city", "options"),
  list(input("state", "value")),
  function(state){
    df %>%filter(state_name == state) %>% select(city_name) %>% pull %>% unique() %>%  purrr::map(function(col) list(label = col, value = col))
  }
)


app$callback(
  output('plot-area','figure'),
  list(input("state", "value"),
       input("city", "value"),
       input("year", "value")),
  
  function(state,city,year){
    
    df_select <- df %>% filter(city_name == city, year == year , state_name == state)
    data_bar_plot <- df_select %>% select(homs_per_100k:agg_ass_per_100k) %>%
      pivot_longer(homs_per_100k:agg_ass_per_100k,names_to = "type",values_to = "value") %>%
      mutate (type = str_replace(type,"homs_per_100k","Homicide")) %>%
      mutate (type = str_replace(type,"rape_per_100k","Rape")) %>%
      mutate (type = str_replace(type,"rob_per_100k","Robery")) %>%
      mutate (type = str_replace(type,"agg_ass_per_100k","Aggravated Assault"))
    bar <- data_bar_plot %>% ggplot(aes(x = type,y = value, fill = type)) +
      geom_bar(stat = "identity") +
      labs(y = "Crime per 100K", x = "Violent Crime") +
      ggtitle("City violent crimes at year of interest") +
      theme(
        plot.title = element_text(size = 18),
        axis.text = element_text(size = 16),
        axis.title = element_text(size = 16),
        legend.position = "none"
      )
    bar <- bar+theme_classic()+ggthemes::scale_color_tableau()
    
    ggplotly(bar) %>% 
      layout(legend = list(
        orientation = "h",x = 0.4, y = -0.2
      )
      )
  }
)


app$callback(
  output('plot-area2','figure'),
  list(input("state", "value"),
       input("city", "value"),
       input("year", "value"),
       input("yrange","value")),
  
  function(state,city,year,yrange){
    
    df_select <- df %>% filter(city_name == city, year == year , state_name == state)
    data_line_plot <- df %>% filter(city_name == city, state_name == state, year >= yrange[1], year<=yrange[2])
    data_line_plot <- data_line_plot %>% select(year,violent_per_100k:agg_ass_per_100k) %>%
      pivot_longer(violent_per_100k:agg_ass_per_100k,names_to = "type",values_to = "value") %>%
      mutate (type = str_replace(type,"violent_per_100k","Total")) %>%
      mutate (type = str_replace(type,"homs_per_100k","Homicide")) %>%
      mutate (type = str_replace(type,"rape_per_100k","Rape")) %>%
      mutate (type = str_replace(type,"rob_per_100k","Robery")) %>%
      mutate (type = str_replace(type,"agg_ass_per_100k","Aggravated Assault"))
    line <- data_line_plot %>% ggplot(aes(x = year,y = value, color = type)) +
      geom_line(size = 1) +
      labs(y = "Crime per 100K", x = "Year", color = "Crime types") +
      ggtitle("Violent crimes by Years") +
      scale_x_continuous (breaks = c(seq(1975,2015,5)))+
      theme(
        plot.title = element_text(size = 18),
        axis.text = element_text(size = 16),
        axis.title = element_text(size = 16),
        legend.title = element_text(size = 16),
        legend.text = element_text(size = 14),
      )
    line <-line + theme_classic()+ggthemes::scale_color_tableau()
    
    ggplotly(line)%>%
      layout(legend = list(
        orientation = "h",x = 0.4, y = -0.2
      )
      )
    
  }
)

app$run_server(host = '0.0.0.0')
#app$run_server(debug = T)