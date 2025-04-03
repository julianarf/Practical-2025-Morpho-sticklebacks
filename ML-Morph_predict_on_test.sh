#!/bin/bash
#SBATCH --job-name="Lake_Constance_test_predictor"
#SBATCH --cpus-per-task=3
#SBATCH --time=24:00:00
#SBATCH --mem-per-cpu=8GB
#SBATCH --output=Predict_test.out
#SBATCH --error=Predict_test.err

cd /storage/homefs/jr22y334/Practical2025/Lake_Constance_tributaries/
ml_morph_folder=/storage/homefs/jr22y334/Practical2025/Lake_Constance_tributaries/ml-morph/simple-ml-morph
working_folder=/storage/homefs/jr22y334/Practical2025/Lake_Constance_tributaries/

source venv-ml/bin/activate
module load CUDA
module load Python

#PART 3
#Let's use this on the test images to test our model!
#echo "Starting part three: testing on a new set of images and creating a new xml"
#this is an example but here you need to use the .dat that worked the best!
python3 ${ml_morph_folder}/prediction.py -i test -p ${working_folder}/predictor_cas_35_dp_2_os_300.dat