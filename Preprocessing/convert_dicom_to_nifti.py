"""
Dicom to NIFTI conversion script for the Gratton lab
-------------------------------
Currently optimized to work for iNetworks project protocols
Created to produce a BIDS valid organization structure
Assumes DICOM data has already been renamed according to BIDS structure

v1.0: Created by CG on 2019-08-27
Based on example in: http://reproducibility.stanford.edu/bids-tutorial-series-part-1b/

"""

# imports
import os
import glob
import numpy as np

# Initialization of directory information:
# EDIT AS NEEDED
# making a test change
top_dir = '~/Box/DATA/iNetworks' # project directory
dcm2nii_dir = '~/Desktop/MRIcroGL' #needs to be downloaded
dicom_dir = top_dir + '/Dicom' # should already exist
nifti_dir = top_dir + '/Nifti' # will likely need to be made
if not os.path.exists(nifti_dir):
    os.mkdir(nifti_dir)

# some constants (make this something to read in from a params file?)
subs = ['INET006'] #['INET001']
sess = np.arange(4) #np.arange(1,6) #1-5 in python counts

# what to do:
convert_anat = True
convert_func = True
convert_fmap = True
convert_physio = True # not sure how to do this yet
    
# If this is the first subject, create a dataset description file
# os.system('jo -p "Name"="INetworks" "BIDSVersion"="1.0.2" >> %s/dataset_description.json')

for sub in subs:
    print('Processing subject ' + sub)

    for ses in sess:
        print('Processing session ' + str(ses))

        ### ANATOMICAL DATA
        if convert_anat:
            # create directory structure
            nifti_anat_dir = '%s/sub-%s/ses-%s/anat' %(nifti_dir,sub,ses)
            os.makedirs(nifti_anat_dir,exist_ok = True) # make the output directory if it doesn't exist

            # convert dicom to nifti (anats)
            # assume DICOM files are already renamed in BIDS format (MD script)
            #anat_runs = glob.glob('%s/sub-%s/ses-%d/anat/sub-*' %(dicom_dir,sub,ses))
            
            # run a more limited set that matches one of the expected patterns to avoid converting files that aren't needed
            anat_runs_limited = [glob.glob('%s/sub-%s/ses-%d/anat/sub-%s_ses-%s_T1w_2' %(dicom_dir,sub,ses,sub,ses)) + 
                                     glob.glob('%s/sub-%s/ses-%d/anat/sub-%s_ses-%s_T2w_2' %(dicom_dir,sub,ses,sub,ses)) + 
                                     glob.glob('%s/sub-%s/ses-%d/anat/sub-%s_ses-%s_MRA_all' %(dicom_dir,sub,ses,sub,ses)) + 
                                     glob.glob('%s/sub-%s/ses-%d/anat/sub-%s_ses-%s_MRV_all' %(dicom_dir,sub,ses,sub,ses))]
            anat_runs_limited_flat = [item for sublist in anat_runs_limited for item in sublist] #flatten

            for anat_run in anat_runs_limited_flat:
                arpath, arfile = os.path.split(anat_run)
                cmd = '%s/dcm2niix -o %s -f %s -z y %s' %(dcm2nii_dir,nifti_anat_dir,arfile,anat_run)
                print(cmd)
                os.system(cmd)
            
        ### FUNCTIONAL DATA
        if convert_func:
            # create directory structure
            nifti_func_dir = '%s/sub-%s/ses-%s/func' %(nifti_dir,sub,ses)
            os.makedirs(nifti_func_dir,exist_ok = True) # make the output directory if it doesn't exist

            # convert dicom to nifti (funcs)
            # assume DICOM files are already renamed in BIDS format (MD script)
            func_runs = glob.glob('%s/sub-%s/ses-%d/func/sub-*' %(dicom_dir,sub,ses))
            for func_run in func_runs:
                frpath, frfile = os.path.split(func_run)
                cmd = '%s/dcm2niix -o %s -f %s -z y %s' %(dcm2nii_dir,nifti_func_dir,frfile,func_run)
                print(cmd)
                os.system(cmd)

        # should also add task event tsv files - not done yet

        ### FIELD MAP DATA (FMAP)
        if convert_fmap:
            # create directory structure
            nifti_fmap_dir = '%s/sub-%s/ses-%s/fmap' %(nifti_dir,sub,ses)
            os.makedirs(nifti_fmap_dir,exist_ok = True) # make the output directory if it doesn't exist

            # convert dicom to nifti (anats)
            # assume DICOM files are already renamed in BIDS format (MD script)
            fmap_runs = glob.glob('%s/sub-%s/ses-%d/fmap/sub-*' %(dicom_dir,sub,ses))
            for fmap_run in fmap_runs:
                frpath, frfile = os.path.split(fmap_run)
                cmd = '%s/dcm2niix -o %s -f %s -z y %s' %(dcm2nii_dir,nifti_fmap_dir,frfile,fmap_run)
                print(cmd)
                os.system(cmd)
                
        ### PHYSIO DATA (not done yet...)
        if convert_physio:
            error('Physio data conversion not coded yet')
            #TRY: https://github.com/adolphslab/mriphysio
            #or: http://www.fieldtriptoolbox.org/reference/data2bids/
    

