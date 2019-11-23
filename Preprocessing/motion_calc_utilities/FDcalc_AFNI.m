function FDcalc_AFNI()
% function for calculating FD and making tmasks from AFNI
% eventually should feed in directory structure/variables above

%%% Directory structure
inputdir = '~/Desktop/iNet006MotionData/';
outdir = inputdir;
input_filestr = 'mot_demean.r'; %search for all files for all runs (separate by runs to find borders, based on AFNI proc)

%%% Variables
TR = 1.1; 
%plotdata = 0; % Plot each run as a separate file
contig_frames = 5; % Number of continuous samples w/o high FD necessary for inclusion           
DropFramesSec = 30; % number of seconds of frames to drop at the start of each run
DropFramesTR = round(DropFramesSec/TR); % Calculate num TRs to drop
headSize = 50; % assume 50 mm head radius
FDthresh = 0.2;
fFDthresh = 0.1;
run_min = 50; % minimum number of frames in a run
tot_min = 150; % minimum number of frames needed across all runs
              
% search for relevant motion files and loop
infiles = dir([inputdir input_filestr '*.1D']);

for i = 1:length(infiles)
    
    % load motion data
    % assume AFNI data structure: roll, pitch, yaw, z x y
    % roll, pitch, and yaw are in deg
    tmp = load([inputdir infiles(i).name]);
    
    % remove all zero data (not sure why AFNI includes this for all runs?)
    mot_data_orig = tmp(sum(tmp,2)~=0,:);
    
    % start by doing some conversions
    % Convert roll, pitch, and yaw to mm (other parameters already in mm)
    mot_data(:,1:3) = mot_data_orig(:,1:3).* headSize .* 2 * pi./360;
    mot_data(:,4:6) = mot_data_orig(:,4:6);
    
    % filter mot data
    mot_data_filtered = filter_motion(TR,mot_data);
    save(sprintf('%smvm.r%02d.txt',outdir,i),'mot_data');
    save(sprintf('%smvm_filt.r%02d.txt',outdir,i),'mot_data_filtered');
    
    % calculate FD pre and post filtering
    mot_data_diff = [zeros(1,6); diff(mot_data)];
    mot_data_filt_diff = [zeros(1,6); diff(mot_data_filtered)];
    FD = sum(abs(mot_data_diff),2);
    fFD = sum(abs(mot_data_filt_diff),2);
    save(sprintf('%sFD.r%02d.txt',outdir,i),'FD');
    save(sprintf('%sfFD.r%02d.txt',outdir,i),'fFD');
    
    % plot original parameters & FD
    plot_motion_params(mot_data,FD,FDthresh);
    print(gcf,sprintf('%smotion_parameters.r%02d.pdf',outdir,i),'-dpdf','-bestfit');
    plot_motion_params(mot_data_filtered,fFD,fFDthresh);
    print(gcf,sprintf('%smotion_parameters_filtered.r%02d.pdf',outdir,i),'-dpdf','-bestfit');
    
    % make some plots - FFT
    mot_FFT(mot_data,TR,1);
    print(gcf,sprintf('%smotion_FFT.r%02d.pdf',outdir,i),'-dpdf','-bestfit');
    mot_FFT(mot_data_filtered,TR,1);
    print(gcf,sprintf('%smotion_filtered_FFT.r%02d.pdf',outdir,i),'-dpdf','-bestfit');
    
    % make a tmask for each run
    tmask_FD = make_tmask(FD,FDthresh,DropFramesTR,contig_frames);
    tmask_fFD = make_tmask(fFD,fFDthresh,DropFramesTR,contig_frames);   
    save(sprintf('%stmask_FD.r%02d.txt',outdir,i),'tmask_FD');
    save(sprintf('%stmask_fFD.r%02d.txt',outdir,i),'tmask_fFD');
    
    % some stats to keep track of
    good_run_FD(i) = sum(tmask_FD) > run_min;
    good_run_fFD(i) = sum(tmask_fFD) > run_min;
    run_frame_nums_FD(i) = sum(tmask_FD);
    run_frame_nums_fFD(i) = sum(tmask_fFD);
    run_frame_per_FD(i) = sum(tmask_FD)./numel(tmask_FD);
    run_frame_per_fFD(i) = sum(tmask_fFD)./numel(tmask_fFD);
    

	close('all')
end

% save out some general info
save(sprintf('%sgoodruns_FD.txt',outdir,i),'good_run_FD');
save(sprintf('%sgoodruns_fFD.txt',outdir,i),'good_run_fFD');

save(sprintf('%sframenums_FD.txt',outdir,i),'run_frame_nums_FD');
save(sprintf('%sframenums_fFD.txt',outdir,i),'run_frame_nums_fFD');

save(sprintf('%sframepers_FD.txt',outdir,i),'run_frame_per_FD');
save(sprintf('%sframepers_fFD.txt',outdir,i),'run_frame_per_fFD');


end

function plot_motion_params(mot_data,FD,FDthresh)
figure('Position',[1 1 800 1000]);

subplot(2,3,1:3)
title('motion')
plot(mot_data);
legend('Roll', 'Pitch', 'Yaw', 'Z', 'X', 'Y');
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


