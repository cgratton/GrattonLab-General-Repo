function create_spherical_ROIs_AFNI
% quick script for creating spherical ROIs using AFNI commands

% ADJUST the following as needed
roiDir_top = '/projects/b1081/Atlases';
roi_file = [roiDir_top '/Seitzman300/ROIs_300inVol_MNI_allInfo.txt']; % text file with ROI info
tpl_out = [roiDir_top '/templateflow/tpl-MNI152NLin6Asym/tpl-MNI152NLin6Asym_res-02_desc-brain_mask_dilate3.nii.gz']; %template in correct space for output ROIs
orient = 'LPI'; %orientation image should be in
outdat_fname = [roiDir_top '/Seitzman300/Seitzman300_MNI_res02_allROIs.nii.gz'];

% load ROI information
[x y z rad netNum netLabel pcPer] = textread(roi_file,'%f%f%f%f%d%s%f','headerlines',1); %adjust as needed
nROIs = length(x);
ROI_counter = 1:nROIs;

% save out in the format AFNI wants
%afni_dat = [x y z ROI_counter'];
%save([roi_file(1:end-4) '_AFNIformat.txt'],afni_dat,'-ascii'); 

% a place to save individual ROI files
roiDir_ind = [roiDir_top '/Seitzman300/rois_individual/'];
if exist(roiDir_ind)
    rmdir(roiDir_ind,'s');
end
mkdir(roiDir_ind);

for n = ROI_counter
    
    fout = sprintf('%sSeitzman300_roi%03d_coord%.02f_%.02f_%.02f_net-%s.nii.gz',roiDir_ind,n,x(n),y(n),z(n),netLabel{n});
    %expr = """'%d*step(%f-((x-%f)*(x-%f))-((y-%f)*(y-%f))-((z-%f)*(z-%f))'"""
    
    %command = sprintf('3dUndump -srad %f -master %s -orient %s -prefix %s -xyz %s',rad(n)
    command = sprintf('module load singularity; singularity run -B %s /projects/b1081/singularity_images/afni_latest.sif 3dcalc -a %s -expr ''%d*step(%f-((x-%f)*(x-%f))-((y-%f)*(y-%f))-((z-%f)*(z-%f)))'' -LPI -prefix %s',...
        roiDir_top,tpl_out,n,rad(n)^2,x(n),x(n),y(n),y(n),z(n),z(n),fout);
    system(command);
    
    % load the mask that is made and sum into a final mask
    all_mask(n,:) = load_untouch_nii_wrapper(fout);
    
end

% then sum all of the masks together into a final mask
avg_mask = sum(all_mask,1);
outdat = load_untouch_nii(tpl_out);
d = size(outdat.img);
outdat.img = reshape(avg_mask,d);
outdat.fileprefix = outdat_fname;
save_untouch_nii(outdat,outdat_fname);