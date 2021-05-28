# This script takes all of the files of a certain pattern in a directory,
# extracts columns, and combines them into a single table
library(dplyr)
# Set your working directory here
setwd("C:/Users/tyson/OneDrive/Desktop/Alzheimers/PRJNA670209/tsvFiles")
# Specify the pattern of file names you want to match here
listOfFiles=list.files(pattern="telescope.*.tsv")
tableExists=FALSE
counter=1
for(x in listOfFiles){
  # Clean up file names
  fileName=str_remove_all(x,"-directory_telescope-telescope_report.tsv")
  fileName=str_remove_all(fileName,"telescope-")
  #These files have a comment as the first line which we will skip
  thisAbundance=read.delim(x,skip=1)
  # Here we want to save "transcript" as the row name
  row.names(thisAbundance)=thisAbundance$transcript
  # We are interested in the third column
  thisAbundance=as.data.frame(thisAbundance[,3], row.names=row.names(thisAbundance))
  # This is the name of the value in the third column
  colnames(thisAbundance)="final_count"
  # If we have already gone through the loop and initated the table
  if(tableExists){
    combinedTable=full_join(tibble::rownames_to_column(combinedTable),
                            tibble::rownames_to_column(thisAbundance),
                            by = "rowname")
    combinedTable=as.data.frame(combinedTable[,2:(counter+1)],
                                row.names=combinedTable$rowname)
    colnames(combinedTable)[counter]=fileName
  }else{ # Otherwise we make a table from scratch
    combinedTable=as.data.frame(thisAbundance$final_count, row.names = row.names(thisAbundance))
    colnames(combinedTable)=fileName
    tableExists=TRUE
  }
  counter=counter+1
}
# And finally we save the file
write.csv(combinedTable,"PRJNA670209_HERV_Counts.csv",row.names = TRUE,quote=FALSE)
