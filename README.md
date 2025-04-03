# Mapping morphological traits to divergent chromosomal inversions in threespine sticklebacks

Code for runing analyses for projects 4 and 5 of the practical of the division of Evolutionary Ecology held during the spring semester 2025

By now, you have collected the necessary data to start processing it. This means, that you have all the photographs and a subset of them have been annotated. If you are missing any of these steps, please finish those before following this. Here, you will learn how to execute the code from ML-morph to digitize landmarks automatically and some starting code to process the annotated data.

## Using ML-morph to digitize landmarks automatically

For this part of the process you will need the following material:
1. Annotated data
   - Photographs
   - TPS file (includes the landkmarks associated to the photographs)
2. Bash scripts in the working directory of your project
>```bash
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
#### Create test and train folders from already annotated data
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

#We need to generate train and test folders  but KEEP .TPS FILES APART, AND LABEL THE EXTENSION AS ALL CAPS
echo "Starting part one: dividing and checking images"
python3 ${ml_morph_folder}/preprocessing.py -i ${working_folder}/annotated/photographs -t ${working_folder}/annotated/training_with_150_images.tps

ML-Morph_pre-processing.sh (END)
```
Here you see that the first line of code is ```#!/bin/bash```, which specifies that this file should be read as a bash script.
The lines starting with ```#SBATCH are directives for the workload manager. These have the general syntax
```bash
#SBATCH option_name=argument
```
For example, the first directive is 
```bash
#SBATCH --job-name=exampleJob
```
which sets the name of the job and allows the user to identify the job
Run the script *ML-Morph_Train_predictors.sh*
```bash
$ sbatch ML-Morph_Train_predictors.sh
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
If you see that your job is completed in an unexpected amount of time check the error file, which should be called "Predict_test.err". For example, in this case the path to the script *shape_trainer-py* was not found. This means you have to adjust your script, to avoid this error tne next time you run the script.
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


