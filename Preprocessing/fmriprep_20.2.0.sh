#!/usr/bin/bash

#SBATCH -A b1081
#SBATCH -p b1081
#SBATCH -t 100:00:00
#SBATCH -n 1
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=4G
#SBATCH -J fmriprp2_iNetworks
# Outputs ----------------------------------
#SBATCH --mail-user=ally.dworetsky@northwestern.edu
#SBATCH --mail-type=ALL
# ------------------------------------------

# SUBJECT (make an input eventually)
subject="INET003"

# set up some directory information
BIDS_DIR="/projects/b1081/iNetworks/Nifti"
DERIVS_DIR="derivatives/preproc_fmriprep-20.2.0"
WORK_DIR="/projects/b1081/singularity_images/work_ad"

# Prepare derivatives folder and work dirs
mkdir -p ${BIDS_DIR}/${DERIVS_DIR}
mkdir -p ${WORK_DIR}

# Load modules
module purge
module load singularity
echo "modules loaded" 

# To reuse freesurfer directories
mkdir -p ${BIDS_DIR}/derivatives/freesurfer-6.0.1
if [ ! -d ${BIDS_DIR}/${DERIVS_DIR}/freesurfer ]; then
    ln -s ${BIDS_DIR}/derivatives/freesurfer-6.0.1 ${BIDS_DIR}/${DERIVS_DIR}/freesurfer
fi

# remove IsRunning files from Freesurfer
find ${BIDS_DIR}/derivatives/freesurfer-6.0.1/sub-$subject/ -name "*IsRunning*" -type f -delete

# do singularity run
echo "Begin Preprocessing"

singularity run --cleanenv -B /projects/b1081:/projects/b1081 \
    /projects/b1081/singularity_images/fmriprep-20.2.0.simg \
    ${BIDS_DIR} \
    ${BIDS_DIR}/${DERIVS_DIR} \
    participant --participant-label ${subject} \
    -w ${WORK_DIR} --omp-nthreads 8 --nthreads 12 --mem_mb 3000 \
    --fs-license-file /projects/b1081/singularity_images/freesurfer_license.txt \
    --output-spaces MNI152NLin6Asym:res-2 \
    --ignore slicetiming --fd-spike-threshold 0.2


# convert BOLD volume files to float
module load fsl
for filename in ${BIDS_DIR}/${DERIVS_DIR}/fmriprep/sub-${subject}/ses-*/func/sub-${subject}_*_desc-preproc_bold.nii.gz
do
  fslmaths -dt input ${filename} ${filename} -odt float
done
