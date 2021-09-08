#!/bin/bash
#SBATCH -p normal 
#SBATCH -job-name=test_run 
#SBATCH -error=test_.err 
#SBATCH -output=test_output_.out 
#SBATCH -nodes=1 
#SBATCH -mail-type=ALL 

echo "HELLO FROM FARMSHARE"

git pull https://github.com/higginsbrian/Stanford-Econ-Python-Public/
cd ~/home/higginsb/Stanford-Econ-Python-Public/server

module load matlab
matlab -nodisplay -nosplash -nodesktop < server/test_matlab.m > test_output_matlab.txt

module load stata-mp
stata-mp < server/test_stata.do > test_output_stata.txt
