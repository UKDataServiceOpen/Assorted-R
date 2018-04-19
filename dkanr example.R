#Install the packages
install.packages("dkanr")
install.packages("dplyr")
install.packages("stringr")
install.packages("ggplot2")
#load the packages so that R knows they are there
library(stringr)
library(ggplot2)
library(dkanr)
library(dplyr)
#tell the dkanr package the url of our DKAN site
dkanr_setup(url="https://www.statistics.digitalresources.jisc.ac.uk/")

#load the settings
dkanr_settings()

#get a list of nodes that are of type dataset
nodes <- list_nodes_all(filters = c(type="dataset"))

#look at the data frame returned
nodes

#find datasets that have Age 2011 in the title
dfFilter<-nodes%>% select(nid,title) %>% filter(str_detect(nodes$title,fixed("sex 2011",ignore_case=TRUE)))

#look at the results
dfFilter
# I'm only interested in the dataset for sex 2011, so I'll ask for the metadata for node 195

metadata <-retrieve_node(nid =195, as ="list")

#I then want to know what resources node IDs dataset 195 has
get_resource_nids(metadata)


#for simplicity I'll look at the first resource
resource_metadata <-retrieve_node("196", as ="list")
resource_metadata



#as I want the csv file I'll ask for the url to that file
get_resource_url(resource_metadata)

#unfortunately for the version of the dkanr package I was using this command failed, but #looking through the source code for the package I worked out how to request the url (I've #raised this issue with the developers, so hopefully it will be fixed soon).
resource_uri=resource_metadata[["field_link_remote_file"]][["und"]][[1]][["uri"]]
resource_uri


#now I can read the data into R and view it
data <-read.csv(resource_uri,header=T)

str(data)



#I'm only interested in seeing the name of the area, the 2 data columns and rows 6:16, so #I've sub-setted the data
df2 <-data[6:16,c(2,6,7)]
df2


#I googled and used a package to reshape the data, called reshape2, as when I initially tried #to plot the data it wasn't working how I wanted it to look
library(reshape2)
df2melt <- melt(df2, id.vars = "GEO_LABEL")
# and then graphed the results
ggplot(df2melt, aes(x = GEO_LABEL, y = value, group =1, color=variable)) +
   theme_bw() +
   geom_line() +
   facet_wrap(~ variable)
