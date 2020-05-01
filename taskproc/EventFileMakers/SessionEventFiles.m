%Below is a list of the numbers in the MD event files and how they relate
%to conditions in the mixed task
% 00_Rhyme_startcue
% 01_Rhyme_sustained
% 02_Rhyme_endcue
% 03_Rhyme_yes_corr
% 04_Rhyme_no_corr
% 05_Rhyme_error
% 06_Rhyme_amb
% 
% 07_AbsCon_startcue
% 08__AbsCon_sustained
% 09_AbsCon_endcue
% 10_AbsCon_abs_corr
% 11_AbsCon_con_corr
% 12_AbsCon_error
% 13_AbsCon_amb
% 
% 14_MR_startcue
% 15_MR_sustained
% 16_MR_endcue
% 17_MR_same_corr
% 18_MR_mirror_corr
% 19_MR_error
%Set Subject%
subject='006';  %set this to the INET subject number%
%Mixed Predictors%
Rhyme_startcue=0;
Rhyme_sustained=1;
Rhyme_endcue=2;
Rhyme_yes_corr=3;
Rhyme_no_corr=4;
Rhyme_error=5;
Rhyme_amb=6;
AbsCon_startcue=7;
AbsCon_sustained=8;
AbsCon_endcue=9;
AbsCon_abs_corr=10;
AbsCon_con_corr=11;
AbsCon_error=12;
AbsCon_amb=13;
MR_startcue=14;
MR_sustained=15;
MR_endcue=16;
MR_same_corr=17;
MR_mirror_corr=18;
MR_error=19;
%Number of runs for each task%
mixed_runs=16;
%Get data%
pathtodata='/Users/derek.smith/Desktop/General_Testing_Folder/iNet006/EventFiles/'
for mixrun=1:mixed_runs;
    MixString{1,mixrun}=[pathtodata 'INET' subject '_task-MixedPlus_run-' num2str(mixrun) '_events.txt'];
end
for runindex=1:mixed_runs;
%Get the session%
if runindex==1 | runindex==2 | runindex==3 | runindex==4;
    sess=1;
elseif runindex==5 | runindex==6 | runindex==7 | runindex==8;
    sess=2;
elseif runindex==9 | runindex==10 | runindex==11 | runindex==12;
    sess=3;
elseif runindex==13 | runindex==14 | runindex==15 | runindex==16;
    sess=4;
end
mix_tar=table2array(readtable(MixString{1,runindex}));
% Filter by Predictor%
row_Rhyme_startcue=transpose(mix_tar(:,1).*(mix_tar(:,3)==Rhyme_startcue));
row_Rhyme_sustained=transpose(mix_tar(:,1).*(mix_tar(:,3)==Rhyme_sustained));
row_Rhyme_endcue=transpose(mix_tar(:,1).*(mix_tar(:,3)==Rhyme_endcue));
row_Rhyme_yes_corr=transpose(mix_tar(:,1).*(mix_tar(:,3)==Rhyme_yes_corr));
row_Rhyme_no_corr=transpose(mix_tar(:,1).*(mix_tar(:,3)==Rhyme_no_corr));
row_Rhyme_error=transpose(mix_tar(:,1).*(mix_tar(:,3)==Rhyme_error));
row_Rhyme_amb=transpose(mix_tar(:,1).*(mix_tar(:,3)==Rhyme_amb));
row_AbsCon_startcue=transpose(mix_tar(:,1).*(mix_tar(:,3)==AbsCon_startcue));
row_AbsCon_sustained=transpose(mix_tar(:,1).*(mix_tar(:,3)==AbsCon_sustained));
row_AbsCon_endcue=transpose(mix_tar(:,1).*(mix_tar(:,3)==AbsCon_endcue));
row_AbsCon_abs_corr=transpose(mix_tar(:,1).*(mix_tar(:,3)==AbsCon_abs_corr));
row_AbsCon_con_corr=transpose(mix_tar(:,1).*(mix_tar(:,3)==AbsCon_con_corr));
row_AbsCon_error=transpose(mix_tar(:,1).*(mix_tar(:,3)==AbsCon_error));
row_AbsCon_amb=transpose(mix_tar(:,1).*(mix_tar(:,3)==AbsCon_amb));
row_MR_startcue=transpose(mix_tar(:,1).*(mix_tar(:,3)==MR_startcue));
row_MR_sustained=transpose(mix_tar(:,1).*(mix_tar(:,3)==MR_sustained));
row_MR_endcue=transpose(mix_tar(:,1).*(mix_tar(:,3)==MR_endcue));
row_MR_same_corr=transpose(mix_tar(:,1).*(mix_tar(:,3)==MR_same_corr));
row_MR_mirror_corr=transpose(mix_tar(:,1).*(mix_tar(:,3)==MR_mirror_corr));
row_MR_error=transpose(mix_tar(:,1).*(mix_tar(:,3)==MR_error));
%Remove Zeros: Assuming Zero Time frame not included%
row_Rhyme_startcue(row_Rhyme_startcue==0)=[];
row_Rhyme_sustained(row_Rhyme_sustained==0)=[];
row_Rhyme_endcue(row_Rhyme_endcue==0)=[];
row_Rhyme_yes_corr(row_Rhyme_yes_corr==0)=[];
row_Rhyme_no_corr(row_Rhyme_no_corr==0)=[];
row_Rhyme_error(row_Rhyme_error==0)=[];
row_Rhyme_amb(row_Rhyme_amb==0)=[];
row_AbsCon_startcue(row_AbsCon_startcue==0)=[];
row_AbsCon_sustained(row_AbsCon_sustained==0)=[];
row_AbsCon_endcue(row_AbsCon_endcue==0)=[];
row_AbsCon_abs_corr(row_AbsCon_abs_corr==0)=[];
row_AbsCon_con_corr(row_AbsCon_con_corr==0)=[];
row_AbsCon_error(row_AbsCon_error==0)=[];
row_AbsCon_amb(row_AbsCon_amb==0)=[];
row_MR_startcue(row_MR_startcue==0)=[];
row_MR_sustained(row_MR_sustained==0)=[];
row_MR_endcue(row_MR_endcue==0)=[];
row_MR_same_corr(row_MR_same_corr==0)=[];
row_MR_mirror_corr(row_MR_mirror_corr==0)=[];
row_MR_error(row_MR_error==0)=[];

