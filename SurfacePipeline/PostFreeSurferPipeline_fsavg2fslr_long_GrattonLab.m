function PostFreeSurferPipeline_fsavg2fslr_long_GrattonLab(subject,FreesurferImportLocation,MPRImportLocation)
% PostFreeSurferPipeline_fsavg2fslr_long_GrattonLab('INET003','/projects/b1081/iNetworks/Nifti/derivatives/freesurfer-6.0.1/','/projects/b1081/iNetworks/Nifti/derivatives/preproc_fmriprep/fmriprep/sub-INET003/anat/')
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
%
% Should take ~10 min.

tic;

% constants
% FMRIPREP convention with 20.0.6: to use native vol as input
% however, all functional data then resampled and output to MNI space, so
% will need to resample at the end here
InputAtlasName = 'NativeVol'; %e.g., 7112b, DLBS268, MNI152 (will be used to name folders in subject's folder)
ResampleAtlasName = 'MNI';
ResampleAtlasName_long = 'MNI152NLin6Asym';
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
Caret7_Command = '/projects/b1081/Scripts/workbench2/bin_linux64/wb_command'; %Location of Caret7 wb_command
CiftiScripts = '/projects/b1081/Scripts/CIFTI_RELATED/Cifti_creation/';


%% START SUB SPECIFIC info

%T1name = ['sub-' subject '_space-' InputAtlasName 'NLin6Asym_desc-preproc_T1w'];
T1name = ['sub-' subject '_desc-preproc_T1w'];
%FinalTemplateSpace= [MPRImportLocation '/sub-' subject '/sub-' subject '_mpr_n1_111_t88.nii.gz']; 
FinalTemplateSpace= [MPRImportLocation T1name]; 

%Image locations and names:
T1wFolder=[outputFolder '/sub-' subject '/' InputAtlasName]; %Could try replacing "$InputAtlasName" everywhere with String of your choice, e.g. 7112bLinear
AtlasSpaceFolder=[outputFolder '/sub-' subject '/' InputAtlasName];
NativeFolder='Native'; %CG - I think this is referring to Native SURFACE from freesurfer, not native vol
FreeSurferFolder=[FreesurferImportLocation '/sub-' subject];
FreeSurferInput=T1name; %[subject '_mpr_n1_111_t88'];
T1wRestoreImage=T1name; %[subject '_mpr_n1_111_t88'];
T2wRestoreImage = T1name; %[subject '_mpr_n1_111_t88']; %CG - not sure why this is still a T1
AtlasTransform=[outputFolder '/sub-' subject '/' InputAtlasName '/zero'];
InverseAtlasTransform=[outputFolder '/sub-' subject '/' InputAtlasName '/zero'];
AtlasSpaceT1wImage = T1name; %[subject '_mpr_n1_111_t88']; %CG - again, not totally sure why these all end up being the same
AtlasSpaceT2wImage = T1name; %[subject '_mpr_n1_111_t88'];
T1wImageBrainMask = 'brainmask_fs'; %Name of FreeSurfer-based brain mask -- I think this gets created? GW

%Making directories and copying over relevant data (freesurfer output and mpr):
system(['mkdir -p ' outputFolder '/sub-' subject '/' InputAtlasName]);
system(['cp -R ' FreesurferImportLocation '/sub-' subject ' ' outputFolder '/sub-' subject '/' InputAtlasName]);
system(['cp ' MPRImportLocation T1name '.nii.gz ' outputFolder '/sub-' subject '/' InputAtlasName '/' T1name '.nii.gz']);

%I think this stuff below is making the 'fake warpfield that is identity above? GW
system(['module load fsl/5.0.8; fslmaths ' outputFolder '/sub-' subject '/' InputAtlasName '/' T1name '.nii.gz -sub ' outputFolder '/sub-' subject '/' InputAtlasName '/' T1name '.nii.gz ' outputFolder '/sub-' subject '/' InputAtlasName '/zero.nii.gz']);
system(['module load fsl/5.0.8; fslmerge -t ' outputFolder '/sub-' subject '/' InputAtlasName '/zero_.nii.gz ' outputFolder '/sub-' subject '/' InputAtlasName '/zero.nii.gz ' outputFolder '/sub-' subject '/' InputAtlasName '/zero.nii.gz ' outputFolder '/sub-' subject '/' InputAtlasName '/zero.nii.gz']);
system(['mv -f ' outputFolder '/sub-' subject '/' InputAtlasName '/zero_.nii.gz ' outputFolder '/sub-' subject '/' InputAtlasName '/zero.nii.gz']);

% Run it
%if 0 % FOR TESTING
system(['./FreeSurfer2CaretConvertAndRegisterNonlinear_GrattonLab.sh ' outputFolder ' sub-' subject ' ' T1wFolder ' ' AtlasSpaceFolder ' ' NativeFolder ' ' FreeSurferFolder ' ' FreeSurferInput ' ' FinalTemplateSpace ' ' T1wRestoreImage ' ' T2wRestoreImage ' ' CaretAtlasFolder ' ' DownSampleI ' ' DownSampleNameI ' ' Caret5_Command ' ' Caret7_Command ' ' AtlasTransform ' ' InverseAtlasTransform ' ' AtlasSpaceT1wImage ' ' AtlasSpaceT2wImage ' ' T1wImageBrainMask ' ' PipelineScripts ' ' GlobalScripts ' ' CiftiScripts]);
%end

%% RESAMPLE to MNI space
preproc_T1_folder = MPRImportLocation; % CG added - should be correct
T1name_resample = ['sub-' subject '_space-' ResampleAtlasName_long '_desc-preproc_T1w'];

ResampleFolder = [outputFolder '/sub-' subject '/' ResampleAtlasName '/'];
mkdir(ResampleFolder);
Atlasvol = [preproc_T1_folder '/' T1name_resample '.nii.gz'];
copyfile(Atlasvol,ResampleFolder);

system(['cp -r ' AtlasSpaceFolder '/* ' ResampleFolder '/']);

%transform_matrix = [preprocessedfolder '/T1_2' ResampleAtlasName '.mat'];
%world_matrix = [preprocessedfolder '/T1_2' ResampleAtlasName '.world'];
switch InputAtlasName
    case 'NativeVol'
        transform_dir = preproc_T1_folder;
        transform_file = ['sub-' subject '_from-T1w_to-' ResampleAtlasName_long '_mode-image_xfm'];
        prep_ANTS_transform_to_FSL(transform_dir,transform_file,FinalTemplateSpace,Atlasvol);
        transform_matrix = [transform_dir transform_file];
        %transform_matrix = [preproc_T1_folder '/testFSLmat.txt'];
    otherwise
        error('Not implemented yet for this Input Atlas. Check and edit code');
end
world_matrix = [preproc_T1_folder '/sub-' subject '_from-T1w_to-' ResampleAtlasName_long '.world'];


% CG - if we change to warpfield, will need to change this function
%system([Caret7_Command ' -convert-affine -from-flirt ' transform_matrix ' ' FinalTemplateSpace '.nii.gz ' Atlasvol ' -to-world ' world_matrix]);
%system([Caret7_Command ' -convert-warpfield -from-itk ' transform_matrix ' -to-world ' world_matrix]);
system([Caret7_Command ' -convert-affine -from-flirt ' transform_matrix '_FSLver.txt ' FinalTemplateSpace '.nii.gz ' Atlasvol ' -to-world ' world_matrix]);

surfaces = {'midthickness', 'white', 'pial', 'inflated', 'very_inflated'};

spaces = {'./','Native','fsaverage_LR32k'}; % = surface spaces (not vol)
extensions_per_space = {'164k_fs_LR','native','32k_fs_LR'};

cwd = pwd;

for i = 1:length(spaces)
    thisspace = spaces{i};
    thisextension = extensions_per_space{i};
    thisResampleFolder = [ResampleFolder '/' thisspace];
    cd(thisResampleFolder);
    
    %system([Caret7_Command ' -add-to-spec-file ' thisResampleFolder '/' subject '.' thisextension '.wb.spec INVALID ' ResampleFolder '/' T1name '_' ResampleAtlasName '.nii.gz']);
    system([Caret7_Command ' -add-to-spec-file ' thisResampleFolder '/sub-' subject '.' thisextension '.wb.spec INVALID ' ResampleFolder '/' T1name_resample '.nii.gz']);
    
    
    for j = 1:length(surfaces)
        surface = surfaces{j};
        
        % CG - Evan wasn't 100% sure the second line is working correctly,
        % as the coord gifti files are 'a bit screwy', so commented out for
        % now (other lines should be sufficient for mapping data)
        % CG - if we change to warp file will need to change this function
        
        %system([Caret7_Command ' -surface-apply-affine ' thisResampleFolder '/' subject '.L.' surface '.' thisextension '.surf.gii ' world_matrix ' ' thisResampleFolder '/' subject '.L.' surface '.' thisextension '.surf.gii']);
        %system(['set matrix = `cat ' transform_matrix '`; ' Caret5_Command ' -surface-apply-transformation-matrix ' thisResampleFolder '/' subject '.L.' surface '.' thisextension '.coord.gii ' thisResampleFolder '/' subject '.L.' thisextension '.topo.gii ' thisResampleFolder '/' subject '.L.' surface '.' thisextension '.coord.gii -matrix $matrix']);
        %system([Caret7_Command ' -surface-apply-warpfield ' thisResampleFolder '/sub-' subject '.L.' surface '.' thisextension '.surf.gii ' world_matrix ' ' thisResampleFolder '/sub-' subject '.L.' surface '.' thisextension '.surf.gii']);
        system([Caret7_Command ' -surface-apply-affine ' thisResampleFolder '/sub-' subject '.L.' surface '.' thisextension '.surf.gii ' world_matrix ' ' thisResampleFolder '/sub-' subject '.L.' surface '.' thisextension '.surf.gii']);
        
        %system([Caret7_Command ' -surface-apply-affine ' thisResampleFolder '/' subject '.R.' surface '.' thisextension '.surf.gii ' world_matrix ' ' thisResampleFolder '/' subject '.R.' surface '.' thisextension '.surf.gii']);
        %system(['set matrix = `cat ' transform_matrix '`; ' Caret5_Command ' -surface-apply-transformation-matrix ' thisResampleFolder '/' subject '.R.' surface '.' thisextension '.coord.gii ' thisResampleFolder '/' subject '.R.' thisextension '.topo.gii ' thisResampleFolder '/' subject '.R.' surface '.' thisextension '.coord.gii -matrix $matrix']);
        %system([Caret7_Command ' -surface-apply-warpfield ' thisResampleFolder '/sub-' subject '.R.' surface '.' thisextension '.surf.gii ' world_matrix ' ' thisResampleFolder '/sub-' subject '.R.' surface '.' thisextension '.surf.gii']);
        system([Caret7_Command ' -surface-apply-affine ' thisResampleFolder '/sub-' subject '.R.' surface '.' thisextension '.surf.gii ' world_matrix ' ' thisResampleFolder '/sub-' subject '.R.' surface '.' thisextension '.surf.gii']);
        
    end
    
end

system(['rm ' ResampleFolder '/fsaverage/*coord*']);
cd(cwd);
toc


end

function prep_ANTS_transform_to_FSL(transform_dir,transform_file,FinalTemplateSpace,Atlasvol)

ANTSdir = '/projects/b1081/Scripts/antsbin/ANTS-build/Examples/';
c3d_dir = '/projects/b1081/Scripts/c3d-1.0.0-Linux-x86_64/bin/';

% First take h5 file and disassemble into affine and warpfield
%/projects/b1081/Scripts/antsbin/ANTS-build/Examples/CompositeTransformUtil --disassemble sub-INET003_from-T1w_to-MNI152NLin6Asym_mode-image_xfm.h5 test
cwd = pwd;
cd(transform_dir)
system([ANTSdir 'CompositeTransformUtil --disassemble ' transform_file '.h5 ' transform_file]);

%%% then follow Tim Coalson/Moisa Fernandez suggestions from this link:
% https://www.mail-archive.com/hcp-users@humanconnectome.org/msg05795.html

% THIS seems to work if we only want to apply affine
system([c3d_dir 'c3d_affine_tool -itk 00_' transform_file '_AffineTransform.mat -ref ' FinalTemplateSpace '.nii.gz -src ' Atlasvol ' -ras2fsl -o ' transform_file '_FSLver.txt']);

% IF We want to apply warpfield, we need a more complicated set of commands
% (see link above for description
cd(cwd);

end

