function make_fs_masks(subject, fmriprepTopDir)

%%%%%%%%%%%%%%%%%%%%%%
% This makes several erosions of WM masks, including no erosion.
% JDP 8/14/12, modified from TOL script; modified for NU/Matlab Oct. 2020
%
% The outputs (e.g., 'sub-INET003_space-MNI152NLin6Asym_label-WM_probseg_0.9mask_res-2_ero3.nii.gz')
% are written into the subject's overall 'anat' folder of the fMRIPrep output.
%
% First input is subject ID (e.g., 'INET003'; assumes BIDS structure); second is fmriprep
% directory (e.g., '/projects/b1081/iNetworks/Nifti/derivatives/preproc_fmriprep-20.2.0');
% also assumes fmriprep directory structure as our standard
%

%%%%%% change parameters if desired %%%%%%
space = 'MNI152NLin6Asym';
voxdim = '2'; %voxel size
eroiterwm = 4; %number of erosions to perform
WMprobseg_thresh = 0.9;
%------------
WMprobseg = ['sub-' subject '_space-' space '_label-WM_probseg.nii.gz'];
WMmaskname = ['sub-' subject '_space-' space '_label-WM_probseg_' num2str(WMprobseg_thresh) 'mask.nii.gz'];
anat_dir= [fmriprepTopDir '/fmriprep/sub-' subject '/anat/'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

currDir = pwd;
cd(anat_dir);

%%% first, use ANTs to warp T1 and WMprobseg images into MNI in 111 space, if they don't yet exist %%%
antsdir = '/projects/b1081/Scripts/antsbin/ANTS-build/Examples/';
T1_templateLoc = ['/projects/b1081/Atlases/templateflow/tpl-' space '/tpl-' space '_res-01_T1w.nii.gz'];
inNames = {['sub-' subject '_desc-preproc_T1w.nii.gz'], ['sub-' subject '_label-WM_probseg.nii.gz']};
outNames = {['sub-' subject '_space-' space '_desc-preproc_T1w.nii.gz'], WMprobseg};

for tform = 1:length(inNames)
    if ~exist(outNames{tform}, 'file')
        system([antsdir '/antsApplyTransforms --verbose -i ' inNames{tform} ' -o ' outNames{tform} ' -r ' T1_templateLoc ' -t sub-' subject '_from-T1w_to-' space '_mode-image_xfm.h5']);
    end
end


%%% threshold at WMprobseg_thresh and binarize %%%
system(['module load fsl; fslmaths ' WMprobseg  ' -thr ' num2str(WMprobseg_thresh) ' -bin ' WMmaskname]);


%%% erode cerebral WM mask to avoid possible gray matter contamination %%%
iter = 0;
system(['module load singularity; singularity run -B ' anat_dir ' /projects/b1081/singularity_images/afni_latest.sif 3dresample -dxyz ' voxdim ' ' voxdim ' ' voxdim ' -prefix ' WMmaskname(1:end-7) '_res-' voxdim '.nii.gz -input ' WMmaskname]);
system(['module load fsl; fslmaths ' WMmaskname(1:end-7) '_res-' voxdim '.nii.gz -bin ' WMmaskname(1:end-7) '_res-' voxdim '_ero0.nii.gz']);

iter = 1;
while iter <= eroiterwm
	system(['module load fsl; fslmaths ' WMmaskname ' -kernel 3D -ero ' WMmaskname]);
    
    system(['module load singularity; singularity run -B ' anat_dir ' /projects/b1081/singularity_images/afni_latest.sif 3dresample -dxyz ' voxdim ' ' voxdim ' ' voxdim ' -prefix ' WMmaskname(1:end-7) '_res-' voxdim '.nii.gz -input ' WMmaskname ' -overwrite']);	
    system(['module load fsl; fslmaths ' WMmaskname(1:end-7) '_res-' voxdim '.nii.gz -bin ' WMmaskname(1:end-7) '_res-' voxdim '_ero' num2str(iter) '.nii.gz']);
    iter = iter + 1;
end

%%% remove unnecessary files %%%
system(['rm ' anat_dir '/' WMmaskname ' ' anat_dir '/' WMmaskname(1:end-7) '_res-' voxdim '.nii.gz']);
cd(currDir)

end