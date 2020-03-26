function fcimage_corrmat_volume(datafile,FCdir,atlas)
% function fcimage_corrmat_volume()
% this function will make an ROI x ROI correlation matrix based on a set of
% volume ROIs and a list of files
%
% CG - 03.26.2020
%%%%%%%%%%%%%%%%%

%% Output directory
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
    subInfo(i).space = space;
    subInfo(i).res = res;
end

%% ROI info




%% Loop through data, extract timecourses
for i = 1:numdatas
    
    for j = 1:length(subInfo(i).runs)
        
        % FCprocessed file:
        procFile = sprintf('%s/sub-%s/ses-%d/func/sub-%s_ses-%d_task-%s_run-%02d_fmriprep_zmdt_resid_ntrpl_bpss_zmdt.nii.gz',...
            FCdir,subInfo(i).subjectID,subInfo(i).session,...
            subInfo(i).subjectID,subInfo(i).session,subInfo(i).condition,subInfo(i).runs(j));

        
    end
    
end

aa = bb; 