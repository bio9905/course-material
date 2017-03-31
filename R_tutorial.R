###############################
#Tutorial Goals			        #
###############################
#Get an OTU-table into R. Which are the dimensions?
#Obtain the number of reads per sample
#Subsample the OTU table to a chosen value. Why did you choose that
#value?
#Produce collector curves
#Fit data to different rank-abundance models, including Preston
#Generate a NMDS. Do you see any specific clustering?
#Generate a UPGMA. Do results agree with NMDS?
#Generate a DCA and compare with previous results



#tell R where you want to work
#you will need to specify where you have downloaded the data on your own computer!
setwd("C:/Users/marieda/Downloads/BBMO_OSLOcourse_2ry")

#tell R which packages you would like to load
library(vegan)
library(ggplot2)
library(grid)
library(MASS)
library(scales)
library(reshape)

###############################
#Read Data Files			        #
###############################
#use the read.table command to read the file otu_table99.txt into R
#the option header=T tells us the first row is the column names
#the option row.names=1 tells us the first column is the row names
table=read.table("otu_table99.txt",header=T,row.names=1)

#use the read.table command to read the file  Blanes_Env_param_two_years.tsv into R
#call the object enviro instead of 'table' this time
#write your own command!  if you struggle, the answer is at the bottom of this file
#this table is environmental parameters for each of the samples


##############################
#Basic Summary Data
##############################
#let's use row.names to get a list of our OTU names
otu.names=row.names(table)
#now use rowSums to find out how many sequences are in each OTU
otu.sums=rowSums(table)
#lets put those together into a table we can look at using cbind
otu.info=cbind(otu.names,otu.sums)
#and cleanup a little bit
rm(otu.names)
rm(otu.sums)

#write your own commands to get the basic info about each sample using the colnames and colSums commands


##########################
# Rarefaction Curves	 #
##########################

#plot a collector curve for each sample, step is the intervals to sample at
rarecurve(t(table),step=100,labels=FALSE)
#plot rarefaction curve for treatments, with different colours for lines
rarecurve(t(table),step=1000,col=c("blue","green"))

###############################
#Rarefying your Data		#
###############################

#we have samples with different numbers of sequences!
#let's use the rrarefy command from the vegan package to take a random sample of 10 000 reads from each sample
#vegan likes to see an OTU table with samples as rows and OTUs as columns...ours is flipped
#we'll use the t command nested inside rrarefy to flip the table
table.10000=rrarefy(t(table),sample=10000)

#write a command to check that the rarefaction worked! *hint, you'll need to use one of the sums commands above

#check if there are any OTUs that have disappeared (have a colsum of 0)
sum(colSums(table.10000)<1)
#let's get rid of those!
table.10000=table.10000[,colSums(table.10000)>0]

##########################
# Get richness estimates 
###########################
#use the estimateR command to compare the estimated species richness in each sample in our rarefied data

richness=estimateR(table.10000)

#lets use the radfit command to fit rank-abundance models to this data
rad.mod=radfit(table.10000)
#we can look at the plots using the plot command all you have to do is specify the object!
plot()

#these are the model summaries for each individual Sample
#write a command to run the radfit command on the column sums of table 
#this will let you see the summary model


#now try using the prestonfit command




####################
#Visualizations
#####################

#let's start with a gnmds
#the first thing we need is to calculate a pairwise distance matrix between samples
#use the vegdist command in the vegan package do this
dist=vegdist(table.10000,"bray")

#now use the distance matrix (dist) as the input for the monoMDS command
bray.nmds=monoMDS(dist)

#use the plot command to visualize the bray.nmds object you just created!
plot(bray.nmds$points,col=as.factor(enviro$Season))

#we have some counts of how many Micromonas algae are in the water and what the water temperature was
#let's fit that to our ordination
envfit=envfit(bray.nmds~enviro$Micromonas+enviro$Temp)
envfit
#looks like the Micromonas structures our data, let's add that to our ordination
plot(envfit(bray.nmds~enviro$Micromonas))

#now let's plot a DCA for comparison
#the DCA should be run on the OTU table
#use the decorana command from the vegan package
#make this into an object called dca


#now use the plot command to visualize the dca from the perspective of samples
plot(dca,display="sites")

#and from the perspective of OTUS
plot(dca,display="species")  
  
#now let's create a dendrogram of our samples using the hclust command
dendro=hclust(dist,"average")

#use the plot command to visualize





#####################
#the missing commands!
#####################

enviro<-read.table("Blanes_Env_param_two_years.tsv",header=TRUE,row.names=1)

sample.names=colnames(table)
sample.sums=colSums(table)
sample.info=cbind(sample.names,sample.sums)
rm(sample.names)
rm(sample.sums)

rad.mod.sum=radfit(colSums(table.10000))
plot(rad.mod.sum)
plot(bray.nmds)

plot(bray.nmds$points,col=as.factor(enviro$Season_real))
plot(bray.nmds$points,col=as.factor(enviro$Season_waterTemp))
text(bray.nmds$points,labels=enviro$Season_waterTemp)

dca=decorana(table.10000)
