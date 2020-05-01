function PostFreeSurferPipeline_fsavg2fslr_long_GrattonLab(sublist_file)
% 
% CG, 5/2020 - editing function originally made by E. Gordon for Petersen lab to
% work at NU.
%  Assuming BIDS organizational structure


% load subject list
subjlist = textread(sublist_file,'%s'); % list of vcids

% Paths
InputAtlasName = 'MNI152'; %e.g., 7112b, DLBS268, MNI152 (will be used to name folders in subject's folder)
FreesurferImportLocation= '/projects/b1081/iNetworks/Nifti/derivatives/freesurfer-6.0.1/'; %Input freesurfer path - CG Make this an input?
MPRImportLocation= FreesurferImportLocation; %Input MPR path
StudyFolder= [FreesurferImportLocation 'FREESURFER_fs_LR/']; %Path to overall study folder

%Script and Program Locations:
CaretAtlasFolder='/data/cn4/gagan/PARCELLATION_2012/TOOLS_N_STUFF/FSAVG2FSLR_SCRIPTS/global/templates/standard_mesh_atlases'; %Copied from Git Repo
PipelineScripts='/data/cn4/gagan/PARCELLATION_2012/TOOLS_N_STUFF/FSAVG2FSLR_SCRIPTS/PostFreeSurfer/scripts'; %Copied from Git Repo
PipelineBinaries='/data/cn4/gagan/PARCELLATION_2012/TOOLS_N_STUFF/FSAVG2FSLR_SCRIPTS/global/binaries'; %Copied from Git Repo
GlobalScripts='/data/cn4/gagan/PARCELLATION_2012/TOOLS_N_STUFF/FSAVG2FSLR_SCRIPTS/global/scripts'; %Copied from Git Repo
Caret5_Command='/data/cn/data1/linux/bin/caret_command64' %Location of Caret5 caret_command
Caret7_Command='/data/cn4/laumannt/workbench/bin_linux64/wb_command'%Location of Caret7 wb_command


for s = 1:length(subjlist)
    subject= subjlist{s};
    FinalTemplateSpace=[MPRImportLocation '/sub-' subject '/sub-' subject '_mpr_n1_111_t88.nii.gz']; % CG - this doesn't exist yet. Should it?
    
    DownSampleI='32000'; %Downsampled mesh (same as HCP)
    DownSampleNameI='32'; 
    
    
    %Image locations and names:
    T1wFolder=[StudyFolder '/' subject '/' InputAtlasName]; %Could try replacing "$InputAtlasName" everywhere with String of your choice, e.g. 7112bLinear
    AtlasSpaceFolder=[StudyFolder '/' subject '/' InputAtlasName];
    NativeFolder='Native';
    FreeSurferFolder=[FreesurferImportLocation '/' subject];
    FreeSurferInput=[subject '_mpr_n1_111_t88'];
    T1wRestoreImage=[subject '_mpr_n1_111_t88'];
    T2wRestoreImage = [subject '_mpr_n1_111_t88'];
    AtlasTransform=[StudyFolder '/' subject '/' InputAtlasName '/zero'];
    InverseAtlasTransform=[StudyFolder '/' subject '/' InputAtlasName '/zero'];
    AtlasSpaceT1wImage = [subject '_mpr_n1_111_t88'];
    AtlasSpaceT2wImage = [subject '_mpr_n1_111_t88'];
    T1wImageBrainMask='brainmask_fs' %Name of FreeSurfer-based brain mask -- I think this gets created? GW

    %Making directories and copying over relevant data (freesurfer output and mpr):   
    system(['mkdir -p ' StudyFolder '/' subject '/' InputAtlasName]);
    system(['cp -R ' FreesurferImportLocation '/' subject ' ' StudyFolder '/' subject '/' InputAtlasName]);
    system(['cp ' MPRImportLocation '/' subject '/' subject '_mpr_n1_111_t88.nii.gz ' StudyFolder '/' subject '/' InputAtlasName '/' subject '_mpr_n1_111_t88.nii.gz']);
 
    %I think this stuff below is making the 'fake warpfield that is identity above? GW
    system(['fslmaths ' StudyFolder '/' subject '/' InputAtlasName '/' subject '_mpr_n1_111_t88.nii.gz -sub ' StudyFolder '/' subject '/' InputAtlasName '/' subject '_mpr_n1_111_t88.nii.gz ' StudyFolder '/' subject '/' InputAtlasName '/zero.nii.gz']);
    system(['fslmerge -t ' StudyFolder '/' subject '/' InputAtlasName '/zero_.nii.gz ' StudyFolder '/' subject '/' InputAtlasName '/zero.nii.gz ' StudyFolder '/' subject '/' InputAtlasName '/zero.nii.gz ' StudyFolder '/' subject '/' InputAtlasName '/zero.nii.gz']);
    system(['mv -f ' StudyFolder '/' subject '/' InputAtlasName '/zero_.nii.gz ' StudyFolder '/' subject '/' InputAtlasName '/zero.nii.gz']);

    % Run it
    system(['/data/cn/data1/scripts/CIFTI_RELATED/Cifti_creation/FreeSurfer2CaretConvertAndRegisterNonlinear.sh ' StudyFolder ' ' subject ' ' T1wFolder ' ' AtlasSpaceFolder ' ' NativeFolder ' ' FreeSurferFolder ' ' FreeSurferInput ' ' FinalTemplateSpace ' ' T1wRestoreImage ' ' T2wRestoreImage ' ' CaretAtlasFolder ' ' DownSampleI ' ' DownSampleNameI ' ' Caret5_Command ' ' Caret7_Command ' ' AtlasTransform ' ' InverseAtlasTransform ' ' AtlasSpaceT1wImage ' ' AtlasSpaceT2wImage ' ' T1wImageBrainMask ' ' PipelineScripts ' ' GlobalScripts]);
end
