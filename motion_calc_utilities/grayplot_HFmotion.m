function grayplot_HFmotion(QCinit,stage,subject,mvm_filt)
% function grayplot_MIND(QC,whattomask,stage,subject)
%
% This function will make grayplots to look at timeseries after different
% stages of procesing. Additionally allows for bad timepoints to be masked
% out from visualization.
% This will allow one to inspect data for artifacts.
%
% QCfile: QC variable (usually saved under 'QC.mat')
%   this file contains timeseries from graymatter, along with
%   information about movement, processing, etc.
% whattomask: 'tmask' or 'none'
% stage: stage of processing, 1-7
%   1 = original pre-processed data
%   2 = demeaned, detrended
%   3 = residuals from nuisance regression (GM, WM, CSF, motion, + derivatives)
%   4 = interpolation of high-motion censored frames
%   5 = bandpass temporal filter (0.009 - 0.08 Hz)
%   6 = demean and detrend again
%
% subject: subject number, 1-10 [for MSC actually sessions from same
% subject]
%
% Note that this function will make figures and save them to the current
% directory.
% Also, note that current colorscale limits assume mode 1000 normalization
% for timeseries, and show 2% signal change
%
% Each of these conventions could be edited as desired for personal use.
%
% Made by CGratton, 5/21/14
% Edited for MIND, 8/1/17
% Based on FCPROCESS code, v4 (JD Power)
% Edited for HF motion script to highlight filtered and unfiltered FD, CG
% 8/9/19

QC = QCinit(subject);
% this needs to have: 
% - gray ts, white ts, and CSF ts (these are subsampled here)
% - original mvm params

% constants: 
numpts=size(QC.GMtcs,2); %number of timepoints
leftsignallim = [0:1:2];  % FD limits
lylimz=[min(leftsignallim) max(leftsignallim)];
BOLDlimz = [-20,20];

FDthresh = 0.2; % FD threshold to mark frame for scrubbing
FDfiltthresh = 0.1; % FDfiltered threshold

% compute data quality metrics
[tmpa tmpb FD] = compute_FD(QC.MVM);
[tmpa tmpb FDfilt] = compute_FD(mvm_filt);

DVars = compute_DVARS(QC.GMtcs(:,:,stage));
GS = compute_GS(QC.GMtcs(:,:,stage));

%%% create the figure
figure('Position',[1 1 1200 1200]);

% plot individual mvm params
[mvm_colors, mvm_colors_filt] = get_colors();

subplot(11,1,1:3); hold on;
pointindex=1:numpts;
for i = 1:6
    plot(pointindex,QC.MVM(:,i),'Color',mvm_colors(i,:));
    plot(pointindex,mvm_filt(:,i),'Color',mvm_colors_filt(i,:));
end
xlim([0 numpts]); ylim([-1,1]);
ylabel('mvm (mm)');

% Next, plot FD and filtered FD on the same plot
% keep in DVARS too?
subplot(11,1,4:5); hold on;
h1 = plot(pointindex,FD,'r');
h2 = plot(pointindex,FDfilt,'Color',[102 0 0]./255);
%set(h1(1),'xlim',[0 numpts],'ylim',lylimz,'ycolor',[0 0 0],'ytick',leftsignallim);
ylabel('FD (mm)');
h3 = hline_new(FDthresh,'r',1);
h4 = hline_new(FDfiltthresh,'r',1);
ylim([0,1]);
set(h4(1),'Color',[102 0 0]./255);

% add a plot of frames above threshold
tmask_tmp = [FD'<FDthresh; FDfilt'<FDfiltthresh];
subplot(11,1,6);
h = imagesc(tmask_tmp);
hline_new(1.5,'k',2);
set(gca,'YTicklabel',{'FD','fFD'});
colormap(gray);
ylabel('tmask (FDt,FD)')

% next plot gray matter signal, masking if requested
subplot(11,1,7:10);
new_GMtcs = QC.GMtcs(:,:,stage);
imagesc(new_GMtcs(:,:),BOLDlimz); 
colormap(gray); ylabel('GRAY');

% finally, plot WM and CSF ts
subplot(11,1,11);
imagesc([QC.WMtcs(:,:,stage);QC.CSFtcs(:,:,stage)],BOLDlimz); 
ylabel('WM CSF');

end

function [mvm ddt_mvm FD] = compute_FD(mvm_orig)

% convert rotational mvm params from deg to mm, assuming 50mm head size [has already been
% done in this case]
% radius = 50;
% mvm(:,1:3) = mvm_orig(:,1:3); % translation params stay the same
% mvm(:,4:6) =mvm_orig(:,4:6).*(2*radius*pi/360); % rotation params converted
mvm = mvm_orig;

% take original movement parameters, demean and detrend
ddt_mvm = diff(mvm);
ddt_mvm = [zeros(1,6); ddt_mvm];

% compute FD
FD=(sum(abs(ddt_mvm),2));

end


function DVARS = compute_DVARS(GMtcs)

DVARS = rms(diff(GMtcs,1,2));
DVARS = [0 DVARS];

end

function GS = compute_GS(GMtcs)

GS = nanmean(GMtcs,1);

end

function [mvm_colors, mvm_colors_filt] = get_colors()

mvm_colors = [0         0    255;...
         0    255         0;...
         255         0         0;...
         0     255   255;...
    255 0 255;...
    255 255 0]./255;

mvm_colors_filt = [102 0 0;...
    0 0 102;...
      0 102 0;...
         0 102 102;...
    102 0 102;...
    102 102 0]./255;

end