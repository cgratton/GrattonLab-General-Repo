function make_dconn_session_wrapper()
% Wrapper for make_dconn that concatenates a person's data
% (from 1+ sessions) to make a dconn

addpath(genpath('/projects/b1081/Scripts'))

data_folder = '/projects/b1081/iNetworks/Nifti/derivatives/postFCproc_CIFTI/';
tmask_folder = '/projects/b1081/iNetworks/Nifti/derivatives/preproc_fmriprep-20.0.6/fmriprep/';
template_fname = '/projects/b1081/iNetworks/Nifti/derivatives/postFCproc_CIFTI/cifti_timeseries_normalwall/sub-INET003_ses-1_task-rest_run-01_LR_surf_subcort_222_32k_fsLR_smooth2.55.dtseries.nii';
subject = 'INET003';
sessions = [1]; %[1,2,3,4], can be 1+
runs = [7,7,6,6]; % assumes these are numbered 1:runnum, in order of sessions above
output_file = sprintf('%s/dconn_cifti_normalwall/sub-%s_allsess_tmasked.dconn.nii', data_folder, subject); %CHANGE IF NEEDED

%LOAD AND CONCATENATE DATA
catData = [];
catTmask = [];
for i = 1:numel(sessions)
    for j = 1:runs(i)
        disp(sprintf('Loading data for session %d run %02d...', sessions(i), j))
        data = ft_read_cifti_mod(sprintf('%s/cifti_timeseries_normalwall/sub-%s_ses-%d_task-rest_run-%02d_LR_surf_subcort_222_32k_fsLR_smooth2.55.dtseries.nii',data_folder,subject,sessions(i),j));
        input_data = data.data;
        clear data;

        disp(sprintf('Loading tmask for session %d run %02d...', sessions(i), j))
        tmask = sprintf('%s/sub-%s/ses-%d/func/FD_outputs/sub-%s_ses-%d_task-rest_run-%02d_desc-tmask_fFD.txt',tmask_folder,subject,sessions(i),subject,sessions(i),j);
        tmask_data = table2array(readtable(tmask)); 
        
        % apply tmask
        %masked_data = input_data(:,logical(tmask_data));
        %clear tmask_data;
        %clear input_data;
        
        % concatenate
        disp('concatenating data')
        catData = [catData input_data];        
        catTmask = [catTmask tmask_data];
        disp(sprintf('data size is now %d by %d', size(catData,1), size(catData,2)))
        %clear masked_data;
        clear input_data;
        clear tmask_data;
    end
end

make_dconn(catData,catTmask,template_fname,1,output_file);