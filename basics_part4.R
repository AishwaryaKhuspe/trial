library(dplyr)
# Manipulate (subsetting) cases--------------

df1<-filter(nydata,BOROUGH=="MANHATTAN")
# Alternative: df1<-subset(nydata,BOROUGH=="MANHATTAN")

df1<-distinct(nydata,BOROUGH)
#Alternative: unique(nydata$BOROUGH)

df1<-sample_frac(nydata, 0.1, replace = TRUE) #randomly choose 10% of this data set #dont take replace = true, since same row can be picked again
df1<-sample_n(nydata, 1000, replace = TRUE) 
# Alternative: x<-sample(1:(length(nydata$BOROUGH)/10), replace = TRUE)
# df1<-nydata[x,]

df1<-slice(nydata,10:15)
# Alternative: df1<-nydata[10:15,]

# Manipulate variables----------------

#selecting variables
v<-pull(nydata, BOROUGH) #extract the column borough in v
v<-pull(nydata, 3)
# Alternative: v<-nydata$BOROUGH

v<-select(nydata, BOROUGH,ZIP.CODE)
# Alternative: v<-nydata[,3:4]

#arrange function to sort asc or desc
df1<-arrange(nydata, BOROUGH)
df1<-arrange(nydata, desc(BOROUGH))
# Alternative: df1<-nydata[order(BOROUGH),]

# Create variables----------------
df1<-mutate(nydata,newcol =2)
# Alternative: df1$newcol=2 #best way to create a new variable

v<-transmute(nydata, NUMBER.OF.PERSONS.INJURED) #creates a new df, and used for single variables, we can use mutate to add new variables
# Alternative: v<-nydata$NUMBER.OF.PERSONS.INJURED

# Data Aggregation------------------#where dplyr shines
# One function, one variable
data<-mtcars
summarise(mtcars, mean_mpg=mean(mpg))
# One function multiple variables
summarise(mtcars, mean_mpg=mean(mpg), mean_cyl=mean(cyl))
# Many function, one variable
summarise(mtcars, mean_mpg=mean(mpg),max_mpg=max(mpg))
# Many function, multiple variable
summarise(mtcars, mean_mpg=mean(mpg),max_cyl=max(cyl))

 # One function, one variable using group_by function #group by gives us unique values, and for each unique value it will give mean
summarise(group_by(mtcars,cyl), mean_mpg=mean(mpg))
# One function, one variable using group_by function #group by gives us unique values, and for each unique value it will give count
summarise(group_by(mtcars,cyl), count=n())
# One function, many variable using group_by function#gives mean mpg and mean disp 
summarise(group_by(mtcars,cyl), mean_mpg=mean(mpg), mean_disp=mean(disp))
# Many function, many variable using group_by function
summarise(group_by(mtcars,cyl), count_cyl=n(), mean_mpg=mean(mpg), max_disp=max(disp))

# Use of summarise_each function
summarise_each(group_by(mtcars,cyl),funs(min, max, mean),mpg,disp)

# Calculate the number of persons injured by borough using summarise
summarise(group_by(nydata,BOROUGH), count= sum(NUMBER.OF.PERSONS.INJURED, na.rm = TRUE))
#WE CAN ONLY DECIDE TO REMOVE BOROUGH IS NA AND NO OF PERSON INJURED 0 AND NO OF PERSONS KILLED 0
#HW 2 ANSWERS ALL QSTNS USING SUMMARISE

# Merging dataframes--------------------------
one <- mtcars[1:4, ]
two <- mtcars[11:14, ]
df3<-bind_rows(one, two)
# Alternative: df3<-rbind(one,two)
df3<-bind_cols(one, two)
# Alternative: df3<-cbind(one,two) #to avoid conflict, r itself changes names of cols

colnames(publishers)<- c("publisher","yr_founded")
# inner_join(x, y): Return all rows from x where there are matching values in y, 
#and all columns from x and y. If there are multiple matches between x and y, 
#all combination of the matches are returned. 
# This is a mutating join.
ljsp <- left_join(superheroes, publishers)


# inner_join(x, y): Return all rows from x where there are matching values in y, 
# and all columns from x and y. If there are multiple matches between x and y, 
# all combination of the matches are returned. 
# This is a mutating join.
ijps <- inner_join(publishers, superheroes)

# semi_join(x, y): Return all rows from x where there 
# are matching values in y, keeping just columns from x.
# A semi join differs from an inner join because an inner join will return 
# one row of x for each matching row of y, where a semi join will never duplicate rows of x. 
# This is a filtering join.
sjsp <- semi_join(superheroes, publishers)

# anti_join(x, y): Return all rows from x where there are not matching values in y, 
#keeping just columns from x. This is a filtering join.
ajps <- anti_join(publishers, superheroes)

# full_join(x, y): Return all rows and all columns from both x and y. 
#Where there are not matching values, returns NA for the one missing. 
#This is a mutating join.
fjsp <- full_join(superheroes, publishers)


# Pipe operator for claen code
library(magrittr)

nydata %>%
  group_by(BOROUGH)%>%
  summarise(sum_injured=sum(NUMBER.OF.PERSONS.INJURED, na.rm=TRUE)) %>%
  arrange(desc(sum_injured))
