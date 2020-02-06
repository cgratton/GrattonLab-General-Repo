%Mixed Predictors%
corr1_3=0;
corr4_5=1;
corr6_7=2;
error1_3=3;
error4_5=4;
error6_7=5;
error_omission=6;
%Number of runs for each task%
sl_runs=10;
%Get data%
for amrun=1:sl_runs;
    AmString{1,amrun}=['task-SlowReveal_run-' num2str(amrun) '_events.txt'];
end
for runindex=1:sl_runs;
sl_tar=table2array(readtable(AmString{1,runindex}));
%Filter by Predictor%
row_corr1_3=transpose(sl_tar(:,1).*(sl_tar(:,3)==corr1_3));
row_corr4_5=transpose(sl_tar(:,1).*(sl_tar(:,3)==corr4_5));
row_corr6_7=transpose(sl_tar(:,1).*(sl_tar(:,3)==corr6_7));
row_error1_3=transpose(sl_tar(:,1).*(sl_tar(:,3)==error1_3));
row_error4_5=transpose(sl_tar(:,1).*(sl_tar(:,3)==error4_5));
row_error6_7=transpose(sl_tar(:,1).*(sl_tar(:,3)==error6_7));
row_error_omission=transpose(sl_tar(:,1).*(sl_tar(:,3)==error_omission));
%Remove Zeros: Assuming Zero Time frame not included%
row_corr1_3(row_corr1_3==0)=[];
row_corr4_5(row_corr4_5==0)=[];
row_corr6_7(row_corr6_7==0)=[];
row_error1_3(row_error1_3==0)=[];
row_error4_5(row_error4_5==0)=[];
row_error6_7(row_error6_7==0)=[];
row_error_omission(row_error_omission==0)=[];
%Sort: Probably already fine but just to make sure%
row_corr1_3=sort(row_corr1_3);
row_corr4_5=sort(row_corr4_5);
row_corr6_7=sort(row_corr6_7);
row_error1_3=sort(row_error1_3);
row_error4_5=sort(row_error4_5);
row_error6_7=sort(row_error6_7);
row_error_omission=sort(row_error_omission);
%Make path%
fixed='/Users/derek.smith/Desktop/General_Testing_Folder/iNetworks_AFNI_Tstat_Test/StimFiles/Good_Event_Files_from_box/sub-INET001 ADJUSTED/stimuli_';
currentpath=[fixed,num2str(runindex)];
%Make Tab Delim Row%
if runindex==1;
    dlmwrite('error_omission.txt',row_error_omission,'delimiter','\t');
    dlmwrite('error4_5.txt',row_error4_5,'delimiter','\t');
    dlmwrite('error6_7.txt',row_error6_7,'delimiter','\t');
    dlmwrite('error1_3.txt',row_error1_3,'delimiter','\t');
    dlmwrite('corr1_3.txt',row_corr1_3,'delimiter','\t');
    dlmwrite('corr4_5.txt',row_corr4_5,'delimiter','\t');
    dlmwrite('corr6_7.txt',row_corr6_7,'delimiter','\t');
else
    dlmwrite('error6_7.txt',row_error6_7,'-append','delimiter','\t');
    dlmwrite('error_omission.txt',row_error_omission,'-append','delimiter','\t');
    dlmwrite('error4_5.txt',row_error4_5,'-append','delimiter','\t');
    dlmwrite('error1_3.txt',row_error1_3,'-append','delimiter','\t');
    dlmwrite('corr6_7.txt',row_corr6_7,'-append','delimiter','\t');
    dlmwrite('corr1_3.txt',row_corr1_3,'-append','delimiter','\t');
    dlmwrite('corr4_5.txt',row_corr4_5,'-append','delimiter','\t');
end
end