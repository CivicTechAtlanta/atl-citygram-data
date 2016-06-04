# Scrape event location, date, time (if available), and event title/description text
# from Creative Loafing Events Calendar
library(rvest)
library(stringr)
library(readr)

base.page <- "http://clatl.com/atlanta/EventSearch?sortType=date"
event.data <- data.frame(x = character(), y = character(), listing = character())

# Loop through 20 pages of Creative Loafing events calendar, and grab latitude, longitude, date, and event
# description into a data frame; write to csv.
# NOTE: STILL NEED TO FIGURE OUT HOW TO EXTRACT THE DATE
# Date is available in the event page itself
#     XPath: /html/head/comment()[7] --> DataObject "Event", Attribute "Date"

for (i in 1:20){
     print(paste0("page: ",i))
     ifelse(i == 1,
            page <- base.page,
            page <- paste0(base.page, "&page=", i)
     )
     
     # Get all link objects from each calendar event
     # Scraping note: This is working off of http://clatl.com/atlanta/EventSearch?sortType=date
     # and the CSS selector is ".listingLocation a:nth-child(2)"
     map.links <- read_html(page) %>% html_nodes(".listingLocation a:nth-child(2)") %>% 
          html_attr("href")
     
     # Pick a map link, navigate to it, and grab info
     # Scraping note: This is working off of the output of the above code, where each link html
     # is the "map" indicator.  The CSS selector is "#MapLargeDirectionsFormTo a"
     get.map.coordinates <- function(link){
          link %>% read_html() %>% html_nodes("#MapLargeDirectionsFormTo a") %>% html_attr("href") %>%
               str_extract_all("(-){0,}[0-9]{2}\\.[0-9]+")
     }
     
     # Use above function get.map.coordinates to get coordinates for each link in vector "map.links"
     map.coordinates <- list()
     for(i in 1:length(map.links)){
          map.coordinates[i] <- get.map.coordinates(map.links[i])
     }
     
     # Get listing raw text
     listing.raw.text <- read_html(page) %>% 
          html_nodes(".listing") %>% html_text()
     
     # Create data frame of x, y coordinates (only if they have the same length)
     if((length(listing.raw.text) == length(map.coordinates)) &
        length(listing.raw.text) == length(map.links)){
          df <- data.frame(x = sapply(map.coordinates, function(x) unname(x[1])), 
                           y = sapply(map.coordinates, function(x) unname(x[2])),
                           map.links = map.links,
                           listing = listing.raw.text)
          
          event.data <- rbind(event.data, df)
     }
     
     # THE NEXT LINE IS INCOMPLETE.  GOAL: GRAB DATE AND TIME
     # str_extract_all("Sat., June 4,", "\\w{3}\\., \\w+ [0-9]")
}

write_csv(event.data, "creative-loafing-events.csv")