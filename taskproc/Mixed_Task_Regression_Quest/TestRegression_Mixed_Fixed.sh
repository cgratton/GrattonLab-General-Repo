#!/bin/bash

#SBATCH -A b1081

#SBATCH -N 1

#SBATCH -n 28

#SBATCH --mem=0

#SBATCH -t 48:00:00

#SBATCH -p b1081

#SBATCH --job-name="INET003_RegressionTest_Mixed_Bind"

#SBATCH --mail-type=ALL

#SBATCH --mail-user=derek.smith1@northwestern.edu

#SBATCH -o "%x.o%j"


## set your working directory, open sig, job commands

cd /projects/b1081/singularity_images

module load singularity/latest


singularity exec -B /projects/b1081/member_directories/dmsmith/Analysis_Test/Mixed_Model_Test/INET003 /projects/b1081/singularity_images/afni_latest.sif tcsh -xef /projects/b1081/member_directories/dmsmith/Analysis_Test/Mixed_Model_Test/INET003/MixedQuest_Ses1.tcsh 2>&1 | tee /projects/b1081/member_directories/dmsmith/Analysis_Test/Mixed_Model_Test/INET003/output.MixedQuest_Ses1.tcsh

singularity exec -B /projects/b1081/member_directories/dmsmith/Analysis_Test/Mixed_Model_Test/INET003 /projects/b1081/singularity_images/afni_latest.sif tcsh -xef /projects/b1081/member_directories/dmsmith/Analysis_Test/Mixed_Model_Test/INET003/MixedQuest_Ses2.tcsh 2>&1 | tee /projects/b1081/member_directories/dmsmith/Analysis_Test/Mixed_Model_Test/INET003/output.MixedQuest_Ses2.tcsh

singularity exec -B /projects/b1081/member_directories/dmsmith/Analysis_Test/Mixed_Model_Test/INET003 /projects/b1081/singularity_images/afni_latest.sif tcsh -xef /projects/b1081/member_directories/dmsmith/Analysis_Test/Mixed_Model_Test/INET003/MixedQuest_Ses3.tcsh 2>&1 | tee /projects/b1081/member_directories/dmsmith/Analysis_Test/Mixed_Model_Test/INET003/output.MixedQuest_Ses3.tcsh

singularity exec -B /projects/b1081/member_directories/dmsmith/Analysis_Test/Mixed_Model_Test/INET003 /projects/b1081/singularity_images/afni_latest.sif tcsh -xef /projects/b1081/member_directories/dmsmith/Analysis_Test/Mixed_Model_Test/INET003/MixedQuest_Ses4.tcsh 2>&1 | tee /projects/b1081/member_directories/dmsmith/Analysis_Test/Mixed_Model_Test/INET003/output.MixedQuest_Ses4.tcsh