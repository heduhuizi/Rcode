library(spgwr)
library(sf)
library(spData)
library(sp) 
library(lattice)
library(ggplot2)
library(ggthemes)
library(GWmodel)


setwd("C:/Users/hdhz/Desktop/data/xianqv_zonal/zonal_mean/2023fq_gwr")

ES <- st_read(dsn = "C:/Users/hdhz/Desktop/data/xianqv_zonal/zonal_mean/2023fq_gwr", 
              layer = "2023fenqv_mean1")

bw.FP_HQ<-bw.gwr(FP~HQ,data = ES,approach = "CV")
#A function for automatic bandwidth selection to calibrate a basic GWR model

FP_HQ<-gwr.basic(FP~HQ,data=ES,bw=bw.FP_HQ)

gwr.write(FP_HQ,fn="2023FP_HQ2")


FP_HQ

