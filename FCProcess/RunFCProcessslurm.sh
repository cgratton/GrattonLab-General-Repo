#!/bin/bash 
#SBATCH -A b1081
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 15:00:00 
#SBATCH -p b1081
#SBATCH --mem=0G
#SBATCH --job-name="FCTest_BMAPD"
#SBATCH --mail-type=ALL
#SBATCH --mail-user=briankraus2024@u.northwestern.edu
#SBATCH -o "%x.o%j"

## set your working directory 
cd $PBS_O_WORKDIR 

## job commands; <matlabscript> is your MATLAB .m file, specified without the .m extension
module load matlab/r2016a
matlab -nosplash -nodesktop -singleCompThread -r FCProcess_Test_BrainMAPD