%Sort: Probably already fine but just to make sure%
row_Rhyme_startcue=sort(row_Rhyme_startcue);
row_Rhyme_sustained=sort(row_Rhyme_sustained);
row_Rhyme_endcue=sort(row_Rhyme_endcue);
row_Rhyme_yes_corr=sort(row_Rhyme_yes_corr);
row_Rhyme_no_corr=sort(row_Rhyme_no_corr);
row_Rhyme_error=sort(row_Rhyme_error);
row_Rhyme_amb=sort(row_Rhyme_amb);
row_AbsCon_startcue=sort(row_AbsCon_startcue);
row_AbsCon_sustained=sort(row_AbsCon_sustained);
row_AbsCon_endcue=sort(row_AbsCon_endcue);
row_AbsCon_abs_corr=sort(row_AbsCon_abs_corr);
row_AbsCon_con_corr=sort(row_AbsCon_con_corr);
row_AbsCon_error=sort(row_AbsCon_error);
row_AbsCon_amb=sort(row_AbsCon_amb);
row_MR_startcue=sort(row_MR_startcue);
row_MR_sustained=sort(row_MR_sustained);
row_MR_endcue=sort(row_MR_endcue);
row_MR_same_corr=sort(row_MR_same_corr);
row_MR_mirror_corr=sort(row_MR_mirror_corr);
row_MR_error=sort(row_MR_error);
%Make path%
fixed='/Users/derek.smith/Desktop/General_Testing_Folder/iNet006/session_stim/sess_';
currentpath=[fixed,num2str(sess)];
%Make Tab Delim Row%
    if runindex==1 | runindex==5 | runindex==9 | runindex==13; %These are always the first run in a scan session%
    dlmwrite([currentpath,'/Rhyme_amb.txt'],row_Rhyme_amb,'delimiter','\t');
    dlmwrite([currentpath,'/Rhyme_no_corr.txt'],row_Rhyme_no_corr,'delimiter','\t');
    dlmwrite([currentpath,'/Rhyme_error.txt'],row_Rhyme_error,'delimiter','\t');
    dlmwrite([currentpath,'/Rhyme_yes_corr.txt'],row_Rhyme_yes_corr,'delimiter','\t');
    dlmwrite([currentpath,'/Rhyme_startcue.txt'],row_Rhyme_startcue,'delimiter','\t');
    dlmwrite([currentpath,'/Rhyme_sustained.txt'],row_Rhyme_sustained,'delimiter','\t');
    dlmwrite([currentpath,'/Rhyme_endcue.txt'],row_Rhyme_endcue,'delimiter','\t');
    dlmwrite([currentpath,'/AbsCon_amb.txt'],row_AbsCon_amb,'delimiter','\t');
    dlmwrite([currentpath,'/AbsCon_con_corr.txt'],row_AbsCon_con_corr,'delimiter','\t');
    dlmwrite([currentpath,'/AbsCon_error.txt'],row_AbsCon_error,'delimiter','\t');
    dlmwrite([currentpath,'/AbsCon_abs_corr.txt'],row_AbsCon_abs_corr,'delimiter','\t');
    dlmwrite([currentpath,'/AbsCon_startcue.txt'],row_AbsCon_startcue,'delimiter','\t');
    dlmwrite([currentpath,'/AbsCon_sustained.txt'],row_AbsCon_sustained,'delimiter','\t');
    dlmwrite([currentpath,'/AbsCon_endcue.txt'],row_AbsCon_endcue,'delimiter','\t');
    dlmwrite([currentpath,'/MR_mirror_corr.txt'],row_MR_mirror_corr,'delimiter','\t');
    dlmwrite([currentpath,'/MR_error.txt'],row_MR_error,'delimiter','\t');
    dlmwrite([currentpath,'/MR_same_corr.txt'],row_MR_same_corr,'delimiter','\t');
    dlmwrite([currentpath,'/MR_startcue.txt'],row_MR_startcue,'delimiter','\t');
    dlmwrite([currentpath,'/MR_sustained.txt'],row_MR_sustained,'delimiter','\t');
    dlmwrite([currentpath,'/MR_endcue.txt'],row_MR_endcue,'delimiter','\t');
    else
    dlmwrite([currentpath,'/Rhyme_amb.txt'],row_Rhyme_amb,'-append','delimiter','\t');
    dlmwrite([currentpath,'/Rhyme_no_corr.txt'],row_Rhyme_no_corr,'-append','delimiter','\t');
    dlmwrite([currentpath,'/Rhyme_error.txt'],row_Rhyme_error,'-append','delimiter','\t');
    dlmwrite([currentpath,'/Rhyme_yes_corr.txt'],row_Rhyme_yes_corr,'-append','delimiter','\t');
    dlmwrite([currentpath,'/Rhyme_startcue.txt'],row_Rhyme_startcue,'-append','delimiter','\t');
    dlmwrite([currentpath,'/Rhyme_sustained.txt'],row_Rhyme_sustained,'-append','delimiter','\t');
    dlmwrite([currentpath,'/Rhyme_endcue.txt'],row_Rhyme_endcue,'-append','delimiter','\t');
    dlmwrite([currentpath,'/AbsCon_amb.txt'],row_AbsCon_amb,'-append','delimiter','\t');
    dlmwrite([currentpath,'/AbsCon_con_corr.txt'],row_AbsCon_con_corr,'-append','delimiter','\t');
    dlmwrite([currentpath,'/AbsCon_error.txt'],row_AbsCon_error,'-append','delimiter','\t');
    dlmwrite([currentpath,'/AbsCon_abs_corr.txt'],row_AbsCon_abs_corr,'-append','delimiter','\t');
    dlmwrite([currentpath,'/AbsCon_startcue.txt'],row_AbsCon_startcue,'-append','delimiter','\t');
    dlmwrite([currentpath,'/AbsCon_sustained.txt'],row_AbsCon_sustained,'-append','delimiter','\t');
    dlmwrite([currentpath,'/AbsCon_endcue.txt'],row_AbsCon_endcue,'-append','delimiter','\t');
    dlmwrite([currentpath,'/MR_mirror_corr.txt'],row_MR_mirror_corr,'-append','delimiter','\t');
    dlmwrite([currentpath,'/MR_error.txt'],row_MR_error,'-append','delimiter','\t');
    dlmwrite([currentpath,'/MR_same_corr.txt'],row_MR_same_corr,'-append','delimiter','\t');
    dlmwrite([currentpath,'/MR_startcue.txt'],row_MR_startcue,'-append','delimiter','\t');
    dlmwrite([currentpath,'/MR_sustained.txt'],row_MR_sustained,'-append','delimiter','\t');
    dlmwrite([currentpath,'/MR_endcue.txt'],row_MR_endcue,'-append','delimiter','\t');
end
end