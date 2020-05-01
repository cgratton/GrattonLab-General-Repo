CG - 5/2020, started on Surface Pipeline at NU

Started from using examples from MSC code & Evan Processing scripts



MY PREVIOUS NOTES:
1. Do regular FC processing, but without smoothing the data in the last step
     see - TaskRest data analysis steps (Joe's data)

2. Make sure FULL Freesurfer pipeline has been run
     i.e., both the make FS masks part and the post-processing part to make the surfaces
     
     a. see this link for first part of processing: Running freesurfer segmentation on supercomputer
     b. run PostFreeSurferPipeline_fsavg2fslr_long.bat on any subject that doesn't have a surface
          here you just need to feed in a file with a list of vcid #s that need to be processed
          note that some paths are currently hard coded but may need to be changed (e.g., adults directory)
          ** make sure that subject's anatomy in their folder is a .nii.gz as opposed to .nii since this can cause script to error
               niftigz_4dfp -n FILENAME FILENAME
          ** run using my matlab version of this script instead, in my Workbench_scripts directory


3. Run post_fc_processing_batch.m to make ciftis
     here you want to copy post_fc_processing_batch_params.m to your local directory
          AND edit to have your preferred parameters
     In particular, change the datalists, tmasklists, etc to point to my FCprocessed data
          change ending to point to stage of file processing that we want
          change output folder 
          may want to change subcortical mask (this one is based on mode from 120)
          use the listed medial wall masks
          change the small wall mask to '' if you don't want to make this version of the files (you only really need this if you're going to do boundary mapping)
          make sure smoothing is what you want (2.55 for 6mm FWHM)

4. Run cifti_correlations
     note that for rest I also need to run concat_data_vcid_ciftis.m before hand
