#!/bin/bash
#SBATCH -p normal 
#SBATCH -job-name=test_run 
#SBATCH -error=test_%j.err 
#SBATCH -output=test_output_%j.out 
#SBATCH -nodes=1 
#SBATCH -mail-type=ALL 

echo "HELLO FROM FARMSHARE"
cd ~/home/higginsb/server

module load matlab
matlab -nodisplay -nosplash -nodesktop < server/test_matlab.m > test_output_matlab.txt

module load stata-mp
stata-mp < server/test_stata.do > test_output_stata.txt
