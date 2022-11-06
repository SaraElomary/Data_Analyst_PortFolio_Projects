library(dplyr)
library(skimr)

# LOAD THE DATASET
View(MY_DEPARTMENTAL_STORE_)

# GLIMPSE THE DATASET
glimpse(MY_DEPARTMENTAL_STORE_)


# FILTER 
# 1. INFORMATION ABOUT PRODUCT TYPE Snacks
store1  <- filter(MY_DEPARTMENTAL_STORE_, PRODUCT_TYPE == "snacks")
View(store1)
unique(MY_DEPARTMENTAL_STORE_$PRODUCT_TYPE)

store1  <- filter(MY_DEPARTMENTAL_STORE_, COMPANY %in% c("S", "M")) %>% 
          View() %>% 
unique(MY_DEPARTMENTAL_STORE_$COMPANY)

# SELECT
#2. GET THE DETAILS OF FIRST 6 ROWS
store2  <- MY_DEPARTMENTAL_STORE_ %>%
           slice_head(n=6) %>% 
           View()

S1 <-  MY_DEPARTMENTAL_STORE_ %>% 
      select(PRODUCT_TYPE, starts_with('h')) %>% 
      select(PRODUCT_TYPE, ends_with('e')) %>% 
      #select(COMPANY, 6:7) %>% 
      View()


# MUTATE
# 1. Add a column of multiplication

Store2 <- MY_DEPARTMENTAL_STORE_ %>%
    mutate(PROFIT = SELLING_PRICE- COST_PRICE) %>% 
    mutate(PROFIT_PERCENT = PROFIT /COST_PRICE * 100) %>% 
    mutate(NEW_PROFIT = QUANTITY_DEMANDED * PROFIT) 
    View()  
    
    #Other format
      #S2 <- MY_DEPARTMENTAL_STORE_ %>%
      #mutate(PROFIT1 = SELLING_PRICE- COST_PRICE, PROFIT_PERCENT1 = PROFIT1 /COST_PRICE * 100, NEW_PROFIT = QUANTITY_DEMANDED * PROFIT1) %>% 
      #View()

# Save the last version of the edit table

write.table(Store2, file ="FINAL DEPARTMENTAL STORE.csv", sep=",")


# ARRANGE()
#1.ARRANGE ASC OF QTE DEMANDED
store2 <- MY_DEPARTMENTAL_STORE_ %>%
  arrange(QUANTITY_DEMANDED,TRUE) %>% 
  View()


### Find the descriptive statistics for the NET PROFIT

summary(FINAL_DEPARTMENTAL_STORE)
View(FINAL_DEPARTMENTAL_STORE)

S1 <- FINAL_DEPARTMENTAL_STORE %>%
      summarise(meanNetProfit = mean(PROFIT), SumProfit=sum(PROFIT), MinProfit= min(PROFIT), MaxProfit = max(PROFIT), sdProfit = sd(PROFIT), RangePROFIT = range(PROFIT), MediandProfit = median(PROFIT), varPROFIT = var(PROFIT)) %>% 
      View()


#

S1 <- FINAL_DEPARTMENTAL_STORE %>%
      filter(PRODUCT_NAME %in% c ("a")) %>% 
      group_by(PRODUCT_TYPE) %>% 
      summarise(avg= mean(PROFIT)) %>% 
      arrange(avg) %>% 
      View()
      
# PRACTICE TASK 1
#########1. GET THE INFORMATION OF THE COLUMNS2-10
select(FINAL_DEPARTMENTAL_STORE,2:10)
store3 <-  FINAL_DEPARTMENTAL_STORE %>% 
           select(2:10) %>% 
           filter(PRODUCT_CATEGORY == 'haircare') %>% 
           View()
unique(FINAL_DEPARTMENTAL_STORE$PRODUCT_CATEGORY)


######### 2. WHERE PRODUCT CATEGORY IS HOUSEHOLD
store3 <-  FINAL_DEPARTMENTAL_STORE %>% 
  arrange(QUANTITY_DEMANDED) %>% 
  group_by(PRODUCT_CATEGORY) %>%
  summarise(avg= mean(QUANTITY_DEMANDED), som=sum(QUANTITY_DEMANDED)) %>% 
  View()

store3 <-  FINAL_DEPARTMENTAL_STORE %>% 
          arrange(QUANTITY_DEMANDED) %>% 
          group_by(PRODUCT_CATEGORY) %>%
          filter(PRODUCT_CATEGORY == 'haircare') %>% 
          select(2:10) %>% 
          View()



#########Plottig###################################
###################################################
###################################################
library(ggplot2)
library(dplyr)


View(FINAL_DEPARTMENTAL_STORE)

#1. Plot for the average QTE and product type ---BAR PLOT
FINAL_DEPARTMENTAL_STORE %>% 
  group_by(PRODUCT_TYPE) %>% 
  summarise(AVGProductType = mean(QUANTITY_DEMANDED)) %>% 
  ggplot(aes(x = PRODUCT_TYPE, y = AVGProductType)) + geom_col(width=0.2, fill="blue") +
  theme(text= element_text(size = 10))

#1. Plot for the profit net  and product type

FINAL_DEPARTMENTAL_STORE %>% group_by(PRODUCT_TYPE) %>% 
  summarise(avgr=mean(PROFIT)) %>% 
  ggplot(aes(x = PRODUCT_TYPE, y = avgr)) + geom_col(width = 0.3, fill ="light green") + 
  theme(text= element_text(size = 6))



#-------------------------Scatter plot-----
FINAL_DEPARTMENTAL_STORE %>%  ggplot(aes(x = QUANTITY_DEMANDED, y = PROFIT, color = PRODUCT_CATEGORY)) + geom_point()

FINAL_DEPARTMENTAL_STORE %>%  ggplot(aes(x = COMPANY, y = NEW_PROFIT, color = PRODUCT_CATEGORY)) + geom_point()


#-------------------------Line chart-----

FINAL_DEPARTMENTAL_STORE %>%  ggplot(aes(x = QUANTITY_DEMANDED, y = SELLING_PRICE)) + geom_line()
FINAL_DEPARTMENTAL_STORE %>% group_by(PRODUCT_TYPE, COMPANY) %>% 
  summarise(avgr = mean(NEW_PROFIT)) %>% 
  ggplot(aes(x = PRODUCT_TYPE, y= avgr, group = COMPANY,color =COMPANY)) + geom_line()+
  theme(text = element_text(size = 10))


#-------------------------HISTOGRAM-------------------------
FINAL_DEPARTMENTAL_STORE %>% 
  ggplot(aes(x=PROFIT_PERCENT, fill = PRODUCT_CATEGORY))+ geom_histogram(binwidth = 30)
FINAL_DEPARTMENTAL_STORE %>% 
  filter(PRODUCT_TYPE == 'snacks') %>% 
  ggplot(aes(x=QUANTITY_DEMANDED, fill = PRODUCT_CATEGORY)) + geom_histogram(binwidth = 20)
FINAL_DEPARTMENTAL_STORE.colnames()
colnames((FINAL_DEPARTMENTAL_STORE))

#-------------------------PRACTICE-------------------------
FINAL_DEPARTMENTAL_STORE %>% 
  group_by(COMPANY) %>% 
  summarize(avg = mean(PROFIT)) %>% 
  ggplot(aes(x=COMPANY, y=avg, group = 1, color = COMPANY)) + geom_line() + 
  theme(text = element_text(size = 9))


