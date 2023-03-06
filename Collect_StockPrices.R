# install the library

install.packages(c('rvest', 'tidyverse'))

# Loading the library

library(rvest)
library(tidyverse)



# URL with the List of S&P 500 companies 

SP500_url <- "https://en.wikipedia.org/wiki/List_of_S%26P_500_companies"

# Read the html table in the page

sp500_original <- read_html(SP500_url) %>%
  html_node("table")%>%
  html_table()

# The titles of the html table

names(sp500_original)

# Creating a copy of the Data set origin

sp500_mod <- read_html(SP500_url) %>%
  html_node("table")%>%
  html_table()


# Selecting the variables of interest

sp500_mod <- sp500_mod %>% select(Symbol,
                                  Security,
                                  `GICS Sector`,
                                  `GICS Sub-Industry`,
                                  `Headquarters Location`)

# Rename the Data frame

names(sp500_mod) <- c("Ticker","Name","Sector","Industry","HQ_Location")

# Saving the list of companies 

save(sp500_mod, file = "sp500_mod.RData")



########## SEÇÃO 2 ########## 

# Creating the dataframe to store the data of the companies.

returns <- as.data.frame(matrix(NA, ncol = 8, nrow = 0))
names(returns) <- c("Date", "Open", "High", "Low", "Close", "Adj_Close", "Volume", "Ticker")

# Creating The function to collect the data of yahoo finance (2010 -/2022)

for(symbol in sp500_mod$Ticker){
  print(symbol)
  url <- paste0("https://query1.finance.yahoo.com/v7/finance/download/", symbol, "?period1=1262304000&period2=1672444800&interval=1d&events=history&includeAdjustedClose=true")
  print(url)
  
  ret <- try(read_csv(url))
  
  if(mode(ret) != "character"){
    ret$Ticker <- symbol
    returns <- rbind(returns, ret)
  }
}


# Renaming the Columns (or Variables)

names(returns) <- c("Date", "Open", "High", "Low", "Close", "Adj_Close", "Volume", "Ticker")


# Selecting the Variables of interest

returns <- returns %>% select ("Date","Ticker","Open","High","Low","Close")

# Creating a copy of Dataframe

returns2 <- returns %>% mutate (
  Open = as.numeric(Open),
  High = as.numeric(High),
  Low = as.numeric(Low),
  Close = as.numeric(Close),
)

# Save the Dataframe to csv

write.csv(returns_long, "Inserting the link of local folder of you preferring", row.names=FALSE)
