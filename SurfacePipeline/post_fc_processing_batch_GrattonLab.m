function post_fc_processing_batch_GrattonLab(post_fc_processing_batch_params_file)
%post_fc_processing_batch(post_fc_processing_batch_params_file)
% EX: post_fc_processing_batch_GrattonLab('post_fc_processing_batch_params_iNetworks.m')
%
% Run through post fc-processing, creating cifti timeseries from
% unsmoothed fc-processed functional data.
%
% You must have FSLv5.0.6 or later in your path. Earlier versions of FSL
% produce a mysterious alignment error.
%
% Requires the FULL PATH to a parameters file (a .m file) which will be
% executed to load needed parameters, including:
%
% a datalist and a tmasklist, as used by FCPROCESS
% the location of the fc-processed data
% an output folder for the cifti timeseries
% the location of a subcortical mask
% the location of subjects' fs_LR-registered cortical surfaces
% the locations of a priori left and right hemisphere atlas medial wall masks
% the locations of a priori left and right hemisphere "smallwall" medial wall masks
% the sigma of the smoothing kernel to apply to the data
%
%
% Requires the Cifti Resources scripts to be in your path (e.g.,
% /data/cn/data1/scripts/CIFTI_RELATED/Resources/ and subfolders)
%
%EMG 06/24/15
% CG 05/2020 - edit to work at NU


%Find params file
[paramspath,paramsname,paramsextension] = fileparts(post_fc_processing_batch_params_file);
origpath = pwd;
if ~isempty(paramspath)
    cd(paramspath)
end

%Load parameters
params = feval(paramsname);
varnames = fieldnames(params);
for i = 1:length(varnames)
    evalc([varnames{i} ' = params.' varnames{i}]);
end
clear varnames params

cd(origpath)

do_smallwall = true;
if (~exist('sw_medial_mask_L','var')) || (~exist('sw_medial_mask_R','var')) || isempty(sw_medial_mask_L) || isempty(sw_medial_mask_R)
    do_smallwall = false;
end



%-------------------------------------------------------------------------

warning off
mkdir(outfolder)
surffuncdir = [outfolder '/surf_timecourses/'];
ciftidir = [outfolder '/cifti_timeseries_normalwall/'];
ciftiswdir = [outfolder '/cifti_timeseries_smallwall/'];
goodvoxfolder = [outfolder '/goodvoxels/'];
outputdatalistname = [outfolder '/cifti_datalist.txt'];
outputdatalistname_sw = [outfolder '/cifti_datalist_smallwall.txt'];
%Make folders
mkdir(surffuncdir);
mkdir(ciftidir);
mkdir(goodvoxfolder);
if do_smallwall
    mkdir(ciftiswdir);
end

workbenchdir = '/projects/b1081/Scripts/workbench2/bin_linux64/';
Caret5_Command = '/projects/b1081/Scripts/caret/bin_linux64/';
HEMS = {'L';'R'};


%[funcdirs, subjects, prmfiles, TRs, skip] = textread(datalist,'%s %s %s %s %s');
%[~, tmasks] = textread(tmasklist,'%s %s');
dataInfo = readtable(datalist); %reads into a table structure, with datafile top row as labels
numdatas=size(dataInfo.sub,1); %number of datasets to analyses (subs X sessions)
for i=1:numdatas
    run_nums{i} = str2double(regexp(dataInfo.runs{i},',','split'))'; % get runs, converting to numerical array (other orientiation since that's what's expected
        
    % some useful strings
    conf_fstring{i} = sprintf('%s/%s/fmriprep/sub-%s/ses-%d/func/',dataInfo.topDir{i},dataInfo.confoundsFolder{i},dataInfo.sub{i},dataInfo.sess(i));
    preprocdata_fstring{i} = sprintf('%s/%s/fmriprep/sub-%s/ses-%d/func/',dataInfo.topDir{i},dataInfo.dataFolder{i},dataInfo.sub{i},dataInfo.sess(i));
    allstart_fstring2{i} = sprintf('sub-%s_ses-%d_task-%s',dataInfo.sub{i},dataInfo.sess(i),dataInfo.task{i});
    for r = 1:length(run_nums{i})
        allstart_runs_fstring2{i,r} = sprintf('sub-%s_ses-%d_task-%s_run-%02d',dataInfo.sub{i},dataInfo.sess(i),dataInfo.task{i},run_nums{i}(r));
        tmask_names{i,r} = [conf_fstring{i} 'FD_outputs/' allstart_runs_fstring2{i,r} '_desc-tmask_' dataInfo.FDtype{i} '.txt']; %assume this is in confounds folder
        %preprocdata_names{i,r} = [preprocdata_fstring{i} allstart_runs_fstring2{i,r} '_space-' space '_' res '_desc-preproc_bold.nii.gz']; %name may differ for afni outputs?
        % TEMP FOR TESTING - changed to exclude res for older version of fmriprep
        preprocdata_names{i,r} = [preprocdata_fstring{i} allstart_runs_fstring2{i,r} '_space-' space '_desc-preproc_bold.nii.gz']; %name may differ for afni outputs?
    end
