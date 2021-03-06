
## Exploring the RandomFields package, primarily the RFsimulate 
## function and the Bi-Whittle Matern model (RMbiwm)

library(RandomFields)

quartz() # necessary to plot random fields realizations outside of rstudio

?RMbiwm
?RFsimulate


# Example from RMbiwm -----------------------------------------------------

## Example
RFoptions(seed = 0, height = 4) 
## *ANY* simulation will have the random seed 0; set
## RFoptions(seed=NA) to make them all random again

x <- y <- seq(-20, 20, 0.2)
model <- RMbiwm(nudiag=c(0.3, 2), nured=1, rhored=1, cdiag=c(1, 1.5),
                s=c(1, 1, 2))
plot(model)
plot(RFsimulate(model, x, y))


## Test
x <- y <- seq(-20, 20, 0.2)
model <- RMbiwm(nu = c(1.5, 1.5, 1.5), s = c(0.5, 0.5, 0.5), cdiag = c(1, 1),
              rhored = 0.8) 
plot(model)
plot(RFsimulate(model, x, y))




# Example from RFsimulate -------------------------------------------------

## ?RMsimulate.more.examples ##
## ?RFsimulateAdvanced ##
## for more examples ##

#############################################################
## ##
## Unconditional simulation ##
## ##
#############################################################
## first let us look at the list of implemented models
# RFgetModelNames(type="positive definite", domain="single variable",
#                iso="isotropic")
## our choice is the exponential model;
## the model includes nugget effect and the mean:
model <- RMexp(var=5, scale=10) + # with variance 4 and scale 10
  RMnugget(var=1) + # nugget
  RMtrend(mean=0.5) # and mean
## define the locations:
from <- 0
to <- 20
x.seq <- seq(from, to, length=200)
y.seq <- seq(from, to, length=200)
simu <- RFsimulate(model, x=x.seq, y=y.seq)
plot(simu)


#############################################################
## ##
## Conditional simulation ##
## ##

## NOTE: We are not concerned with condition simulation in
## this project

#############################################################
# first we simulate some random values at a
# 100 random locations:
n <- 100
x <- runif(n=n, min=-1, max=1)
y <- runif(n=n, min=-1, max=1)
data <- RFsimulate(model = RMexp(), x=x, y=y, grid=FALSE)
plot(data)
# let simulate a field conditional on the above data
x.seq.cond <- y.seq.cond <- seq(-1.5, 1.5, length=n)

model <- RMexp()
cond <- RFsimulate(model, x=x.seq.cond, y=y.seq.cond, data=data)
plot(cond, data)



# Examples from paper ------------------------------------------------------

RFoptions(seed = 0, height = 4)
M1 <- c(0.9, 0.6)
M2 <- c(sqrt(0.19), 0.8)
model <- RMmatrix(M = M1, RMwhittle(nu = 0.3)) + 
  RMmatrix(M = M2, RMwhittle(nu = 2))
x <- y <- seq(-10, 10, 0.2)
simu <- RFsimulate(model, x, y)
plot(simu)



# Weather data example from Schlather2015 ----------------------------------------------------

data('weather')
Dist.mat <- as.vector(RFearth2dist(weather[, 3:4]))


              