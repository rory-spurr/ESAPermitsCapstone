# Making Time Series Infographics Prelim Prod
# Alana Santana and Rory Spurr
#=============================================================
#Reading in packages
library(shiny)
library(ggplot2)
library(sf)
library(dplyr)
library(tidyverse)
library(leaflet)
library(NMFSResPermits)
sf_use_s2(FALSE)
#==============================================================
#Sourcing Script
#setwd("~/GitHub/ESA_Permits_Capstone")
source(paste(getwd(), "/code/dependencies/Reading and Filtering 2.R", sep = ""))
#==============================================================
#Creating prelim plot - LifeStage across all species/production over time
ggplot(data = df, aes(x=Year, y= AuthTake, fill = LifeStage))+
  geom_bar(stat = "identity",
           position = "dodge") # How do I know if it is aggregating correctly?

ggplot(data = df, aes(x=Year, y= TotalMorts, fill = LifeStage))+
  geom_bar(stat = "identity",
           position = "dodge")
#==============================================================
#Creating prelim plot - ESU across all LifeStages/production over time
ggplot(data = df, aes(x=Year, y= AuthTake, fill = ESU))+
  geom_bar(stat = "identity",
           position = "dodge")
ggplot(data = df, aes(x=Year, y= TotalMorts, fill = ESU))+
  geom_bar(stat = "identity",
           position = "dodge")
#==============================================================
#Creating prelim plot - Production across all species/lifestages over time
ggplot(data = df, aes(x=Year, y= AuthTake, fill = Production))+
  geom_bar(stat = "identity",
           position = "dodge")
ggplot(data = df, aes(x=Year, y= TotalMorts, fill = Production))+
  geom_bar(stat = "identity",
           position = "dodge")