end


prevstring = [];

delete(outputdatalistname);
fid = fopen(outputdatalistname,'at'); %open the output file for writing
fclose(fid);

if do_smallwall
    delete(outputdatalistname_sw);
    fid = fopen(outputdatalistname_sw,'at'); %open the output file for writing
    fclose(fid);
end


%%% estimate goodvoxels for each subject
force_remake_concat = 0; %force remake the concatenated preproc dataset? (Takes long time)
force_ribbon = 0; %force remake the single subject ribbon (Takes medium time)
force_goodvoxels = 0; %force remake the goodvoxels mask (Takes medium-short time)
goodvox_fnames = goodvoxels_wrapper(dataInfo,tmask_names,preprocdata_names,surffuncdir,allstart_fstring2,run_nums,fs_LR_surfdir,goodvoxfolder,...
    T1name_end,space_short,force_remake_concat,force_ribbon,force_goodvoxels);

for s = 1:length(dataInfo.sub)
    
    tic;
    
    subject = dataInfo.sub{s};  %each line can designate diff sub and sess together so don't need separate loops
    session = num2str(dataInfo.sess(s));
    TR = dataInfo.TR(s,1);
    
    disp(['Subject ' subject ', Session: ' session ' CIFTI processing']);
    funcvol = [surffuncdir '/' allstart_fstring2{s} '_funcvol'];
    
    for r = 1:length(run_nums{s})
        disp(['Run: ' num2str(run_nums{s}(r))]);
        
        
        disp('Converting and copying data');
        subfunc_run = [fcprocessed_funcdata_dir '/sub-' subject '/ses-' session '/func/' allstart_runs_fstring2{s,r} fcprocessed_funcdata_dir_suffix];
        if ~exist([subfunc_run '.nii.gz'])
            error(['fc-processed subject data ' subfunc_run ' does not exist!']);
        end
        subfunc_run_this = [surffuncdir '/' allstart_runs_fstring2{s,r} '_funcvol'];
        
        %Remove NaNs from the data and copy to new location
        system(['module load fsl/5.0.8; fslmaths ' subfunc_run ' -nan ' subfunc_run_nan]); 
        % CG - for some reason this command un-mean centers the data, so
        % commenting out for now. Don't think we have nans?
        %system(['cp ' subfunc_run '.nii.gz ' subfunc_run_this '.nii.gz']);
        
        % CG - made edits to bring goodvoxels out of this loop (see wrapper
        % script above)
        submask = goodvox_fnames{s}; %[goodvoxfolder '/' subject '_goodvoxels.nii.gz'];
       
        
        
        % Sample volumes to surface, downsample, and smooth
        for hem = 1:2
            
            midsurf = [fs_LR_surfdir '/sub-' subject '/' space_short '/Native/sub-' subject '.' HEMS{hem} '.midthickness.native.surf.gii'];
            midsurf_LR32k = [fs_LR_surfdir '/sub-' subject '/' space_short '/fsaverage_LR32k/sub-' subject '.' HEMS{hem} '.midthickness.32k_fs_LR.surf.gii'];
            whitesurf = [fs_LR_surfdir '/sub-' subject '/' space_short '/Native/sub-' subject '.' HEMS{hem} '.white.native.surf.gii'];
            pialsurf = [fs_LR_surfdir '/sub-' subject '/' space_short '/Native/sub-' subject '.' HEMS{hem} '.pial.native.surf.gii'];
            nativedefsphere = [fs_LR_surfdir '/sub-' subject '/' space_short '/Native/sub-' subject '.' HEMS{hem} '.sphere.reg.reg_LR.native.surf.gii'];
            outsphere = [fs_LR_surfdir '/sub-' subject '/' space_short '/fsaverage_LR32k/sub-' subject '.' HEMS{hem} '.sphere.32k_fs_LR.surf.gii'];
            surfname = [allstart_runs_fstring2{s,r} '_' HEMS{hem}];
            
            %%%% FOR TESTING
            disp(['Hemisphere: ' HEMS{hem}]);
            disp('...mapping data to surface');
            system([workbenchdir '/wb_command -volume-to-surface-mapping ' subfunc_run_this '.nii.gz ' midsurf ' ' surffuncdir '/' surfname '.func.gii -ribbon-constrained ' whitesurf ' ' pialsurf ' -volume-roi ' submask]);
            
            disp('... dilating surface timecourse');
            system([workbenchdir '/wb_command -metric-dilate ' surffuncdir '/' surfname '.func.gii ' midsurf ' 10 ' surffuncdir '/' surfname '_dil10.func.gii']);

            disp('... deforming to 32k fs_LR');
            system([workbenchdir '/wb_command -metric-resample ' surffuncdir '/' surfname '_dil10.func.gii ' nativedefsphere ' ' outsphere ' ADAP_BARY_AREA ' surffuncdir '/' surfname '_dil10_32k_fs_LR.func.gii -area-surfs ' midsurf ' ' midsurf_LR32k]);
            
            disp('... smoothing surface timecourse');
            system([workbenchdir '/wb_command -metric-smoothing ' midsurf_LR32k ' ' surffuncdir '/' surfname '_dil10_32k_fs_LR.func.gii ' num2str(smoothnum) ' ' surffuncdir '/' surfname '_dil10_32k_fs_LR_smooth' num2str(smoothnum) '.func.gii']);
            
            disp('... format convert')
            surfname_final{hem} = [surffuncdir '/' surfname '_dil10_32k_fs_LR_smooth' num2str(smoothnum) '.func.gii'];            
            system([Caret5_Command 'caret_command -file-convert -format-convert XML_BASE64 ' surfname_final{hem}]);
            
            delete([surffuncdir '/' surfname '.func.gii']);
            delete([surffuncdir '/' surfname '_dil10.func.gii']);git
            delete([surffuncdir '/' surfname '_dil10_32k_fs_LR.func.gii']);
        end

        
        disp('done with hemispheres');
        
        % Smooth data in volume within mask
        disp('... smothing functional data in volume');        
        funcvol_run_ROIsmooth = [subfunc_run_this '_wROI255'];       
        system([workbenchdir '/wb_command -volume-smoothing ' subfunc_run_this '.nii.gz ' num2str(smoothnum) ' ' funcvol_run_ROIsmooth '.nii.gz -roi ' subcort_mask]);
        delete([subfunc_run_this '.nii.gz'])
        %delete([funcvol_run '_unprocessed.nii.gz']) - this is associated
        %with goodvoxels wrapper. Delete there? It takes a long time to
        %make.
        
        
        % Create cifti timeseries
        disp('... combining surface and volume data to create cifti timeseries')
        system([workbenchdir '/wb_command -cifti-create-dense-timeseries ' ciftidir '/' allstart_runs_fstring2{s,r} '_LR_surf_subcort_' res_short '_32k_fsLR_smooth' num2str(smoothnum) '.dtseries.nii -volume ' funcvol_run_ROIsmooth '.nii.gz ' subcort_mask ' -left-metric ' surfname_final{1} ' -roi-left ' medial_mask_L ' -right-metric ' surfname_final{2} ' -roi-right ' medial_mask_R ' -timestep ' num2str(TR) ' -timestart 0']);
        dlmwrite(outputdatalistname,[subject '  ' ciftidir '/' allstart_runs_fstring2{s,r} '_LR_surf_subcort_' res_short '_32k_fsLR_smooth' num2str(smoothnum) '.dtseries.nii'],'-append','delimiter','');
        
        if do_smallwall
            system([workbenchdir '/wb_command -cifti-create-dense-timeseries ' ciftiswdir '/' allstart_runs_fstring2{s,r} '_LR_surf_subcort_' res_short '_32k_fsLR_smooth' num2str(smoothnum) '.dtseries.nii -volume ' funcvol_run_ROIsmooth '.nii.gz ' subcort_mask ' -left-metric ' surfname_final{1} ' -roi-left ' sw_medial_mask_L ' -right-metric ' surfname_final{2} ' -roi-right ' sw_medial_mask_R ' -timestep ' num2str(TR) ' -timestart 0']);
            dlmwrite(outputdatalistname_sw,[subject '  ' ciftiswdir '/' allstart_runs_fstring2{s,r} '_LR_surf_subcort_' res_short '_32k_fsLR_smooth' num2str(smoothnum) '.dtseries.nii'],'-append','delimiter','');
        end
        
        delete([funcvol_run_ROIsmooth '.nii.gz'])
        
        
    end
    
    toc;
    
