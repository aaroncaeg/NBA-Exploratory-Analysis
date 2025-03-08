packages <- c("shiny", "dplyr", "ggplot2", "ggthemes", "plotly", "readxl", "rsconnect")

# Loop through the list and install missing packages
for (pkg in packages) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
    library(pkg, character.only = TRUE)  # Load the package after installation
  }
}

library(shiny)
library(dplyr)
library(ggplot2)
library(ggthemes)
library(plotly)
library(readxl)
library(rsconnect)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("NBA Statistical Scatterplot"),
  fluidRow(
    column(3,
           sliderInput(inputId = "size",
                       label = "Size of Dots :",
                       min = 1,
                       max = 10,
                       value = 2)
    ),
    column(3,
           sliderInput(inputId = "transparency",
                       label = "Transparency of Dots :",
                       min = 0,
                       max = 1,
                       value = 0.75)
    ),
    column(3,
           selectInput(inputId = "Color", 
                       label = "Choose color of dots",
                       choices = list("Red" = "Red",
                                      "Blue" = "Blue",
                                      "Green" = "Green",
                                      "Pink" = "Pink",
                                      "Purple" = "Purple",
                                      "Gold" = "Gold",
                                      "Navy" = "Navy",
                                      "Maroon" = "Maroon",
                                      "Orange" = "Orange",
                                      "Brown" = "Brown",
                                      "Turqoise" = "Turqoise"),
                       selected = "Blue")
    ),
    h5(textOutput(outputId = "textout"), width = 12)),
  column(3,
         selectInput(inputId = "season",
                     label = "Select NBA Season",
                     choices = list("2019-20" = "19-20",
                                    "2018-19" = "18-19",
                                    "2017-18" = "17-18",
                                    "2016-17" = "16-17",
                                    "2015-16" = "15-16",
                                    "2014-15" = "14-15",
                                    "2013-14" = "13-14",
                                    "2012-13" = "12-13",
                                    "2011-12" = "11-12",
                                    "2010-11" = "10-11",
                                    "2009-10" = "09-10",
                                    "2008-09" = "08-09",
                                    "2007-08" = "07-08",
                                    "2006-07" = "06-07",
                                    "2005-06" = "05-06",
                                    "2004-05" = "04-05",
                                    "2003-04" = "03-04",
                                    "2002-03" = "02-03",
                                    "2001-02" = "01-02",
                                    "2000-01" = "00-01",
                                    "1999-00" = "99-00",
                                    "1998-99" = "98-99",
                                    "1997-98" = "97-98",
                                    "1996-97" = "96-97",
                                    "1995-96" = "95-96",
                                    "1994-95" = "94-95",
                                    "1993-94" = "93-94",
                                    "1992-93" = "92-93",
                                    "1991-92" = "91-92",
                                    "1990-91" = "90-91",
                                    "1989-90" = "89-90",
                                    "1988-89" = "88-89",
                                    "1987-88" = "87-88",
                                    "1986-87" = "86-87",
                                    "1985-86" = "85-86",
                                    "1984-85" = "84-85",
                                    "1983-84" = "83-84",
                                    "1982-83" = "82-83",
                                    "1981-82" = "81-82",
                                    "1980-81" = "80-81",
                                    "1979-90" = "79-80",
                                    "1978-79" = "78-79",
                                    "1977-78" = "77-78",
                                    "1976-77" = "76-77",
                                    "1975-76" = "75-76",
                                    "1974-75" = "74-75",
                                    "1973-74" = "73-74",
                                    "1971-72" = "71-72",
                                    "1970-71" = "70-71",
                                    "1969-70" = "69-70",
                                    "1968-69" = "68-69",
                                    "1967-68" = "67-68",
                                    "1966-67" = "66-67",
                                    "1965-66" = "65-66",
                                    "1964-65" = "64-65",
                                    "1963-64" = "63-64",
                                    "1962-63" = "62-63",
                                    "1961-62" = "61-62",
                                    "1960-61" = "60-61",
                                    "1959-60" = "59-60",
                                    "1958-59" = "58-59",
                                    "1957-58" = "57-58",
                                    "1956-57" = "56-57",
                                    "1955-56" = "55-56",
                                    "1954-55" = "54-55",
                                    "1953-54" = "53-54",
                                    "1952-53" = "52-53",
                                    "1951-52" = "51-52",
                                    "1950-51" = "50-51"),
                     selected = "19-20")
  ),
  column(3,
         selectInput(inputId = "X", 
                     label = "Choose x-axis",
                     choices = list("Points" = "PTS",
                                    "Assists" = "AST",
                                    "Rebounds" = "TRB",
                                    "Steals" = "STL",
                                    "Blocks" = "BLK",
                                    "Minutes Played" = "MP"),
                     selected = "Points")
  ),
  column(2,
         selectInput(inputId = "Y",
                     label = "Choose y-axis",
                     choices = list("Points" = "PTS",
                                    "Assists" = "AST",
                                    "Rebounds" = "TRB",
                                    "Steals" = "STL",
                                    "Blocks" = "BLK",
                                    "Minutes Played" = "MP"),
                     selected = "STL")
  ),
  # column(2,
  #       selectInput(inputId = "Reg",
  #                  label = "Choose Regression Type",
  #                 choices = list("lm" = "lm",
  #                               "loess" = "loess",
  #                              "glm" = "glm",
  #                             "gam" = "gam"),
  #             selected = "loess")
  # ),
  column(2,
         checkboxInput("Log", label = "Log Transform variables", value = FALSE),
  ),
  
  # Show a plot of the generated distribution
  # mainPanel(
  plotlyOutput(outputId = "distPlot",width = "auto", height = "auto", inline = TRUE),
  textOutput("txtOutput"),
)