#This R code will give a brief introduction on how you can use R to
#fit distributions to data. This is useful for probabilistic sensitivity
#analysis. There are two main methods for fitting distributions
#depending on your data.

#If you have a dataset then fitdistrplus lets you fit different
#distributions using maximum likelihood estimation and reports measures
#of fit

#If your data is more limited, for example you only have a mean and
#confidence intervals from a published study, you can use
#rriskdistributions to try and find the most likely distribution which
#created that data. It should be noted that this is an approximation
#and there are lots of combinations of data the produce the same
#centiles and mean

#Set your directory
setwd("")

#Install required packages
install.packages("fitdistrplus")
install.packages("rriskDistributions")

#Run the packages
library("fitdistrplus")
library("rriskDistributions")

#Lets look at where we have some data first
#We'll begin with some very minimal expert elicitation I have done as 
#a part of a study. I have readings from two people for various
#variables and want to turn them into distributions.

#The first variable is how long it takes to manually send a breast scan
#if the automated system fails. One person said 5-10 minutes and the other 5 mins
#Lets take the mid-point of the first range (7.5) and assume the time
#is normally distributed (more likely Gamma or log-normal but harder
#to estimate these with two observation)

#First lets create a vector called imagefail with those observations in
imagefail<-c(7.5,5)

#Then lets ask fitdistrplus to fit a normal distribution (we could do
#this pretty easily ourselves). Here we use the fitdist function and
#give it two arguments 1) the vector of observations and 2) a short
#name of the distribution to be estimated
fitdist(imagefail,"norm")

#The output will give you the parameters of the distribution

#Now consider the probability of the image transfer failing. We tend
#to use beta distribution for probabilities. We have observations of
#25% and 40%
failure<-c(0.25,0.4)
fitdist(failure,"beta")

#We can of course use bigger data sets. Lets look at the number of 
#breast screens offered by every trust in the UK. This sheet just
#has the numbers not the trusts
numscreens<-(data.frame(read.csv("Mobile vans cost.csv")))

#Lets see what the data looks like
plot(density(numscreens[,1]))

#Maybe a couple of distributions mixed in but we could try gamma, log
#normal and normal just for an illustration

#Lets start with the normal
#note that we're going to save it as an object so we can play
#around with the results
normscreen<-fitdist(numscreens[,1],"norm")

#lets check the fit (AIC/BIC stats)
summary(normscreen)

#What does the distribution look like vs the data?
#hmm not great
denscomp(list(normscreen))

#Lets try gamma
gammascreen<-fitdist(numscreens[,1],"gamma")
summary(gammascreen)     
denscomp(list(normscreen,gammascreen))
#Ok, thats a bit better and the AIC and BIC are better too

#What about the log-normal?
lnormscreen<-fitdist(numscreens[,1],"lnorm")
summary(lnormscreen)
denscomp(list(normscreen,gammascreen,lnormscreen))
#Still not perfect but the best of these three


#Fitting data when you have a mean and confidence intervals
#Its nice to have real data but sometimes we might have used
#published estimates in our model and we need to try and
#work out how to characterise the distribution. For this we
#can use rriskdistributions to approximate the distributions

#Lets say we have a parameter we think is normally distributed
#with mean 7.5 and CIs of 5 and 10.
#We can use the get.norm.par function with arguments p= 
#a vector of centiles (we assume they use CIs at 0.05 
#significance and 2 tails) and q= the vector of values for 
#those centiles. I.e. here the 2.5th centile (lower CI) has
#a value of 5, the median (0.5) a value of 7.5, and 97.5th 
#centile a value of 10
get.norm.par(p=c(0.025,0.5,0.975),q=c(5,7.5,10))

