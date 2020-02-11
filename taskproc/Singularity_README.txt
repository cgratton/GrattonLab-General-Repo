#DMS: Directions for using AFNI on Quest

#Thanks to AN for showing me how to use singularity on Quest and to the Quest support staff for their documentation
#When you first set up the AFNI singularity follow the steps below (from Quest team)

1- Load Singularity module
module load singularity/latest

2- Pull the AFNI docker container image using Singularity. Note that this step will take some time.
singularity pull docker://afni/afni

When this step is completed you will have a new Singularity container file called afni_latest.sif in your work folder. The file could be couple of GB in size.

3- You can start a terminal within the container using the following command:
singularity shell afni_latest.sif

#After you have you have the sif file in your working directory you simply need to do step one and then step two in order to work in the singularity. So simply complete the following two steps each time you use AFNI on Quest. Note this works if the sif file is in your current directory. If this is not the case add the path for the sif file in the second command.

module load singularity/latest

singularity shell afni_latest.sif

#After the shell command your terminal will change but you can still move around using cd as needed. You can now employ AFNI functions in the terminal.

#An alternative approach should be used with batch script Quest request. You can execute commands in the singularity using a special exec command. In the batch script you simply use the load module command for the AFNI sif file and then operations conducted in the singularity will be ordered through the exec command. Note the example below

module load singularity/latest

singularity exec afni_latest.sif sh /projects/b1081/Analysis_Test/SL_Model_Test/INET006/scripts/SL_Se s1_PreProc_PathtoBase.sh

#On the line above the script SL_Ses1_PreProc_PathtoBase.sh is run via the exec command. The name of the sif file (afni_latest.sif) needs to be included and the path was for sh file being run (SL_Ses1_PreProc_PathtoBase.sh) in this case the sh file was not included in the same directory as the sif file so the command sh SL_Ses1_PreProc_PathtoBase.sh was run as sh /projects/b1081/Analysis_Test/SL_Model_Test/INET006/scripts/SL_Se s1_PreProc_PathtoBase.sh . The cd command does not seem to work within the singularity when using batch so it is best to simply write out the directory if files in other directory than the one housing the sif file need to be used.

#Another thing one needs to do when using AFNI on Quest is directory binding.  In order to use a directory you need to "bind" it to the singularity.  You need to do this whenever you use the singularity.  Below is an example of directory binding. (note exec is an alternative to shell this will let you run commands in the singularity without opening up a singularity terminal)


##This is an example of what would be put into the sh file that is used for the request 

cd /projects/b1081/singularity_images

module load singularity/latest


singularity exec -B /projects/b1081/member_directories/dmsmith/Analysis_Test/Mixed_Model_Test/INET003 /projects/b1081/singularity_images/afni_latest.sif tcsh -xef /projects/b1081/member_directories/dmsmith/Analysis_Test/Mixed_Model_Test/INET003/MixedQuest_Ses1.tcsh 2>&1 | tee /projects/b1081/member_directories/dmsmith/Analysis_Test/Mixed_Model_Test/INET003/output.MixedQuest_Ses1.tcsh

singularity exec -B /projects/b1081/member_directories/dmsmith/Analysis_Test/Mixed_Model_Test/INET003 /projects/b1081/singularity_images/afni_latest.sif tcsh -xef /projects/b1081/member_directories/dmsmith/Analysis_Test/Mixed_Model_Test/INET003/MixedQuest_Ses2.tcsh 2>&1 | tee /projects/b1081/member_directories/dmsmith/Analysis_Test/Mixed_Model_Test/INET003/output.MixedQuest_Ses2.tcsh

singularity exec -B /projects/b1081/member_directories/dmsmith/Analysis_Test/Mixed_Model_Test/INET003 /projects/b1081/singularity_images/afni_latest.sif tcsh -xef /projects/b1081/member_directories/dmsmith/Analysis_Test/Mixed_Model_Test/INET003/MixedQuest_Ses3.tcsh 2>&1 | tee /projects/b1081/member_directories/dmsmith/Analysis_Test/Mixed_Model_Test/INET003/output.MixedQuest_Ses3.tcsh

singularity exec -B /projects/b1081/member_directories/dmsmith/Analysis_Test/Mixed_Model_Test/INET003 /projects/b1081/singularity_images/afni_latest.sif tcsh -xef /projects/b1081/member_directories/dmsmith/Analysis_Test/Mixed_Model_Test/INET003/MixedQuest_Ses4.tcsh 2>&1 | tee /projects/b1081/member_directories/dmsmith/Analysis_Test/Mixed_Model_Test/INET003/output.MixedQuest_Ses4.tcsh




AFNI QC

-The AFNI review driver gives you plots showing motion above your specified threshold for censoring (assuming you are censoring) and an outlier plot. It also supplies you with a list of values one being the censored fraction (the fraction of TR’s censored for motion). I typically remove subjects that have 15% or more of their TR’s censored for motion but this particular fraction should depend on the amount of data you are collecting.

-AFNI also supplies you with the average censored motion (strange name for the average motion post censoring). I don’t have good frame of reference for what this value should be but it is a manifestation of small motion. Some subjects might not have many motion spikes but they could have lots of vibrating like motion.

-Review driver supplies a number for the TSNR. One should also look at a TSNR map assuming you plan on investigating regions that are typically in low signal areas (like the OFC).

-Motion Correction: Look at functional runs (look for shifts)

-Alignment: Overlay-Underlay Toggle (o and u keys let you do this in the image viewer and it is part of the review driver) I don’t use this but hitting the 4 key gives you slider in the AFNI viewer that lets you side between your overlay and underlay. It is good to check the edges of the brain and the ventricles between the two types of scans.

-When running a task analysis AFNI can report how correlated your predictors are with each other.

-When it comes to resting data CG’s script for producing Power’s greyplots is useful. Use to make sure global signal spikes are no longer in the BOLD time series post GSR.