end

end

function goodvox_fname = goodvoxels_wrapper(dataInfo,tmask_names,preprocdata_names,surffuncdir,allstart_fstring2,run_nums,fsLRfolder,goodvoxfolder,T1name_end,space_short,force_make_concat,force_ribbon,force_goodvoxels)

for s = 1:length(dataInfo.sub)
    subject = dataInfo.sub{s};  %each line can designate diff sub and sess together so don't need separate loops
    session = dataInfo.sess(s);
    TR = dataInfo.TR(s,1);
    
    disp(['Subject ' subject ', Session: ' num2str(session) ' CIFTI processing']);
    
    preproc_concat_data_outname = [surffuncdir '/' allstart_fstring2{s} '_funcvol_unFCproc_tmasked.nii.gz'];
    if ~exist(preproc_concat_data_outname) || force_make_concat
        
        
        for r = 1:length(run_nums{s})
            disp(['Run: ' num2str(run_nums{s}(r))]);
            
            %Identify high-SNR voxels
            disp('loading un FCprocessed functional data');
            tmask = table2array(readtable(tmask_names{s,r}));
            if ~exist(preprocdata_names{s,r})
                error(['Un FCprocessed subject data ' preprocdata_names{s,r} ' does not exist!'])
            end
            
            data = load_untouch_nii(preprocdata_names{s,r});
            data.img = data.img(:,:,:,logical(tmask));
            if r == 1
                out = data;
            else
                newtimepoints = size(data.img,4);
                out.img(:,:,:,end+1:end+newtimepoints) = data.img;
            end
            clear data;
        end
        disp('Saving concatenated tmasked unFCproc data');
        save_untouch_nii(out,preproc_concat_data_outname);
    else
        disp('>>>WARNING: using previously made concatenated tmask data. If not desired, change settings to force make');
    end
    

    %Identify high-SNR voxels
    disp('calculating high-SNR voxels from un FCprocessed functional data');
    sequence_name = sprintf('sub-%s_ses-%d_task-%s',subject,session,dataInfo.task{s});
    fsLRfolder_sub = [fsLRfolder '/sub-' subject '/' space_short '/'];
    T1name = ['sub-' subject T1name_end];
    goodvox_fname{s} = [goodvoxfolder '/' sequence_name '_goodvoxels.nii.gz'];
    if ~exist(goodvox_fname{s}) || force_goodvoxels
        goodvoxels_singlesub_GrattonLab(preproc_concat_data_outname, fsLRfolder_sub, goodvoxfolder,subject,sequence_name,T1name,force_ribbon);
    else
        disp('>>> WARNING: using previously calculated goodvoxels map for this sub and sess. To remake, set to force');
    end
    
end
end