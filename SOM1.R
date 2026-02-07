install.packages("kohonen")
library(kohonen)

# file setting
setwd("C:/Users/hdhz/Desktop/data/som")

#county scale input data
data<-read.csv("2003fenqv.csv",header=T)

#data pre-processing
str(data)
X<-scale(data[,-1])
summary(X)

# SOM
set.seed(2023)

g<-somgrid(xdim=2,ydim=3,topo="rectangular")


map<-som(X,grid=g,radius=1)


# map results
plot(map, type="counts")
plot(map, type="codes")

#output results
map$codes

map$unit.classif

output<-cbind(data,map$unit.classif)

write.table(output,file="BundleResultsSOM111.csv",sep = ",",row.names=FALSE)




