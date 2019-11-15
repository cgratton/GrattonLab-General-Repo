function FDcalc_AFNI()
% function for calculating FD and making tmasks from AFNI
% eventually should feed in directory structure/variables above

%%% Directory structure
inputdir = '~/Desktop/iNet006MotionData/';
outdir = inputdir;
input_filestr = 'mot_demean.r'; %search for all files for all runs (separate by runs to find borders, based on AFNI proc)

%%% Variables
TR = 1.1; 
plotdata = 0; % Plot each run as a separate file
winsize = 5; % Number of continuous samples w/o high FD necessary for inclusion           
DropFramesSec = 30; % number of seconds of frames to drop at the start of each run
DropFramesTR = round(DropFramesSec/TR); % Calculate num TRs to drop
headSize = 50; % assume 50 mm head radius
FDthresh = 0.2;
fFDthresh = 0.1;
              
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
    
    close('all')
end





                        
                     
%                     % Calc FD with contiguous frames
%                     
%                     FinalFrames = 0;
%                     
%                     for frames = 2:size(FD_abs,1)
%                         
%                         if FD_abs(frames) < FD_cutoff  % Use moving window function if current frame is less than FD
%                         
%                             forwardmax = 0;
%                             backwardmax = 0;
%                             
%                             if frames < winsize+1  % Adjust window to not be uniform for first few frames
%                                 
%                                 forwardloop = winsize;
%                                 backwardloop = winsize - (winsize - (frames - 1));
%                                 
%                             elseif frames > size(FD_abs,1) - (winsize+1)  % Adjust window to not be uniform for last few frames
%                                 
%                                 forwardloop = size(FD_abs,1) - frames;
%                                 backwardloop = winsize;
%                                 
%                             else  % Else use uniform window
%                                 
%                                 forwardloop = winsize;
%                                 backwardloop = winsize;
%                                 
%                             end
%                             
%                             if backwardloop > 0  % Check how many contiguous frames exist before current frame
%                                 
%                                 backmaxchk = 0;
%                         
%                                 for scan = 1:backwardloop
%                                     
%                                     if FD_abs(frames - scan) > FD_cutoff && backmaxchk == 0   % If FD cutoff exceeded, mark previous frame as max
%                                     
%                                         backwardmax = scan-1;
%                                         backmaxchk = 1;
%                                     
%                                     elseif scan == winsize && backmaxchk == 0
%                                     
%                                         backwardmax = scan;
%                                     
%                                     end
%                                 end
%                             end
%                                 
%                             if forwardloop > 0  % Check how many contiguous frames exist after current frame
%                                 
%                                 frontmaxchk = 0;
% 
%                                 for scan = 1:forwardloop
%                                 
%                                     if FD_abs(frames + scan) > FD_cutoff && frontmaxchk == 0  % If FD cutoff exceeded, mark previous frame as max
%                                     
%                                         forwardmax = scan-1;
%                                         frontmaxchk = 1;
%                                     
%                                     elseif scan == winsize && frontmaxchk == 0
%                                     
%                                         forwardmax = scan;
%                                     
%                                     end
%                                 end
%                             end
%                             
%                             if backwardmax + forwardmax > winsize-1  %% Check if total number of continuous frames > 5
%                                 
%                                 FinalFrames = FinalFrames + 1;
%                             
%                             end
%                         end
%                     end
%                     
% 
%                     % Fill out struct
% 
%                     StructAdd = size(FD_All,2)+1;
% 
%                     FD_All(StructAdd).Subject = FDSub;
%                     FD_All(StructAdd).Date = TaskDate;
%                     FD_All(StructAdd).Task = FDTask;
%                     FD_All(StructAdd).TR = TaskTR;
%                     FD_All(StructAdd).Total_Frames = size(FD_dat,1) + DropFrames;
%                     FD_All(StructAdd).Total_Time_sec = (size(FD_dat,1) + DropFrames)*TaskTR;
% 
%                     if TaskTR < 1   %% Adjust good frame cutoff for FD depending on whether filter was applied
% 
%                         FD_All(StructAdd).Good_Frames = length(find(FD_abs<FD_cutoff));
%                         FD_All(StructAdd).Good_Time_sec = length(find(FD_abs<FD_cutoff))*TaskTR;
%                         FD_All(StructAdd).Good_Frames_Final = FinalFrames;
%                         FD_All(StructAdd).Good_Frames_Final_Time_sec = FinalFrames*TaskTR;
%                         FD_All(StructAdd).Terrible_Frames = length(find(FD_abs>.5));
%                         FD_All(StructAdd).Terrible_Time_sec = length(find(FD_abs>.5))*TaskTR;
% 
%                     else
% 
%                         FD_All(StructAdd).Good_Frames = length(find(FD_abs<FD_cutoff));
%                         FD_All(StructAdd).Good_Time_sec = length(find(FD_abs<FD_cutoff))*TaskTR;
%                         FD_All(StructAdd).Good_Frames_Final = FinalFrames;
%                         FD_All(StructAdd).Good_Frames_Final_Time_sec = FinalFrames*TaskTR;
%                         FD_All(StructAdd).Terrible_Frames = length(find(FD_abs>1));
%                         FD_All(StructAdd).Terrible_Time_sec = length(find(FD_abs>1))*TaskTR;
% 
%                     end
% 
%                     
%                     if plotdata == 1
% 
%                         % Plot FD
% 
%                         plot(FD_dat(:,1),FD_abs)
%                         title([FDSub '_' TaskDate '_' FDTask], 'fontsize',18, 'Interpreter', 'none')
% 
%                         if TaskTR < 1
% 
%                             ylabel('Filtered FD (mm)')
%                             xlabel('Samples')
% 
%                         else
% 
%                             ylabel('FD (mm)')
%                             xlabel('Samples')
% 
%                         end
% 
% 
%                         filename = ['/' FDSub '_' TaskDate '_' FDTask '.jpg'];
% 
%                         saveas(gcf,[outputdir filename])
% 
%                     	close gcf
%                         
%                     end
% 
%                 catch       %% Skip scan if no data file present
%                     
%                     disp(['Skipped ' FDSub '_' TaskDate '_' FDTask ', 3dvolreg file not present'])
%                     
%                 end
%                     
%          	else        %% Else skip scan
% 
%               	disp(['Skipped ' FDSub '_' TaskDate '_' FDTask ', No data present'])
% 
%             end
%         end
%     end
% end
% 
% %% Remove redundancies from NUNDA
% 
% % Remove redundant runs from struct
% % Probably only necessary for BrainMAPD
% 
% removeruns = [];
% 
% for remove = 1:size(FD_All,2)-1
%     
%     for removechk = remove+1:size(FD_All,2)
%         
%         if contains(FD_All(remove).Subject,FD_All(removechk).Subject) && strcmp(FD_All(remove).Date,FD_All(removechk).Date) && strcmp(FD_All(remove).Task,FD_All(removechk).Task) && FD_All(remove).TR == FD_All(removechk).TR && FD_All(remove).Total_Frames == FD_All(removechk).Total_Frames && FD_All(remove).Good_Frames == FD_All(removechk).Good_Frames && FD_All(remove).Good_Frames_Final == FD_All(removechk).Good_Frames_Final && FD_All(remove).Terrible_Frames == FD_All(removechk).Terrible_Frames
% 
%             removeruns = [removeruns removechk];
%             
%         end
%     end
% end
% 
% FD_All(:,removeruns) = [];
%             
% % Save Structs out
% 
% save([outputdir '/FD_Structure.mat'], 'FD_All');
% 
% 
% % Extract unique subject IDs from repeats (sessions, weird names, etc.)
% % Probably only necessary for BrainMAPD
%                 
% subjects = unique({FD_All.Subject});
% subjectsfinal = subjects;
% removedfiles = 0;
% 
% for subclean = 1:length(subjects)
%     
%     removesubs = [];
%     
%     str = char(strsplit(subjects{1,subclean},{'-','_'}));
%     
%     if size(str) > 1
%         
%         str = str(1,:);
%         
%     end
%     
%     startmatch = find(contains(subjectsfinal, str));
%     
%     if ~isempty(startmatch)
%     
%         for match = startmatch(1)+1:length(subjectsfinal)
%     
%             if contains(char(subjectsfinal{1,match}), str)
% 
%                 removesubs = [removesubs match];
%             
%             end
%         end
%     
%         removedfiles = removedfiles + length(removesubs);
%         subjectsfinal(removesubs) = [];
%         
%     end
%     
% end
% 
% %% Create structure with final good data
% 
% FD_Final = struct('Subject',{},'Final_Good_Frames',{},'Final_Good_Time_sec',{}, 'Runs',{});
% 
% for subjectextract = 1:length(subjectsfinal)
%     
%     numruns = 0;
%     goodframes = 0;
%     goodtimes = 0;
%     StructAdd = size(FD_Final,2)+1;
%     
%     FD_Final(StructAdd).Subject = char(subjectsfinal{1,subjectextract});
%     
%     for getframes = 1:size(FD_All,2)
%         
%         if contains(char(subjectsfinal{1,subjectextract}), FD_All(getframes).Subject) && FD_All(getframes).Good_Frames_Final >= 50
%             
%             goodframes = goodframes + FD_All(getframes).Good_Frames_Final;
%             goodtimes = goodtimes + FD_All(getframes).Good_Frames_Final_Time_sec;
%             numruns = numruns + 1;
%             
%         elseif contains(char(subjectsfinal{1,subjectextract}), FD_All(getframes).Subject)
%             
%             numruns = numruns + 1;
%             
%         end
%     end
%     
%     FD_Final(StructAdd).Final_Good_Frames = goodframes;
%     FD_Final(StructAdd).Final_Good_Time_sec = goodtimes;
%     FD_Final(StructAdd).Runs = numruns;
%     
% end
% 
% save([outputdir '/FD_Final_Structure.mat'], 'FD_Final');
% 
% %% Get number of subject with > 40 minutes of data
% 
% gooddatacount40 = 0;
% gooddatacount30 = 0;
% gooddatacount20 = 0;
% gooddatacount15 = 0;
% 
% for subcount = 1:size(FD_Final,2)
%     
%     if FD_Final(subcount).Final_Good_Time_sec > (40*60)
%         
%         gooddatacount40 = gooddatacount40 + 1;
%         gooddatacount30 = gooddatacount30 + 1;
%         gooddatacount20 = gooddatacount20 + 1;
%         gooddatacount15 = gooddatacount15 + 1;
%     
%     elseif FD_Final(subcount).Final_Good_Time_sec > (30*60)
%         
%         gooddatacount30 = gooddatacount30 + 1;
%         gooddatacount20 = gooddatacount20 + 1;
%         gooddatacount15 = gooddatacount15 + 1;
%         
%     elseif FD_Final(subcount).Final_Good_Time_sec > (20*60)
%         
%         gooddatacount20 = gooddatacount20 + 1;
%         gooddatacount15 = gooddatacount15 + 1;
%         
%     elseif FD_Final(subcount).Final_Good_Time_sec > (15*60)
%         
%         gooddatacount15 = gooddatacount15 + 1;
%         
%     end
% end
%             
%             
% % Histogram of number of runs/Total minutes of data
% 
% hist([FD_Final.Runs])
% 
% max([FD_Final.Final_Good_Time_sec])
% 
% hist([FD_Final.Final_Good_Time_sec]./60) 
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


