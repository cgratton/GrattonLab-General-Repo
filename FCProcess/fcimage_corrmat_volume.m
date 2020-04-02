function fcimage_corrmat_volume(datafile,FCdir,atlas)
% function fcimage_corrmat_volume()
% this function will make an ROI x ROI correlation matrix based on a set of
% volume ROIs and a list of files
%
% EXAMPLE: fcimage_corrmat_volume('EXAMPLESUB_DATALIST.xlsx','/projects/b1081/iNetworks/Nifti/derivatives/preproc_FCProc/','Seitzman300')
%
% CG - 03.26.2020
%%%%%%%%%%%%%%%%%

%% Directory information
atlas_dir = '/projects/b1081/Atlases/';
outDir_top = [FCdir 'corrmats_' atlas '/'];
if ~exist(outDir_top)
    mkdir(outDir_top);
end

%% load in sub/session info
df = readtable(datafile); %reads into a table structure, with datafile top row as labels
numdatas=size(df.sub,1); %number of datasets to analyses (subs X sessions)

% organize for easier use
for i = 1:numdatas
    subInfo(i).subjectID = df.sub{i}; %experiment subject ID
    subInfo(i).session = df.sess(i); %session ID
    subInfo(i).condition = df.task{i}; %condition type (rest or name of task)
    subInfo(i).TR = df.TR(i,1); %TR (in seconds)
    subInfo(i).TRskip = df.dropFr(i); %number of frames to skip
    subInfo(i).topDir = df.topDir{i}; %initial part of directory structure
    subInfo(i).dataFolder = df.dataFolder{i}; % folder for data inputs (assume BIDS style organization otherwise)
    subInfo(i).confoundsFolder = df.confoundsFolder{i}; % folder for confound inputs (assume BIDS organization)
    subInfo(i).FDtype = df.FDtype{i,1}; %use FD or fFD for tmask, etc?
    subInfo(i).runs = str2double(regexp(df.runs{i},',','split'))'; % get runs, converting to numerical array (other orientiation since that's what's expected
    %subInfo(i).space = space; %assuming same space for now... insert check
    %subInfo(i).res = res; %assuming same res for now.. insert check
end

%% ROI info
atlas_params = atlas_parameters_GrattonLab(atlas,atlas_dir);
roi_data = load_untouch_nii_wrapper(atlas_params.MNI_nii_file); %vox by 1


%% Loop through data, extract timecourses
for i = 1:numdatas
    
    fprintf('Subject %s, session %d\n',subInfo(i).subjectID,subInfo(i).session);
    
    sess_roi_timeseries_concat{i} = [];
    tmask_concat{i} = [];
    
    for j = 1:length(subInfo(i).runs)
        
        fprintf('Run: %d\n',subInfo(i).runs(j));
        
        % FCprocessed file:
        procFile = sprintf('%s/sub-%s/ses-%d/func/sub-%s_ses-%d_task-%s_run-%02d_fmriprep_zmdt_resid_ntrpl_bpss_zmdt.nii.gz',...
            FCdir,subInfo(i).subjectID,subInfo(i).session,...
            subInfo(i).subjectID,subInfo(i).session,subInfo(i).condition,subInfo(i).runs(j));
        sess_data = load_untouch_nii_wrapper(procFile); %vox by timepoints
        
        sess_roi_timeseries{i,j} = roi_average_timecourse(sess_data,roi_data);
        sess_roi_timeseries_concat{i} = [sess_roi_timeseries_concat{i} sess_roi_timeseries{i,j}];
        
        % tmask file:
        tmaskFile = sprintf('%s/sub-%s/ses-%d/func/FD_outputs/sub-%s_ses-%d_task-%s_run-%02d_desc-tmask_%s.txt',...
            FCdir,subInfo(i).subjectID,subInfo(i).session,...
            subInfo(i).subjectID,subInfo(i).session,subInfo(i).condition,subInfo(i).runs(j),subInfo(i).FDtype);
        tmask{i,j} = table2array(readtable(tmaskFile));
        tmask_concat{i} = [tmask_concat{i}; tmask{i,j}];
                
    end
    
    % apply tmask to timeseries and calculate correlations
    sess_roi_correlations{i} = paircorr_mod(sess_roi_timeseries_concat{i}(:,tmask_concat{i}));
    
    figure_corrmat_network_generic(sess_roi_correlatoins{i},atlas_params,[-1 1]);

end

end

function roi_ts_avg = roi_average_timecourse(bold_data,roi_data)

nrois = unique(roi_data);
nrois = nrois(nrois>0); % assume 0 is not an ROI

for nr = 1:length(nrois)
    roi_vox = bold_data(roi_data==nrois(nr),:);
    roi_ts_avg(nr,:) = nanmean(roi_vox,1);
    num_nans = sum(isnan(roi_vox(:)));
    if num_nans>0
        warning(sprintf('ROI %03d contains nans',nrois));
    end
end

end