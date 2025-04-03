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

