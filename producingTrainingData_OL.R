#########
#Here you need to set your working directory where you have the folder with the images
setwd("C://Users//julia//OneDrive - Universitaet Bern//PhD//Teaching/Practical Course 2025")

files <-list.files("C://Users//julia//OneDrive - Universitaet Bern//PhD//Teaching/Practical Course 2025/allPhotographs_OL/") 

images_to_annotate <- sample(files, 100)

#main directory is the folder where all of the pictures are
main_directory <- "C://Users//julia//OneDrive - Universitaet Bern//PhD//Teaching/Practical Course 2025/allPhotographs_OL"
#training directory is an EMPTY folder where the images you will annotate go
training_directory_Est <- "C://Users//julia//OneDrive - Universitaet Bern//PhD//Teaching/Practical Course 2025/training_OL_Est"
training_directory_Qingdong <- "C://Users//julia//OneDrive - Universitaet Bern//PhD//Teaching/Practical Course 2025/training_OL_Qingdong"

for(i in 1:50){
  file.copy(from = paste(main_directory,images_to_annotate[i],sep="/"),
            to = paste(training_directory_Est,images_to_annotate[i],sep="/"))
}

for(i in 51:100){
  file.copy(from = paste(main_directory,images_to_annotate[i],sep="/"),
            to = paste(training_directory_Qingdong,images_to_annotate[i],sep="/"))
}
