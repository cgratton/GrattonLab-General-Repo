function params = post_fc_processing_batch_params_iNetworks
%
%Parameters to set for post_fc_processing_batch.m
%
% CG - edited to work for iNetworks at NU off of Quest

%--------------------------------------------------------------------------

%data list, in the same format required by FCPROCESS
datalist = '../FCProcess/EXAMPLESUB_DATALIST.xlsx'; % change this to datalist for your project

%tmask list, in the same format required by FCPROCESS - datalist provides sufficient info to ID
%tmasklist = '/data/cn4/dgreene/Patients/AdultTS/NoFieldMap/COHORTSELECT_CONTROLS/NEW_TMASKLIST.txt';

%Location of final UNSMOOTHED fc-processed data
fcprocessed_funcdata_dir = '/projects/b1081/iNetworks/Nifti/derivatives/preproc_FCProc/';

%Generalied suffix of final UNSMOOTHED fc-processed data, such that the
%data files are named sub-[subject number]_task-[cond]_run-[runnum][suffix].nii.gz
% note: subject num, cond, and run num should be specified in the datalist
fcprocessed_funcdata_dir_suffix = '_fmriprep_zmdt_resid_ntrpl_bpss_zmdt';

%Location cifti files will be written to. This folder will be created, and
%sub-folders will be created within this location. 
outfolder = '/projects/b1081/iNetworks/Nifti/derivatives/postFCproc_CIFTI/';

%Location of the volumetric subcortical mask label file. Data within this
%mask will be smoothed and included in the cifti files. This should contain
%different labels for each volumetric structure identified by freesurfer.
% CG NOTE: this has to match resolution/space that we want and has to be a
% label file
subcort_mask = '/projects/b1081/Scripts/CIFTI_RELATED/Resources/cifti_masks/subcortical_mask_LR_222_MNI_Label.nii.gz';

%Location of subjects' fs_LR-registered surfaces. Underneath this folder,
%subject data should be in '[subjectnumber]/7112b_fs_LR/' ; this folder
%should contain 'Native' and 'fsaverage_LR32k' subfolders with surfaces.
fs_LR_surfdir = '/projects/b1081/iNetworks/Nifti/derivatives/freesurfer-6.0.1/FREESURFER_fs_LR/';

%Location of atlas medial wall masks (where the cortical surfaces don't
%have cortical data). Data from these regions will not be included in the
%cifti files.
medial_mask_L = '/projects/b1081/Scripts/CIFTI_RELATED/Resources/cifti_masks/L.atlasroi.32k_fs_LR.shape.gii';
medial_mask_R = '/projects/b1081/Scripts/CIFTI_RELATED/Resources/cifti_masks/R.atlasroi.32k_fs_LR.shape.gii';

%Additional cifti files will be produced using the specified "smallwall"
%medial wall masks, which are highly eroded versions of the atlas medial
%wall masks. These are dataset-specific, and are usually built as the
%cortical locations where at least one subject in the dataset has no data
%projected. Ciftis made using "smallwall" masks are primarily used for
%parcellation. Leave empty ([]) to omit generation of ciftis with smallwall
%masks.
sw_medial_mask_L = []; %'/data/pruett/CPD/ImagingStudies/BabySibs_fcMRI//Zeran/voxel_community/mode_49_V24_wmparc/L.atlasroi_noproj.func.gii';
sw_medial_mask_R = []; %'/data/pruett/CPD/ImagingStudies/BabySibs_fcMRI//Zeran/voxel_community/mode_49_V24_wmparc/R.atlasroi_noproj.func.gii';

%Sigma of the smoothing kernel to be applied geodesically to surface data and
%volumetrically to the subcortical data
smoothnum = 2.55;


%CG added: some FC proc variables:
%InputAtlasName = 'NativeVol'; %fmriprep inputs the native vol to freesurfer
%ResampleAtlasName = 'MNI'; % all of the EPI data is in MNI space tho - need to resample 
space = 'MNI152NLin6Asym';
space_short = 'MNI';
res = 'res-2'; %'','res-2' or 'res-3' (voxel resolutions for output)
res_short = '222';

%T1name_input_end = ['_desc-preproc_T1w.nii.gz'];
T1name_end = ['_space-' space '_desc-preproc_T1w.nii.gz']; % T1 name ending

%%% estimate goodvoxels for each subject
force_remake_concat = 0; %force remake the concatenated preproc dataset? (Takes long time)
force_ribbon = 0; %force remake the single subject ribbon (Takes medium time)
force_goodvoxels = 0; %force remake the goodvoxels mask (Takes medium-short time)


%-------------------------------------------------------------------------
%DO NOT CHANGE

%load variables into an output structure
varnames = who;
for i = 1:length(varnames)
    evalc(['params.' varnames{i} ' = ' varnames{i} ';']);
end

