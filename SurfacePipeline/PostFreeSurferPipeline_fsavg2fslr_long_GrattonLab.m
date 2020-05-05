function PostFreeSurferPipeline_fsavg2fslr_long_GrattonLab(subject,FreesurferImportLocation,MPRImportLocation)
% 
% CG, 5/2020 - editing function originally made by E. Gordon for Petersen lab to
% work at NU.
%  Assuming BIDS organizational structure
% INPUTS
% subject = 'INET003' or the like (no 'sub-' needed - this is assumed in BIDS)
% FreesurferImportLocation= '/projects/b1081/iNetworks/Nifti/derivatives/freesurfer-6.0.1/'; %Input freesurfer path 
% MPRImportLocation = '/projects/b1081/iNetworks/Nifti/derivatives/preproc_fmriprep/fmriprep/sub-SUBJECT/anat/'; % can be the same as the input freesurfer path
%
% OUTPUTS
% systemresult: summary of system calls
% makes a bunch of files and adds them to the freesurfer folder


% constants
InputAtlasName = 'MNI152'; %e.g., 7112b, DLBS268, MNI152 (will be used to name folders in subject's folder)
ResampleAtlasName = 'MNI';
DownSampleI='32000'; %Downsampled mesh (same as HCP)
DownSampleNameI='32';

% Paths
outputFolder= [FreesurferImportLocation '/FREESURFER_fs_LR/']; %Path to overall study folder
if ~exist(outputFolder)
    mkdir(outputFolder);
end

%Script and Program Locations:
gaganScripts = '/projects/b1081/Scripts/CIFTI_RELATED/FSAVG2FSLR_SCRIPTS/'; %path to gagan_tools for FSLR conversion
CaretAtlasFolder = [gaganScripts '/global/templates/standard_mesh_atlases']; % Copied from Git Repo (Gagan note)
PipelineScripts = [gaganScripts '/PostFreeSurfer/scripts']; %Copied from Git Repo
PipelineBinaries = [gaganScripts '/global/binaries']; %Copied from Git Repo
GlobalScripts = [gaganScripts '/global/scripts']; %Copied from Git Repo
Caret5_Command = '/projects/b1081/Scripts/caret/bin_linux64/caret_command'; %Location of Caret5 caret_command
Caret7_Command = '/projects/b1081/Scripts/workbench2/bin_rh_linux64/wb_command'; %Location of Caret7 wb_command
CiftiScripts = '/projects/b1081/Scripts/CIFTI_RELATED/Cifti_creation/';


%% START SUB SPECIFIC info

T1name = ['sub-' subject '_space-' InputAtlasName 'NLin6Asym_desc-preproc_T1w'];
%FinalTemplateSpace= [MPRImportLocation '/sub-' subject '/sub-' subject '_mpr_n1_111_t88.nii.gz']; 
FinalTemplateSpace= [MPRImportLocation T1name]; 

%Image locations and names:
T1wFolder=[outputFolder '/sub-' subject '/' InputAtlasName]; %Could try replacing "$InputAtlasName" everywhere with String of your choice, e.g. 7112bLinear
AtlasSpaceFolder=[outputFolder '/sub-' subject '/' InputAtlasName];
NativeFolder='Native';
FreeSurferFolder=[FreesurferImportLocation '/sub-' subject];
FreeSurferInput=T1name; %[subject '_mpr_n1_111_t88'];
T1wRestoreImage=T1name; %[subject '_mpr_n1_111_t88'];
T2wRestoreImage = T1name; %[subject '_mpr_n1_111_t88']; %CG - not sure why this is still a T1
AtlasTransform=[outputFolder '/sub-' subject '/' InputAtlasName '/zero'];
InverseAtlasTransform=[outputFolder '/sub-' subject '/' InputAtlasName '/zero'];
AtlasSpaceT1wImage = T1name; %[subject '_mpr_n1_111_t88']; %CG - again, not totally sure why these all end up being the same
AtlasSpaceT2wImage = T1name; %[subject '_mpr_n1_111_t88'];
T1wImageBrainMask='brainmask_fs' %Name of FreeSurfer-based brain mask -- I think this gets created? GW

%Making directories and copying over relevant data (freesurfer output and mpr):
system(['mkdir -p ' outputFolder '/sub-' subject '/' InputAtlasName]);
system(['cp -R ' FreesurferImportLocation '/sub-' subject ' ' outputFolder '/sub-' subject '/' InputAtlasName]);
system(['cp ' MPRImportLocation T1name '.nii.gz ' outputFolder '/sub-' subject '/' InputAtlasName '/' T1name '.nii.gz']);

%I think this stuff below is making the 'fake warpfield that is identity above? GW
system(['fslmaths ' outputFolder '/sub-' subject '/' InputAtlasName '/' T1name '.nii.gz -sub ' outputFolder '/sub-' subject '/' InputAtlasName '/' T1name '.nii.gz ' outputFolder '/sub-' subject '/' InputAtlasName '/zero.nii.gz']);
system(['fslmerge -t ' outputFolder '/sub-' subject '/' InputAtlasName '/zero_.nii.gz ' outputFolder '/sub-' subject '/' InputAtlasName '/zero.nii.gz ' outputFolder '/sub-' subject '/' InputAtlasName '/zero.nii.gz ' outputFolder '/sub-' subject '/' InputAtlasName '/zero.nii.gz']);
system(['mv -f ' outputFolder '/sub-' subject '/' InputAtlasName '/zero_.nii.gz ' outputFolder '/sub-' subject '/' InputAtlasName '/zero.nii.gz']);

% Run it
system([CiftiScripts '/FreeSurfer2CaretConvertAndRegisterNonlinear.sh ' outputFolder ' sub-' subject ' ' T1wFolder ' ' AtlasSpaceFolder ' ' NativeFolder ' ' FreeSurferFolder ' ' FreeSurferInput ' ' FinalTemplateSpace ' ' T1wRestoreImage ' ' T2wRestoreImage ' ' CaretAtlasFolder ' ' DownSampleI ' ' DownSampleNameI ' ' Caret5_Command ' ' Caret7_Command ' ' AtlasTransform ' ' InverseAtlasTransform ' ' AtlasSpaceT1wImage ' ' AtlasSpaceT2wImage ' ' T1wImageBrainMask ' ' PipelineScripts ' ' GlobalScripts]);


% Note: Evan's version has some additional steps to resample data from
% native space (which is what he feeds into above) to MNI space and add
% both to a spec file. For now keeping as is, but we may want to check out
% his version of the code to change eventually
% PostFreeSurferPipeline_fsavg2fslr_long_singlesub.m
