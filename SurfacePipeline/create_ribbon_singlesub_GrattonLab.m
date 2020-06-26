function create_ribbon_singlesub_GrattonLab(sub,freedir,T1image,resolution,funcvol)
% CG: created based on csh script from Petersen Lab
%   6.2020

%#!/bin/csh
disp("START: CreateRibbon");


% #NU needs FSL and Freesufer modules loaded
% #Note that you will also need to edit your .bashrc 
% #scripts to include info about FSL and Freesurfer 
% #home directories - see CG example in cgv5452
% module load fsl/5.0.8
% module load freesurfer/6.0
% source $FREESURFER_HOME/SetUpFreeSurfer.sh

% some paths
CARET7DIR = '/projects/b1081/Scripts/workbench2/bin_linux64'; %/usr/local/workbench/bin_rh_linux64/
subject = ['sub-' sub];
%set freedir = $2
%set T1image = $3
%set resolution = $4
freelables = '/projects/b1081/Scripts/CIFTI_RELATED/Cifti_creation/FreeSurferAllLut.txt'; %/home/data/scripts/Cifti_creation/FreeSurferAllLut.txt
T1filename = [freedir '/' T1image];
nativedir = [freedir '/Native'];
outputdir = [freedir '/Ribbon'];
mkdir(outputdir);

% some constants
LeftGreyRibbonValue='3';
LeftWhiteMaskValue='2';
RightGreyRibbonValue='42';
RightWhiteMaskValue='41';


hems = {'L','R'};

for h = 1:2
    hem = hems{h};
    
    if h == 1
        GreyRibbonValue=LeftGreyRibbonValue;
        WhiteMaskValue=LeftWhiteMaskValue;
        disp("LEFT hemisphere");
        
    elseif h == 2
        GreyRibbonValue=RightGreyRibbonValue;
        WhiteMaskValue=RightWhiteMaskValue;
        disp("RIGHT hemisphere");
    end
    
    system([CARET7DIR '/wb_command -create-signed-distance-volume ' nativedir '/' subject '.' hem '.white.native.surf.gii ' T1filename ' ' outputdir '/' subject '.' hem '.white.native.nii.gz']);
    system([CARET7DIR '/wb_command -create-signed-distance-volume ' nativedir '/' subject '.' hem '.pial.native.surf.gii ' T1filename ' ' outputdir '/' subject '.' hem '.pial.native.nii.gz']);
    
    system(['module load fsl/5.0.8; fslmaths ' outputdir '/' subject '.' hem '.white.native.nii.gz -thr 0 -bin -mul 255 ' outputdir '/' subject '.' hem '.white_thr0.native.nii.gz']);
    system(['module load fsl/5.0.8; fslmaths ' outputdir '/' subject '.' hem '.white_thr0.native.nii.gz -bin ' outputdir '/' subject '.' hem '.white_thr0.native.nii.gz']);
    system(['module load fsl/5.0.8; fslmaths ' outputdir '/' subject '.' hem '.pial.native.nii.gz -uthr 0 -abs -bin -mul 255 ' outputdir '/' subject '.' hem '.pial_uthr0.native.nii.gz']);
    system(['module load fsl/5.0.8; fslmaths ' outputdir '/' subject '.' hem '.pial_uthr0.native.nii.gz -bin ' outputdir '/' subject '.' hem '.pial_uthr0.native.nii.gz']);
    system(['module load fsl/5.0.8; fslmaths ' outputdir '/' subject '.' hem '.pial_uthr0.native.nii.gz -mas ' outputdir '/' subject '.' hem '.white_thr0.native.nii.gz -mul 255 ' outputdir '/' subject '.' hem '.ribbon.nii.gz']);
    system(['module load fsl/5.0.8; fslmaths ' outputdir '/' subject '.' hem '.ribbon.nii.gz -bin -mul ' GreyRibbonValue ' ' outputdir '/' subject '.' hem '.ribbon.nii.gz']);
    %#fslmaths ${outputdir}/${subject}.${hem}.white.native.nii.gz -uthr 0 -abs -bin -mul 255 ${outputdir}/${subject}.${hem}.white_uthr0.native.nii.gz
    %#fslmaths ${outputdir}/${subject}.${hem}.white_uthr0.native.nii.gz -bin ${outputdir}/${subject}.${hem}.white_uthr0.native.nii.gz
    %#fslmaths ${outputdir}/${subject}.${hem}.white_uthr0.native.nii.gz -mul $WhiteMaskValue ${outputdir}/${subject}.${hem}.white_mask.native.nii.gz
    %#fslmaths ${outputdir}/${subject}.${hem}.ribbon.nii.gz -add ${outputdir}/${subject}.${hem}.white_mask.native.nii.gz ${outputdir}/${subject}.${hem}.ribbon.nii.gz

    % for testing - comment this out
    % system(['rm ${outputdir}/${subject}.${hem}.white.native.nii.gz ${outputdir}/${subject}.${hem}.white_thr0.native.nii.gz ${outputdir}/${subject}.${hem}.pial.native.nii.gz ${outputdir}/${subject}.${hem}.pial_uthr0.native.nii.gz ${outputdir}/${subject}.${hem}.white_uthr0.native.nii.gz ${outputdir}/${subject}.${hem}.white_mask.native.nii.gz']);
end


system(['module load fsl/5.0.8; fslmaths ' outputdir '/' subject '.L.ribbon.nii.gz -add ' outputdir '/' subject '.R.ribbon.nii.gz ' outputdir '/ribbon.nii.gz']);
%system(['rm ${outputdir}/${subject}.L.ribbon.nii.gz ${outputdir}/${subject}.R.ribbon.nii.gz']); % commented out during testing
system([CARET7DIR '/wb_command -volume-label-import ' outputdir '/ribbon.nii.gz ' freelables ' ' outputdir '/ribbon.nii.gz -discard-others -unlabeled-value 0']);

%#Downsample to BOLD dimensions
%system(['module load fsl/5.0.8; flirt -in ' outputdir '/ribbon -ref ' outputdir '/ribbon -init $FSLDIR/etc/flirtsch/ident.mat -applyisoxfm ' resolution ' -out ' outputdir '/ribbon_' resolution resolution resolution]);
system(['module load fsl/5.0.8; flirt -in ' outputdir '/ribbon -ref ' funcvol ' -applyxfm -usesqform -out ' outputdir '/ribbon_' resolution resolution resolution]);

%#gunzip ${outputdir}/ribbon.nii.gz
%#nifti_4dfp -4 ${outputdir}/ribbon ${outputdir}/ribbon
%#t4img_4dfp none ${outputdir}/ribbon ${outputdir}/ribbon_333 -O333
%#niftigz_4dfp -n ${outputdir}/ribbon_333 ${outputdir}/ribbon_333

disp("\n END: CreateRibbon");

