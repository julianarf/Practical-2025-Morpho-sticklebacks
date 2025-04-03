#########
#Here you need to set your working directory where you have the folder with the images
#This folder should have images ONLY!
setwd("C://Users//julia//OneDrive - Universitaet Bern//PhD//Teaching/Practical Course 2025")

files <-list.files("C://Users//julia//OneDrive - Universitaet Bern//PhD//Teaching/Practical Course 2025/allPhotographs/") 

#Get a sample of size n from the images you have in the folder. For example here you are getting a sample of size 100
sample_images <- sample(files, 100)

#main directory is the folder where all of the pictures are
main_directory <- "C://Users//julia//OneDrive - Universitaet Bern//PhD//Teaching/Practical Course 2025/allPhotographs"
#training directory is an EMPTY folder where the images you will annotate go
training_directory <- "C://Users//julia//OneDrive - Universitaet Bern//PhD//Teaching/Practical Course 2025/training_directory"

#For-loop to copy the images from the main folder to the training folder
for(i in 1:length(sample_images){
  file.copy(from = paste(main_directory,images_to_annotate[i],sep="/"),
            to = paste(training_directory,images_to_annotate[i],sep="/"))
}
