function FDcalc_FMRIPREP(topdir,preprocType,subject,sessions,varargin)
% function for calculating FD and making tmasks from FMRIPREP
% difference from FMRIPREP output: filters FD values, does more
% conservative tmasking (contig frames, min per run, etc.)
%
% Dependencies:
% need the BIDS matlab toolbox in your path to load confounds: https://github.com/bids-standard/bids-matlab
% plotting_utilities: hline_new.m (see GrattonLab Scripts folder - better hline)
%
% Primary settings that change (make these inputs eventually)
%topdir = '~/Box/DATA/Lifespan/BIDS/Nifti/derivatives/'; % change to /projects/b1081/ if running on Quest; change to ~/Box/DATA/iNetworks/BIDS/derivatives/ for more permanent storage on Box; keep in Backup ONLY for testing
%preprocType = 'fmriprep'; % change this as need to point to correct folder (e.g., fmriprep-1.5.8)
%subject = 'LS03'; % subject ID
%sessions = [1:3]; % list of session numbers
%varargin: structure with project specific information on
%FD/filtering parameters (see below for standard examples if this
%isn't provided

    
%%% Directory structure
projectdir = [topdir 'preproc_' preprocType '/fmriprep/sub-' subject '/'];
input_filestr = 'confounds_regressors.tsv'; %search for all files for all runs

%%% FD/filtering parameters (these will probably be constant within a study but potentially vary across studies)
if nargin == 4
    % if FD/filtering parameters are not provided, use these
    % defaults from iNetworks
TR = 1.1; 
contig_frames = 5; % Number of continuous samples w/o high FD necessary for inclusion           
DropFramesSec = 30; % number of seconds of frames to drop at the start of each run
DropFramesTR = round(DropFramesSec/TR); % Calculate num TRs to drop
headSize = 50; % assume 50 mm head radius
FDthresh = 0.2;
fFDthresh = 0.1;
run_min = 50; % minimum number of frames in a run
tot_min = 150; % minimum number of frames needed across all runs
else
    % assume varargin{1} = structure with each of the following fields
    TR = varargin{1}.TR;
    contig_frames = varargin{1}.contig_frames;
    DropFramesSec = varargin{1}.DropFramesSec;
    DropFramesTR = round(DropFramesSec/TR);
    headsize = varargin{1}.headsize;
    FDthresh = varargin{1}.FDthresh;
    fFDthresh = varargin{1}.fFDthresh;
    run_min = varargin{1}.run_min;
    tot_min = varargin{1}.tot_min;
end

    
              
% fmriprep relevant field names from confounds file
%   order in most sensible order you like 
%   n.b: rotation parameters are in radians (from FSL mcflirt)
mvm_fields = {'trans_x','trans_y','trans_z','rot_x','rot_y','rot_z'};
rot_IDs = logical([0 0 0 1 1 1]); 

for ses = sessions
    
    % where is the data stored for this particular session
    inputdir = [projectdir 'ses-' num2str(ses) '/func/'];
    outputdir = [inputdir 'FD_outputs/'];
    if ~exist(outputdir)
        mkdir(outputdir);
    end
    
    % search for relevant motion files
    infiles = dir([inputdir '*' input_filestr]);
    
    for i = 1:length(infiles)
        
        % load motion data
        % assume fmriprep data organization
        confounds = bids.util.tsvread([inputdir infiles(i).name]); %reads into a structure, each field = col in tsv
        
        % str for naming output (contains subject, task, and run info):
        outstr = infiles(i).name(1:end-length(input_filestr));
        
        % make a single matrix organized as we want
        mot_data_orig = [];
        for m = 1:length(mvm_fields)
            mot_data_orig = [mot_data_orig confounds.(mvm_fields{m})];
        end        
       
        % start by doing some conversions
        % Convert roll, pitch, and yaw to mm (other parameters already in
        % mm). fmriprep = rotation in radians
        mot_data(:,rot_IDs) = mot_data_orig(:,rot_IDs).* headSize ; %.* 2 * pi./360; % rotation params modified
        mot_data(:,~rot_IDs) = mot_data_orig(:,~rot_IDs); % translation params stay the same
        
        % filter mot data
        mot_data_filtered = filter_motion(TR,mot_data);
        %% these lines might need changing throughout the code or txt files might not save appropriately
        %Here are two option: writematrix is more likely to work, but
        %adding -ascii, -double, and -tabs to the save command works for
        %some of these lines (not all). Change throughout the code!
        %writematrix(mot_data,sprintf('%s%smvm.txt',outputdir,outstr));
        save(sprintf('%s%smvm.txt',outputdir,outstr),'mot_data', '-ascii', '-double', '-tabs');
        writematrix(mot_data_filtered,sprintf('%s%smvm_filt.txt',outputdir,outstr));
        %save(sprintf('%s%smvm_filt.txt',outputdir,outstr),'mot_data_filtered', '-ascii');
        
        % calculate FD pre and post filtering
        mot_data_diff = [zeros(1,6); diff(mot_data)];
        mot_data_filt_diff = [zeros(1,6); diff(mot_data_filtered)];
        FD = sum(abs(mot_data_diff),2);
        fFD = sum(abs(mot_data_filt_diff),2);
        writematrix(FD,sprintf('%s%sFD.txt',outputdir,outstr));
        %save(sprintf('%s%sFD.txt',outputdir,outstr),'FD', '-ascii');
        writematrix(fFD,sprintf('%s%sfFD.txt',outputdir,outstr));
        %save(sprintf('%s%sfFD.txt',outputdir,outstr),'fFD', '-ascii');
        
        % plot original parameters & FD
        plot_motion_params(mot_data,FD,FDthresh,mvm_fields);
        print(gcf,sprintf('%s%smotion_parameters.pdf',outputdir,outstr),'-dpdf','-bestfit');
        plot_motion_params(mot_data_filtered,fFD,fFDthresh,mvm_fields);
        print(gcf,sprintf('%s%smotion_parameters_filtered.pdf',outputdir,outstr),'-dpdf','-bestfit');
        
        % make some plots - FFT
        mot_FFT(mot_data,TR,1);
        print(gcf,sprintf('%s%smotion_FFT.pdf',outputdir,outstr),'-dpdf','-bestfit');
        mot_FFT(mot_data_filtered,TR,1);
        print(gcf,sprintf('%s%smotion_filtered_FFT.pdf',outputdir,outstr),'-dpdf','-bestfit');
        
        % make a tmask for each run
        tmask_FD = make_tmask(FD,FDthresh,DropFramesTR,contig_frames);
        tmask_fFD = make_tmask(fFD,fFDthresh,DropFramesTR,contig_frames);
        writematrix(tmask_FD,sprintf('%s%stmask_FD.txt',outputdir,outstr));
        %save(sprintf('%s%stmask_FD.txt',outputdir,outstr),tmask_FD, '-ascii');
        writematrix(tmask_fFD,sprintf('%s%stmask_fFD.txt',outputdir,outstr));
        %save(sprintf('%s%stmask_fFD.txt',outputdir,outstr),'tmask_fFD', '-ascii');
        
        % some stats to keep track of
        good_run_FD(i) = sum(tmask_FD) > run_min;
        good_run_fFD(i) = sum(tmask_fFD) > run_min;
        run_frame_nums_FD(i) = sum(tmask_FD);
        run_frame_nums_fFD(i) = sum(tmask_fFD);
        run_frame_per_FD(i) = sum(tmask_FD)./numel(tmask_FD);
        run_frame_per_fFD(i) = sum(tmask_fFD)./numel(tmask_fFD);
        
        close('all');
        clear mot_data;        
    end
    
    % save out some general info
    writematrix(good_run_FD,sprintf('%sgoodruns_FD.txt',outputdir));
    %save(sprintf('%sgoodruns_FD.txt',outputdir),'good_run_FD', '-ascii', '-double', '-tabs');
    writematrix(good_run_fFD, sprintf('%sgoodruns_fFD.txt',outputdir));
    %save(sprintf('%sgoodruns_fFD.txt',outputdir),'good_run_fFD', '-ascii');
    
    writematrix(run_frame_nums_FD,sprintf('%sframenums_FD.txt',outputdir));
    %save(sprintf('%sframenums_FD.txt',outputdir),'run_frame_nums_FD', '-ascii');
    writematrix(run_frame_nums_fFD,sprintf('%sframenums_fFD.txt',outputdir));
    %save(sprintf('%sframenums_fFD.txt',outputdir),'run_frame_nums_fFD', '-ascii');
    
    writematrix(run_frame_per_FD,sprintf('%sframepers_FD.txt',outputdir));
    %save(sprintf('%sframepers_FD.txt',outputdir),'run_frame_per_FD', '-ascii', '-double', '-tabs');
    writematrix(run_frame_per_fFD,sprintf('%sframepers_fFD.txt',outputdir));
    %save(sprintf('%sframepers_fFD.txt',outputdir),'run_frame_per_fFD', '-ascii');
    
    clear good_run_FD run_frame_nums_FD run_frame_per_FD;
    clear good_run_fFD run_frame_nums_fFD run_frame_per_fFD;
end

end

function plot_motion_params(mot_data,FD,FDthresh,param_names)
figure('Position',[1 1 800 1000]);

subplot(2,3,1:3)
title('motion')
plot(mot_data);
%legend('Roll', 'Pitch', 'Yaw', 'Z', 'X', 'Y');
legend(param_names);
xlim([1,size(mot_data,1)]);
xlabel('TR');
ylabel('mm');

subplot(2,3,4:6);
title('FD');
plot(FD);
hline_new(FDthresh,'k',1);
xlim([1,length(FD)]);
xlabel('TR');
ylabel('mm');

end


