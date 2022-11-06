#Step 1: Load packages
library(tidyverse)
library(skimr)
library(janitor)

#Step 2: import data
library(readr)
hotel_bookings <- read_csv("R Files/hotel_bookings.csv")
View(hotel_bookings)

#Step 3: Getting to know the data
head(hotel_bookings)
glimpse(hotel_bookings)
skim_without_charts(hotel_bookings)
str(hotel_bookings)
colnames(hotel_bookings)

#Step 4: Cleaning the data
trimmed_df <- hotel_bookings %>% 
  select( hotel, is_canceled, lead_time) %>% 
  rename(hotel_type = hotel) 

example_df <- hotel_bookings %>% 
  select(arrival_date_year, arrival_date_month) %>% 
  unite(arrival_date , c(arrival_date_year, arrival_date_month) , sep = " ")
example_df

example_df2 <- hotel_bookings %>% 
  mutate(guests_2 = adults, children , babies)

#Displaying the results
example_df3 <- example_df2 %>% 
  select(guests_2)
View(example_df2)

example_df <- hotel_bookings %>% 
  summarise(number_canceled = sum(is_canceled), average_lead_time = mean(lead_time))
example_df

#Data visualization
library(ggplot2)
#A stakeholder tells that, "I want to target people who book early, and I have a hypothesis that people with children have to book in advance."
ggplot(data = hotel_bookings) + geom_point(mapping = aes(x = lead_time, y = children))


#A stakeholder says that she wants to increase weekend bookings, an important source of revenue for the hotel. Your stakeholder wants to know what group of guests book the most weekend nights in order to target that group in a new marketing campaign. She suggests that guests without children book the most weekend nights. Is this true? 
ggplot(data = hotel_bookings) + geom_point(mapping = aes(x = stays_in_weekend_nights, y = children))


#Last Step Visualization
library(ggplot2)

## Making a Bar Chart
## Step 5: Diving deeper into bar charts

#Your stakeholder is interested in developing promotions based on different booking distributions, but first they need to know how many of the transactions are occurring for each different distribution type.
ggplot(data = hotel_bookings) + geom_bar(mapping = aes(x = distribution_channel))

#your stakeholder has more questions. Now they want to know if the number of bookings for each distribution type is different depending on whether or not there was a deposit or what market segment they represent. 
ggplot(data = hotel_bookings) + geom_bar(mapping = aes(x = distribution_channel, fill = deposit_type))
ggplot(data = hotel_bookings) + geom_bar(mapping = aes(x = distribution_channel, fill = market_segment))


## Step 6: Facets galore
# your stakeholder asks you to create separate charts for each deposit type and market segment to help them understand the differences more clearly.

ggplot(data = hotel_bookings) + geom_bar(mapping = aes (x = distribution_channel)) + facet_wrap(~market_segment~deposit_type) + theme(axis.text.x = element_text(angle = 45))


## Step X : Filtering

##1) filtering your data; 
##2) plotting your filtered data. 

####your stakeholder decides to send the promotion to families that make online bookings for city hotels. The online segment is the fastest growing segment, and families tend to spend more at city hotels than other types of guests. 
online_city_hotels <- filter(hotel_bookings, 
                             (hotel == "City Hotel" & hotel_bookings$market_segment == "Online TA"))
View(online_city_hotels)
onlineta_city_hotels_v2 <- hotel_bookings %>% 
  filter(hotel == "City Hotel") %>% 
  filter(market_segment == "Online TA")
##Visualize the new frame
ggplot(data = online_city_hotels) + 
  geom_point(mapping = aes(x = lead_time, y = children))