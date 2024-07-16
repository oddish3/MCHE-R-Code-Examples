#Here's an intro into some of the key things you need to know about R
#Firstly you can make comments if you start a line with #
#These won't run in the code

#You can do basic calculations
2+4
25^7
9*(7/3)

#You can create variables and assign values to them with <- or =
utilitystable=0.86
utilitystable<-0.77 #Note, this will overwrite the above value
sayhi<-"Hello" #We can also use text in objects using speech marks
#You can ask R to display the value of an object
print(sayhi)

#We can assign a list of values to an object
#This is called a vector. We have to use c() for our list.This means concatenate
utility<-c(1,0.86,0.55,0)
print(utility)
#Sometimes its useful to name stuff to make it easier to interpret
names(utility)<-c("Healthy","Stable","Severe","Dead")
print(utility)

#We can call specific elements of the vector by using square brackets
utility[3]
utility["Severe"]

#We can do mathematical operations on whole vectors
monthlyutility<-utility/12
print(monthlyutility)

#Or specific elements in the vector. Lets reduce healthy to 0.95
utility["Healthy"]<-0.95
print(utility) #Note we'd have to rerun our monthly utility calculation above (Order is important!)

#We can also use data frames. These are essentially tables or a collection of vectors
table<-data.frame(1:10,1:10) #Creates a data frame with 2 columns filled with numbers 1 to 10
print(table)

#We can call specific elements in the table but now need two co-ordinates [row number,column number]
table[4,2]

#We can use data in data.frames in regression
#Lets make some fake data
table<-data.frame(rnorm(100,5,2),c(1:1))
table[,2]<-(table[,1]*2)+(rnorm(100,0,2)) #Column 2 is 2*column 1 plus/minus some randomness
print(table)

#What does that look like on a scatter plot?
plot(table[,1],table[,2],xlab="Column 1",ylab="Column 2")

#col="red"
#xlim=c(-5,15)

#How do oyu do an OLS regression of column 2 as a function of column 1?
model<-lm(table[,2]~table[,1]) #lm = linear model
summary(model) #Should give a coefficient which is roughly 2

#Can I add a line of best fit using those results to the graph?
coefficients<-model[1] #Our model object has lots of output elements, the coefficients are in element 1
print(coefficients) #This looks like a vector but is something called a list, we need to turn it into a vector to get each coefficient
coefficients<-unlist(coefficients)
print(coefficients) #This is now a vector so we can get the intercept and B1

plot(table[,1],table[,2],xlab="Column 1",ylab="Column 2")
abline(a=coefficients[1],b=coefficients[2],col="red")

#Or we can also use just use abline(coef=coefficients)
#You can also use abline to put in lines at y=0 and x=0 
#Useful if the graph is scaled in a funny way like in a cost-effectiveness plane
#We can see that the basic R plot function is pretty good but 
#many people use ggplot2 which is more extensive