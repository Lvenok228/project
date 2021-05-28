setwd ("~/Desktop/dataset")  #setting up the path with used files
install.packages('tidyverse')   #package downloading
install.packages('ggplot2')
install.packages('readr')
library("tidyverse")   #connecting libraries
library ("dplyr")
library("ggplot2")
library("readr")
pca <- read_table2("./pca.txt")   #read the data into the variable (table)
eigenval <- scan("./pca.eigenval")  #read eigenvals into the list/vector
pca <- pca[,-22]  #choosing the whole table without 22nd column
# set names
# set names
names(pca)[1] <- "ind"  #changing the name of first column with "ind"
names(pca)[2:ncol(pca)] <- paste0("PC", 1:(ncol(pca)-1))  #put names PC1,.. using paste (concatenates strings)
# sort out the individual species and pops
# spp should add population names
spp <- rep(NA, length(pca$ind)) #copy NA (missing values) to spp 20 times - creating a column with unknown values
#changing names for known populations
spp[grep("YRI", pca$ind)] <- "Yoruba"
spp[grep("IBS", pca$ind)] <- "Iberian"
spp[grep("CHS", pca$ind)] <- "Chinese"
spp[grep("PUR", pca$ind)] <- "Puerto Ricans"
spp[grep("CEU", pca$ind)] <- "Utah residents"
spp[grep("GBR", pca$ind)] <- "British"
spp[grep("CDX", pca$ind)] <- "Chinese Dai"
spp[grep("CLM", pca$ind)] <- "Colombians"
spp[grep("FIN", pca$ind)] <- "Finnish"
spp[grep("ACB", pca$ind)] <- "African Caribbeans"
spp[grep("PEL", pca$ind)] <- "Peruvians"

#should add population location
loc <- rep(NA, length(pca$ind))   #creating column with unknown values
#changing locations of known populations
loc[grep("YRI", pca$ind)] <- "Nigeria"
loc[grep("IBS", pca$ind)] <- "Peninsula"
loc[grep("CHS", pca$ind)] <- "Southern Han"
loc[grep("PUR", pca$ind)] <- "Puerto Rico"
loc[grep("CEU", pca$ind)] <- "Utah"
loc[grep("GBR", pca$ind)] <- "England"
loc[grep("CDX", pca$ind)] <- "Xishuangbanna"
loc[grep("CLM", pca$ind)] <- "Medellín"
loc[grep("FIN", pca$ind)] <- "Finland"
loc[grep("ACB", pca$ind)] <- "Barbados"
loc[grep("PEL", pca$ind)] <- "Lima"

spp_loc <- paste0(spp, "_", loc)  #create column "Population_location"

pca <- as_tibble(data.frame(pca, spp, loc, spp_loc))  #adding created columns to our data table

#creating table with percentage proportion of eigenvals (groups with four values)
pve <- data.frame(PC = 1:4, pve = eigenval/sum(eigenval)*100)

a <- ggplot(pve, aes(PC, pve)) + geom_bar(stat = "identity") #variable consists of rectangles (histogram)
a + ylab("Percentage variance explained") + theme_light() #adding label for y axis and making white background
cumsum(pve$pve) #cumulative sum (vector has length of pve$pve and each element with index i = sum(pve$pve[1:i]) )


# plot pca
#create ggplot, colored due to spp column, point size = 2, points' shapes changes, theme is white, axes are named
b <- ggplot(pca, aes(PC1, PC2, color = spp)) + geom_point(size=2) + scale_shape_manual(values=seq(0,20)) + coord_cartesian()
b <- b + scale_colour_manual(values = c("red", "blue", "yellow", "green", "black", "purple", "orange", "brown", "pink", "goldenrod", "salmon", "orchid", "navy"))
b <- b + coord_cartesian() + theme_light()
b + xlab(paste0("PC1")) + ylab(paste0("PC2"))
