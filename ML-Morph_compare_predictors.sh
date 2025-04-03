#!/bin/bash
#SBATCH --job-name="Lake_Constance_compare_predictors"
#SBATCH --cpus-per-task=3	
#SBATCH --time=2:00:00
#SBATCH --mem-per-cpu=8GB
#SBATCH --output=Predict_Compare.out
#SBATCH --error=Predict_Compare.err

cd /storage/homefs/jr22y334/Practical2025/Lake_Constance_tributaries/

source venv-ml/bin/activate
module load CUDA
module load Python

find . -name "*.dat" -exec bash -c 'echo "Processing: {}"; python3 ml-morph/simple-ml-morph/shape_tester.py -t test.xml -p "{}"' \;