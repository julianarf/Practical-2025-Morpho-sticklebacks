#!/bin/bash
#SBATCH --job-name="Lake_Constance_train_predictors"
#SBATCH --cpus-per-task=3
#SBATCH --time=24:00:00
#SBATCH --mem-per-cpu=8GB
#SBATCH --output=Predict_test.out
#SBATCH --error=Predict_test.err

cd /storage/homefs/jr22y334/Practical2025/Lake_Constance_tributaries/
ml_morph_folder=/storage/homefs/jr22y334/Practical2025/Lake_Constance_tributaries/ml-morph/simple-ml-morph/

source venv-ml/bin/activate
module load CUDA
module load Python

#Testing and training shape prediction
#PART 1
echo "Starting part one: testing and training shape prediction"
#Time to train and test the shape predictors with different parameters
python3 ${ml_morph_folder}/shape_trainer.py -d train.xml -t test.xml -th 12 -dp 1 -c 20  -nu 0.1 -os 300 -f 1200 -o predictor_cas_20_dp_1_os_300
python3 ${ml_morph_folder}/shape_trainer.py -d train.xml -t test.xml -th 12 -dp 1 -c 25  -nu 0.1 -os 300 -f 1200 -o predictor_cas_25_dp_1_os_300
python3 ${ml_morph_folder}/shape_trainer.py -d train.xml -t test.xml -th 12 -dp 1 -c 30  -nu 0.1 -os 300 -f 1200 -o predictor_cas_30_dp_2_os_300
python3 ${ml_morph_folder}/shape_trainer.py -d train.xml -t test.xml -th 12 -dp 2 -c 35  -nu 0.1 -os 300 -f 1200 -o predictor_cas_35_dp_2_os_300
python3 ${ml_morph_folder}/shape_trainer.py -d train.xml -t test.xml -th 12 -dp 2 -c 30  -nu 0.1 -os 300 -f 1200 -o predictor_cas_30_dp_2_os_300

#PART 2
echo "Starting part two: comparing shape prediction models"
sbatch ML-Morph_compare_predictors.sh
