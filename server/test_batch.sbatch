#!/bin/bash
#SBATCH -p normal 
#SBATCH --job-name=test_run 
#SBATCH --error=test.err 
#SBATCH --output=test_output.out 

echo "HELLO FROM FARMSHARE"

git pull https://github.com/higginsbrian/Stanford-Econ-Python-Public/
cd /home/higginsb/Stanford-Econ-Python-Public

module load matlab
matlab -nodisplay -nosplash -nodesktop < server/test_matlab.m > test_output_matlab.txt

module load stata-mp
stata-mp < server/test_stata.do > test_output_stata.txt
