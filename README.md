# Mapping morphological traits to divergent chromosomal inversions in threespine sticklebacks 🐟

Code for runing analyses for projects 4 and 5 of the practical of the division of Evolutionary Ecology held during the spring semester 2025 

By now, you have collected the necessary data to start processing it. This means, that you have all the photographs and a subset of them have been annotated. If you are missing any of these steps, please finish those before following this. Here, you will learn how to execute the code from ML-morph to digitize landmarks automatically and some starting code to process the annotated data.

>*Before starting, please read the ML-morph [paper](https://besjournals.onlinelibrary.wiley.com/doi/full/10.1111/2041-210X.13373) and the [GitHub repository](https://github.com/agporto/ml-morph). I tried to make this comprehensible as posible but it doesn't include all the details mentioned there :shipit:*

## Using ML-morph to digitize landmarks automatically

For this part of the process you will need the following material:
1. Annotated data
   - Photographs
   - TPS file (includes the landkmarks associated to the photographs)
2. Bash scripts in the working directory of your project
>```bash
>ML-Morph_pre-processing.sh
>ML-Morph_Train_Predictors.sh
>ML-Morph_compare_predictors.sh
>ML-Morph_test_prediction.sh 
>```
3. A software to run a terminal emulator. I use [Xshell](https://www.netsarang.com/en/xshell/) as the emulator and [Xftp](https://www.netsarang.com/en/xftp-download/) to transfer files from the terminal to my personal computer.

### A prelude on how to use the command line and the cluster
> Here are a list of commands that you will need in the cluster terminal\
> \
> To change the **c**urrent **d**irectory
>```bash
> $ cd <path-to-dir>
>```
> To **p**rint the **w**orking **d**irectory
>```bash
>$ cd ~/Documents
>$ pwd
>/Users/username/Documents
>```
> To list the files and directories
>```bash
>$ ls
> Desktop    Downloads   Templates    index.html    Videos
>```
> with the option ```-l``` you can get the size, last modified-date and directory. This is really useful to know if your file got modified after you run a script
>```bash
> $ ls -l
>total 12
>-rw-r--r--. 1 root root   789 Feb 19 09:59 Desktop
>-rw-r--r--. 1 root root  6797 Aug 31 11:17 Downloads
>drwxr-xr-x. 2 root root  2354 Sep 31 12:48 Templates
>-rw-r--r--. 2 root root   123 Jun 31 23:48 index.html
>drwxr-xr-x. 4 root root  7896 Jul 16 22:55 Videos
> ```
> To see the output or content of a file you can use the command ```less```
>```bash
>$ less run-2022-12-12.log
>```
>To **r**e**m**ove files. Be **REALLY** careful using this command, you cannot recover removed documents nor folders after this is done!!!
>```bash
>$ rm index.html
>```
>To run a bash script in the terminal
>```bash
>$ sbatch script.sh
>```
>Check the state of your jobs
>```bash
>$ sacct
>```
>Cancel a job
>```bash
>$ scancel JobID
>```
>On more details on High Performance Computing of the university of Bern go [here](https://hpc-unibe-ch.github.io/)
### 1. Running your first models
After accesing the terminal, go to your working directory. You need to go to the Oyster Lagoon **OR** the Lake Constance tributaries folder depending on your project. For the sake of time, here is shown the process for the Lake Constance tributaries data but the process for the Oyster Lagoon should be the same.
```bash
$ cd Practical2025/Lake_Constance_tributaries/
```
Here, you can check the files that are contained in this directory
```bash
$ ls -l
total 19
drwxr-xr-x 3 jr22y334 iee 16384 Apr  1 13:54 annotated
drwxr-xr-x 9 jr22y334 iee  4096 Apr  1 13:40 ml-morph
-rw-r--r-- 1 jr22y334 iee   484 Apr  1 15:14 ML-Morph_compare_predictors.sh
-rw-r--r-- 1 jr22y334 iee   853 Apr  1 15:25 ML-Morph_test_prediction.sh
-rw-r--r-- 1 jr22y334 iee  1781 Apr  1 15:26 ML-Morph_Train_Predictors.sh
drwxr-xr-x 5 jr22y334 iee  4096 Apr  1 13:41 venv-ml
```
In the directory *annotated* you can find the photographs and its associated TPS file
```bash
$ cd annotated/
$ ls
photographs  training_with_150_images.tps
```
Go back to the "main directory" and from there you can run the first script. To do this you can use the command ```cd``` with two dots next to it, like this:
```bash
$ cd ..
```
#### a. Create test and train folders from already annotated data
The first step is called the *pre-processing* step where the a *test* and *train* folder are made from a user-designed image folder. To do this, you need to run the script *ML-Morph_pre-processing.sh*. 
Before jumping into running this script, let's see first what is contained here! 
##### <ins> Structure of a bash script </ins>
>This section was produced from the [Slurm quickstart](https://hpc-unibe-ch.github.io/runjobs/scheduled-jobs/slurm-quickstart/) information from the UBELIX custer of the University of Bern

Go and check the contect of a script by using the command ```less```
```bash
$ less ML-Morph_pre-processing.sh
#!/bin/bash
#SBATCH --job-name="Lake_Constance_pre-processing"
#SBATCH --cpus-per-task=1
#SBATCH --time=1:00:00
#SBATCH --mem-per-cpu=8GB
#SBATCH --output=Pre-processing_test.out
#SBATCH --error=Pre-processing_test.err

cd /storage/homefs/jr22y334/Practical2025/Lake_Constance_tributaries/
ml_morph_folder=/storage/homefs/jr22y334/Practical2025/Lake_Constance_tributaries/ml-morph/simple-ml-morph/
working_folder=/storage/homefs/jr22y334/Practical2025/Lake_Constance_tributaries/

source venv-ml/bin/activate
module load CUDA
module load Python

#PART 1

#We need to generate train and test folders 
echo "Starting part one: dividing and checking images"
python3 ${ml_morph_folder}/preprocessing.py -i ${working_folder}/annotated/photographs -t ${working_folder}/annotated/training_with_150_images.tps

ML-Morph_pre-processing.sh (END)
```
We will over what each line does a bit later, but now we will talk about details on bash scripts.
Here you see that the first line of code is ```#!/bin/bash```, which specifies that this file should be read as a bash script.
The lines starting with ```#SBATCH``` are directives for the workload manager. These have the general syntax
```bash
#SBATCH option_name=argument
```
For example, the first directive is 
```bash
#SBATCH --job-name=exampleJob
```
which sets the name of the job and allows the user to identify the job. After the directives, you will find the code that will be run in the terminal. For this example, first we are changing directory to the main directory where you will be working.
```bash
cd /storage/homefs/jr22y334/Practical2025/Lake_Constance_tributaries/
```
After this, we are creating variables for the main directory and the simple-ml-morph path. This is not *needed* but it is a really convinient way of not needing to write these paths over and over again.
```bash
ml_morph_folder=/storage/homefs/jr22y334/Practical2025/Lake_Constance_tributaries/ml-morph/simple-ml-morph/
working_folder=/storage/homefs/jr22y334/Practical2025/Lake_Constance_tributaries/
```
For this and the other scripts you will run, you need to activate a Python virtual environment and load the modules CUDA and Python. This will allow you to run Python scripts through the terminal. 
```bash
source venv-ml/bin/activate
module load CUDA
module load Python
```
Now, you are into the line of code where you are dividing the annotated data into train (80%) and test (20%) which will be used for the shape predictor models. To run the ml-morph python scripts ```.py``` use the command ```python3```. Here you use the argument ```-i``` to define the directory that contains the annotated images, and ```-t``` to define the TPS file associated to the annotates images.
```bash
python3 ${ml_morph_folder}/preprocessing.py -i ${working_folder}/annotated/photographs -t ${working_folder}/annotated/training_with_150_images.tps
```
Other arguments that can be included to this scripts can be found using the option ```-h```
```bash
$ python3 preprocessing.py -h
usage: preprocessing.py [-h] [-i] [-c] [-t]

options:
  -h, --help         show this help message and exit
  -i , --input-dir   input directory containing image files (default = images)
  -c , --csv-file    (optional) XY coordinate file in csv format
  -t , --tps-file    (optional) tps coordinate file
```
The script ```preprocessing.py``` creates a test and train directories with an associated ```.xml```. Besides this, you will found the warning and error messages and the output of the script in the files ```Pre-processing_test.err``` and ```Pre-processing_test.out``` respectively.\
To run this script, you need to submit a job in the cluster with the command ```sbatch```
```bash
$ sbatch ML-Morph_pre-processing.sh
sbatch: Partition set to "epyc2,bdw"
sbatch: QoS set to job_cpu
Submitted batch job 18590972
```
You can check the status of your job
```bash
$ sacct
JobID           JobName  Partition    Account  AllocCPUS      State ExitCode 
------------ ---------- ---------- ---------- ---------- ---------- -------- 
18591358     Lake_Cons+      epyc2     gratis          3    RUNNING      0:0 
18591358.ba+      batch                gratis          3    RUNNING      0:0 
18591358.ex+     extern                gratis          3    RUNNING      0:0 
```
Here you can see that your job is running. Another possible outputs are pending, completed or cancelled.
If you see that your job is completed in an unexpected amount of time check the error file, which should be a ".err" file. For example, in this case the path to the script *shape_trainer-py* was not found. This means you have to adjust your script, to avoid this error the next time you run the script.
```bash
$ less Predict_test.err
python3: can't open file '/storage/homefs/jr22y334/Practical2025/Lake_Constance_tributaries//preprocessing.py': [Errno 2] No such file or directory
python3: can't open file '/storage/homefs/jr22y334/Practical2025/Lake_Constance_tributaries//shape_trainer.py': [Errno 2] No such file or directory
python3: can't open file '/storage/homefs/jr22y334/Practical2025/Lake_Constance_tributaries//shape_trainer.py': [Errno 2] No such file or directory
python3: can't open file '/storage/homefs/jr22y334/Practical2025/Lake_Constance_tributaries//shape_trainer.py': [Errno 2] No such file or directory
python3: can't open file '/storage/homefs/jr22y334/Practical2025/Lake_Constance_tributaries//shape_trainer.py': [Errno 2] No such file or directory
python3: can't open file '/storage/homefs/jr22y334/Practical2025/Lake_Constance_tributaries//shape_trainer.py': [Errno 2] No such file or directory
sbatch: Partition set to "epyc2,bdw"
sbatch: QoS set to job_cpu
```
If everything worked well, you can check the directories ```test``` and ```train``` to see which images are in which directory. 

#### b. Training and testing shape predictors
Having now train and test data, you can train and test the shape predictors models using the script *ML-Morph_Train_predictors.sh*. Submit your job like and this should run for ca. 10 minutes.
```bash
$ sbatch ML-Morph_Train_predictors.sh
```
In the meantime, let's check what is done in this script. The first part consist on running different shape predictors with different parameters. Here you are varying the parameters three depth ```-dp``` and cascade depth ```-c```. For the function of these and other parameters please refer to the [ML-morph paper](https://besjournals.onlinelibrary.wiley.com/doi/full/10.1111/2041-210X.13373)
```bash
#PART 1
echo "Starting part one: testing and training shape prediction"
#Time to train and test the shape predictors with different parameters
python3 ${ml_morph_folder}/shape_trainer.py -d train.xml -t test.xml -th 12 -dp 1 -c 20  -nu 0.1 -os 300 -f 1200 -o predictor_cas_20_dp_1_os_300
python3 ${ml_morph_folder}/shape_trainer.py -d train.xml -t test.xml -th 12 -dp 1 -c 25  -nu 0.1 -os 300 -f 1200 -o predictor_cas_25_dp_1_os_300
python3 ${ml_morph_folder}/shape_trainer.py -d train.xml -t test.xml -th 12 -dp 1 -c 30  -nu 0.1 -os 300 -f 1200 -o predictor_cas_30_dp_2_os_300
python3 ${ml_morph_folder}/shape_trainer.py -d train.xml -t test.xml -th 12 -dp 2 -c 35  -nu 0.1 -os 300 -f 1200 -o predictor_cas_35_dp_2_os_300
python3 ${ml_morph_folder}/shape_trainer.py -d train.xml -t test.xml -th 12 -dp 2 -c 30  -nu 0.1 -os 300 -f 1200 -o predictor_cas_30_dp_2_os_300
```
In the second part, you will compare shape prediction models using the script ```ML-Morph_compare_predictors.sh```
```bash
#PART 2
echo "Starting part two: comparing shape prediction models"
sbatch ML-Morph_compare_predictors.sh
```
Here you will see which model has the lower average pixel deviation, which is calculated based on the difference between the manually annotated and predicted landmarks. The best model can be used for following step
#### c. Predicting landmarks in the test data
For this we run the bash script ```ML-Morph_predict_on_test.sh```. In here, the line of code that is being run consist on running ```prediction.py``` which takes the input directory, the test images, with the argument ```-i```and the trained shape predictor model with the argument ```-p```. 
```bash
python3 ${ml_morph_folder}/prediction.py -i test -p ${working_folder}/predictor_cas_20_dp_1_os_300.dat
```
In this example, the best predictor model was the one with a cascade depth of 20 and three depth of 1. <ins>Please, change this according to the results you obtained in part b of this section.</ins> 
This script will produce an ```output.tps``` file that you can visualize using *tpsDig*. 
### 2. Predicting the landmarks position in a new set of data
By now, you have a model that predicts landmarks well on the test data. If not, you will have to change parameters from section b of part 1 of this tutorial and repeat the process. When you are satisfied with this, you can come back here.\
To predict the landmarks position in a new set of data you need to use a similar script as ```ML-Morph_predict_on_test.sh```. However, instead of using the test folder as the input data, you will use the images that have not been digitized yet. In this section, you are expected to write your own bash script to do this step. The script should be named ```ML-Morph_predict_on_new_images.sh```. Get inspiration from ```ML-Morph_predict_on_test.sh``` and other scripts used until here to write your own one!\
Try submitting your script to the cluster and see the result. No worries if it doesn't run in the first time, we can go through it together but first try it on your own. 

## Analyzing landmark data
If you have reached this stage, congratulations! :confetti_ball: :confetti_ball: :confetti_ball:	
For the rest of this tutorial we are moving to R and you will need the following material:
1. Inndividual data that includes genotype, sex and other variables depending on the project. You can find this on ILIAS.
2. A TPS file that contains the predicted landmarks for all invididuals in your dataset.
3. R. I personally like to run it on [RStudio](https://posit.co/download/rstudio-desktop/) but you can run it directly in R.

For the following parts, there is no set code already written. In this tutorial you will learn about a couple of commands that will be particularly useful to analyze your data but it is your turn to write the code. Please try to annotate your code as thoroughly as possible, it can be a bit annoying sometimes but it is a great practice for what you might thank yourself in the future.

### Handling TPS files
To handle TPS file easily you can use the package ```geomorph``` which you can install with:
```r
install.packages("geomorph")
```
To read landmark data from TPS file use the function ```readland.tps()```
```r
readland.tps(
  file,
  specID = c("None", "ID", "imageID"),
  negNA = FALSE,
  readcurves = FALSE,
  warnmsg = TRUE
)
```
If you have more than one TPS file to read you can use the function ```readmulti.tps()``` instead. In both scenarios, it is important that you specify ```specID = "imageID"```. The reason behind this, is that your file names are your IDs, so like this we can match a fish ID with a set of landmarks.

To measure the distances between landmarks use the function ```interlmkdist()``` as described in the example of the help section
```r
data(plethodon)
# Make a matrix defining three interlandmark distances 
lmks <- matrix(c(8,9,6,12,4,2), ncol=2, byrow=TRUE, 
dimnames = list(c("eyeW", "headL", "mouthL"),c("start", "end")))

# where 8-9 is eye width; 6-12 is head length; 4-2 is mouth length
# or alternatively

lmks <- data.frame(eyeW = c(8,9), headL = c(6,12), mouthL = c(4,2), 
row.names = c("start", "end")) 

A <- plethodon$land
lineardists <- interlmkdist(A, lmks)
```
In your case, the matrix you have to create should represent the 18 interlandmark distances described here.
| Trait ID | Trait name                     | LM1 | LM2 | Function              |
|----------|--------------------------------|-----|-----|-----------------------|
| 1        | Standard length               | 1   | 16  | Size                  |
| 2        | Mouth length                  | 2   | 26  | Feeding               |
| 3        | Jaw length                    | 1   | 24  | Feeding               |
| 4        | Snout length                  | 1   | 5   | Feeding               |
| 5        | Epaxial muscle height         | 28  | 29  | Feeding, Swimming     |
| 6        | Head length upper             | 1   | 8   | Feeding               |
| 7        | Buccal length                 | 23  | 24  | Feeding               |
| 8        | Eye diameter (horizontal)     | 5   | 6   | Vision                |
| 9        | Eye diameter (vertical)       | 4   | 7   | Vision                |
| 10       | Pelvic spine length           | 20  | 21  | Defense               |
| 11       | Dorsal spine length first     | 9   | 10  | Defense               |
| 12       | Dorsal spine length second    | 11  | 12  | Defense               |
| 13       | Dorsal fin length             | 13  | 14  | Swimming              |
| 14       | Peduncle length upper         | 14  | 15  | Swimming              |
| 15       | Peduncle length lower         | 17  | 18  | Swimming              |
| 16       | Anal fin length               | 18  | 19  | Swimming              |
| 17       | Anterior body depth           | 8   | 23  | Swimming              |
| 18       | Posterior body depth          | 9   | 22  | Swimming              |


