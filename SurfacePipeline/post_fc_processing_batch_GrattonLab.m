function post_fc_processing_batch(post_fc_processing_batch_params_file)
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

workbenchdir = '/projects/b1081/Scripts/workbench2/bin_rh_linux64/';
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
        preprocdata_names{i,r} = [preprocdata_fstring allstart_runs_fstring2{i,r} '_space-' space '_' res '_desc-preproc_bold.nii.gz']; %name may differ for afni outputs?
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


for s = 1:length(dataInfo.sub)
    subject = dataInfo.sub{s};  %each line can designate diff sub and sess together so don't need separate loops
    session = dataInfo.sess(s);
    TR = dataInfo.TR(s,1);
    
    disp(['Subject ' subject ', Session: ' num2str(session) ' CIFTI processing']);
    funcvol = [surffuncdir '/' allstart_fstring2{s} '_funcovl'];
    
    for r = 1:length(run_nums{s})
        disp(['Run: ' num2str(run_nums{r}(r))]);
        
        
        disp('Converting and copying data');
        subfunc_run = [fcprocessed_funcdata_dir '/sub-' subject '/ses-' session '/func/' allstart_runs_fstring2{s,r} fcprocessed_funcdata_dir_suffix];
        if ~exist([subfunc_run '.nii.gz'])
            error(['fc-processed subject data ' subfunc_run ' does not exist!']);
        end
        funcvol_run = [surffuncdir '/' allstart_runs_fstring2{s,r} '_funcvol'];
        
        %Remove NaNs from the data and copy to new location
        %evalc(['!niftigz_4dfp -n ' subfunc ' ' funcvol '_temp']); % already nifti
        %evalc(['!fslmaths ' funcvol '_temp -nan ' funcvol]);
        %delete([funcvol '_temp']);
        system(['fslmaths ' subfunc_run ' -nan ' funcvol_run]);
        
        
        %Identify high-SNR voxels
        disp('calculating high-SNR voxels from unprocessed functional data');
        tmask = table2array(readtable(tmask_names{s,r}));
        if ~exist(preprocdata_names{s,r})
            error(['Unprocessed subject data ' preprocdata_names{s,r} ' does not exist!'])
        end
        
        data = load_untouch_nii(preproc_runs{runnum});
        data.img = data.img(:,:,:,logical(tmask(runIDs==runnum)));
        if r == 1
            out = data;
        else
            newtimepoints = size(data.img,4);
            out.img(:,:,:,end+1:end+newtimepoints) = data.img;
        end
        clear data;
    end
    save_untouch_nii(out,[funcvol '_unprocessed_tmasked.nii.gz']);

    sequence_name = sprintf('ses-%d_task-%s',dataInfo.sess(s),dataInfo.task{s});
    goodvoxels_singlesub([funcvol '_unprocessed_tmasked'], fsLRfolder, goodvoxfolder,subject,sequence_name);
    
    %%%% CG - EDITS THROUGH ABOVE... need to finish goodvoxels edits still %%%
    
    %goodvoxels([funcvol '_unprocessed'], tmask, fs_LR_surfdir, goodvoxfolder,subject);  
        submask = [goodvoxfolder '/' subject '_goodvoxels.nii.gz'];
        
        
        
        % Sample volumes to surface, downsample, and smooth
        for hem = 1:2
            
            midsurf = [fs_LR_surfdir '/' subject '/7112b_fs_LR/Native/' subject '.' HEMS{hem} '.midthickness.native.surf.gii'];
            midsurf_LR32k = [fs_LR_surfdir '/' subject '/7112b_fs_LR/fsaverage_LR32k/' subject '.' HEMS{hem} '.midthickness.32k_fs_LR.surf.gii'];
            whitesurf = [fs_LR_surfdir '/' subject '/7112b_fs_LR/Native/' subject '.' HEMS{hem} '.white.native.surf.gii'];
            pialsurf = [fs_LR_surfdir '/' subject '/7112b_fs_LR/Native/' subject '.' HEMS{hem} '.pial.native.surf.gii'];
            nativedefsphere = [fs_LR_surfdir '/' subject '/7112b_fs_LR/Native/' subject '.' HEMS{hem} '.sphere.reg.reg_LR.native.surf.gii'];
            outsphere = [fs_LR_surfdir '/' subject '/7112b_fs_LR/fsaverage_LR32k/' subject '.' HEMS{hem} '.sphere.32k_fs_LR.surf.gii'];
            surfname = [subject '_' HEMS{hem}];
            
            string = ['Subject ' subject ': mapping ' HEMS{hem} ' hemisphere data to surface'];
            fprintf([repmat('\b',1,length(prevstring)) '%s'],string);
            prevstring = string;
            evalc(['!' workbenchdir '/wb_command -volume-to-surface-mapping ' funcvol '.nii.gz ' midsurf ' ' surffuncdir '/' surfname '.func.gii -ribbon-constrained ' whitesurf ' ' pialsurf ' -volume-roi ' submask]);
            
            string = ['Subject ' subject ': Dilating ' HEMS{hem} ' hemisphere surface timecourse'];
            fprintf([repmat('\b',1,length(prevstring)) '%s'],string);
            prevstring = string;
            evalc(['!' workbenchdir '/wb_command -metric-dilate ' surffuncdir '/' surfname '.func.gii ' midsurf ' 10 ' surffuncdir '/' surfname '_dil10.func.gii']);
            
            string = ['Subject ' subject ': Deforming ' HEMS{hem} ' hemisphere timecourse to 32k fs_LR'];
            fprintf([repmat('\b',1,length(prevstring)) '%s'],string);
            prevstring = string;
            evalc(['!' workbenchdir '/wb_command -metric-resample ' surffuncdir '/' surfname '_dil10.func.gii ' nativedefsphere ' ' outsphere ' ADAP_BARY_AREA ' surffuncdir '/' surfname '_dil10_32k_fs_LR.func.gii -area-surfs ' midsurf ' ' midsurf_LR32k]);
            
            string = ['Subject ' subject ': Smoothing ' HEMS{hem} ' hemisphere surface timecourse'];
            fprintf([repmat('\b',1,length(prevstring)) '%s'],string);
            prevstring = string;
            evalc(['!' workbenchdir '/wb_command -metric-smoothing ' midsurf_LR32k ' ' surffuncdir '/' surfname '_dil10_32k_fs_LR.func.gii ' num2str(smoothnum) ' ' surffuncdir '/' surfname '_dil10_32k_fs_LR_smooth' num2str(smoothnum) '.func.gii']);
            
            surfname_final{hem} = [surffuncdir '/' surfname '_dil10_32k_fs_LR_smooth' num2str(smoothnum) '.func.gii'];
            
            evalc(['!caret_command64 -file-convert -format-convert XML_BASE64 ' surfname_final{hem}]);
            
            delete([surffuncdir '/' surfname '.func.gii']);
            delete([surffuncdir '/' surfname '_dil10.func.gii']);
            delete([surffuncdir '/' surfname '_dil10_32k_fs_LR.func.gii']);
        end
        
        
        
        % Smooth data in volume within mask
        string = ['Subject ' subject ': Smoothing functional data within volume mask'];
        fprintf([repmat('\b',1,length(prevstring)) '%s'],string);
        prevstring = string;
        
        funcvol_ROIsmooth = [funcvol '_wROI255'];
        evalc(['!' workbenchdir '/wb_command -volume-smoothing ' funcvol '.nii.gz ' num2str(smoothnum) ' ' funcvol_ROIsmooth '.nii.gz -roi ' subcort_mask]);
        
        delete([funcvol '.nii.gz'])
        delete([funcvol '_unprocessed.nii.gz'])
        
        
        
        % Create cifti timeseries
        string = ['Subject ' subject ': Combining surface and volume data to create cifti timeseries'];
        fprintf([repmat('\b',1,length(prevstring)) '%s'],string);
        prevstring = string;
        
        evalc(['!' workbenchdir '/wb_command -cifti-create-dense-timeseries ' ciftidir '/' subject '_LR_surf_subcort_333_32k_fsLR_smooth' num2str(smoothnum) '.dtseries.nii -volume ' funcvol_ROIsmooth '.nii.gz ' subcort_mask ' -left-metric ' surfname_final{1} ' -roi-left ' medial_mask_L ' -right-metric ' surfname_final{2} ' -roi-right ' medial_mask_R ' -timestep ' num2str(TR) ' -timestart 0']);
        dlmwrite(outputdatalistname,[subject '  ' ciftidir '/' subject '_LR_surf_subcort_333_32k_fsLR_smooth' num2str(smoothnum) '.dtseries.nii'],'-append','delimiter','');
        
        if do_smallwall
            evalc(['!' workbenchdir '/wb_command -cifti-create-dense-timeseries ' ciftiswdir '/' subject '_LR_surf_subcort_333_32k_fsLR_smooth' num2str(smoothnum) '.dtseries.nii -volume ' funcvol_ROIsmooth '.nii.gz ' subcort_mask ' -left-metric ' surfname_final{1} ' -roi-left ' sw_medial_mask_L ' -right-metric ' surfname_final{2} ' -roi-right ' sw_medial_mask_R ' -timestep ' num2str(TR) ' -timestart 0']);
            dlmwrite(outputdatalistname_sw,[subject '  ' ciftiswdir '/' subject '_LR_surf_subcort_333_32k_fsLR_smooth' num2str(smoothnum) '.dtseries.nii'],'-append','delimiter','');
        end
        
        delete([funcvol_ROIsmooth '.nii.gz'])
        
        
    end
    
end
disp(' ')