# GrattonLab-General-Repo
This is the general GrattonLab folder.

Main processing stream:
0. Change DICOM to NII and into BIDS format using code in other gitrepo. Start QC document and fill based on first steps
1. Run code in Preprocessing (fmriprep), check, and update QC document.
2. Run motion metrics code (motion_calc_utilities), check, and update QC document. (datalist must be made first)

[if doing functional connectivity analyses] 
A3. Run make_fs_masks to erode WM masks used in FCprocess.
A4. Run FCPRocess folder code (FCprocess_GrattonLab then fcimage_corrmat_volume). Check outputs and update QC document.
A5. Run Surface Pipeline code (PostFreeSurferPipeline then post_fc_processing_batch_GrattonLab code). Check outputs (possibly creating a dconn with make_dconn) and update QC document.

[if doing task fMRI analyses]
B3. Run code in taskproc folder



Major updates:

09/2019
Adding basic preprocessing scripts for the lab
03-08/2020
Added FC process, surface processing scripts and edits based on testing
11/2020
AD made edits to fMRIprep and FCprocess to account for datatype bug and new updates