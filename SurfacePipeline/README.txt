CG - 5/2020, Surface Pipeline at NU

Started from using examples from MSC code & Evan Processing scripts



1. If not already created, you will need to make the fs_LR_32k (HCP-style) surfaces for each subject. This only needs to be done ONCE per subject. To do this:
    a. Run Freesurfer on the data (usually done through fmriprep - see notes in that folder)
    b. Run PostFreeSurferPipeline_fsavg2fslr_long_GrattonLab.m on the subject (see header of that function)
        ex: PostFreeSurferPipeline_fsavg2fslr_long_GrattonLab('INET003','/projects/b1081/iNetworks/Nifti/derivatives/freesurfer-6.0.1/','/projects/b1081/iNetworks/Nifti/derivatives/preproc_fmriprep/fmriprep/sub-INET003/anat/');
        NOTE-A: You will need to have scripts in the /projects/b1081/Scripts/CIFTI_RELATED/ folder accessible (e.g., by running your addpath startup script)
        NOTE-B: You will need to be able to use functions from FSL and Freesurfer. On Quest, these are loaded through modules in the function, BUT you will also have to modify your .bashrc to properly direct some of these scripts (only needs to be done once; see cgv5453 .bashrc for example). You will also need to be able to access the ANTS and c3d code that I downloaded for conversion (see D) in the common Scripts folder.
	NOTE-C: This should take about 15 min. If it's taking longer, something may be wrong.
	NOTE-D: I had a fair amount of trouble taking the fmriprep transforms and using them to appropriately adjust the FSLR output. In the end, I transform the ANTS affine transform to FSL, apply it, and transform the ANTS non-linear transform to nifti and apply it afterward. This all generally seems to work, although not on the inflated version for some reason, so I regenerate these ("_xfm") at the end. See this link for relevant discussion on this point:
	https://groups.google.com/a/humanconnectome.org/d/msg/hcp-users/dnvNB7-0iiw/TrQ7guxzAAAJ

    c. Check the output. It should be found in, e.g.:
        /projects/b1081/iNetworks/Nifti/derivatives/freesurfer-6.0.1/FREESURFER_fs_LR/sub-INET003/MNI/
	-> look at spec file for fslr version of code to make sure surfaces are good and synchronized with MNI T1


2. Run surface transformation on your processed fMRI data to put it on the surface 
   a. First, edit the post_fc_processing_batch_params_iNetworks.m script. This script has experiment specific parameters - make sure these are all correct for you.
   b. Next, run the CIFTI maker, feeding it the params file:
   > post_fc_processing_batch_Grattonlab('post_fc_processing_batch_iNetworks.m')
   
	NOTE-A: Currently, the code is set up to look and see whether a few steps (tmasked files for goodvoxels, goodvoxels files, and surface ribbon) have already been run and if so, will not rerun them. If you DO want them to be rerun, you can edit the code to set to "force" or delete the files from their relevant directories.
	NOTE-B: This takes a long time (2 hrs. per session for rest, 20 min. per 5.5 min. run). We may want to edit to set up a parallelization of this script.
	NOTE-C: This code automatically applies surface smoothing (and volume smoothing for the subcortex). It will need to be edited and rerun if we do not want those pieces. The code is also set up to assume 222 space.

   c. Check the output CIFTI files: load these in workbench and check that they look reasonable with reasonable fluctuations. If this is the first subject you are testing, it is probably also a good idea to make a dconn and test that the correlation structure seems reasonable.



