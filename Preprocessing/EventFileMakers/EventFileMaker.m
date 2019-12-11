%Mixed Predictors%
nv_startcue=0;
nv_sustain=1;
nv_endcue=2;
nv_noun_corr=3;
nv_verb_corr=4;
nv_error=5;
mr_startcue=6;
mr_sustain=7;
mr_endcue=8;
mr_same_corr=9;
mr_mirror_corr=10;
mr_error=11;
%Am Predictors%
rhy_startcue=0;
rhy_sustain=1;
rhy_endcue=2;
rhy_yes_corr=3;
rhy_no_corr=4;
rhy_error=5;
rhy_amb=6;
abscon_startcue=7;
abscon_sustain=8;
abscon_endcue=9;
abscon_abs_corr=10;
abscon_con_corr=11;
abscon_error=12;
abscon_am=13;
%Number of runs for each task%
Mixed_runs=10;
Am_runs=10;
%Get data%
for amrun=1:Am_runs;
    AmString{1,amrun}=['task-Ambiguity_run-' num2str(amrun) '_events.txt'];
end
for mixedrun=1:Mixed_runs;
    MixedString{1,mixedrun}=['task-Mixed_run-' num2str(mixedrun) '_events.txt'];
end
for runindex=1:Mixed_runs;
mixed_tar=table2array(readtable(MixedString{1,runindex}));
%Filter by Predictor%
row_nv_startcue=transpose(mixed_tar(:,1).*(mixed_tar(:,3)==nv_startcue));
row_nv_sustain=transpose(mixed_tar(:,1).*(mixed_tar(:,3)==nv_sustain));
row_nv_endcue=transpose(mixed_tar(:,1).*(mixed_tar(:,3)==nv_endcue));
row_nv_noun_corr=transpose(mixed_tar(:,1).*(mixed_tar(:,3)==nv_noun_corr));
row_nv_verb_corr=transpose(mixed_tar(:,1).*(mixed_tar(:,3)==nv_verb_corr));
row_nv_error=transpose(mixed_tar(:,1).*(mixed_tar(:,3)==nv_error));
row_mr_startcue=transpose(mixed_tar(:,1).*(mixed_tar(:,3)==mr_startcue));
row_mr_sustain=transpose(mixed_tar(:,1).*(mixed_tar(:,3)==mr_sustain));
row_mr_endcue=transpose(mixed_tar(:,1).*(mixed_tar(:,3)==mr_endcue));
row_mr_same_corr=transpose(mixed_tar(:,1).*(mixed_tar(:,3)==mr_same_corr));
row_mr_mirror_corr=transpose(mixed_tar(:,1).*(mixed_tar(:,3)==mr_mirror_corr));
row_mr_error=transpose(mixed_tar(:,1).*(mixed_tar(:,3)==mr_error));
%Remove Zeros: Assuming Zero Time frame not included%
row_nv_startcue(row_nv_startcue==0)=[];
row_nv_sustain(row_nv_sustain==0)=[];
row_nv_endcue(row_nv_endcue==0)=[];
row_nv_noun_corr(row_nv_noun_corr==0)=[];
row_nv_verb_corr(row_nv_verb_corr==0)=[];
row_nv_error(row_nv_error==0)=[];
row_mr_startcue(row_mr_startcue==0)=[];
row_mr_sustain(row_mr_sustain==0)=[];
row_mr_endcue(row_mr_endcue==0)=[];
row_mr_same_corr(row_mr_same_corr==0)=[];
row_mr_mirror_corr(row_mr_mirror_corr==0)=[];
row_mr_error(row_mr_error==0)=[];
%Sort: Probably already fine but just to make sure%
row_nv_startcue=sort(row_nv_startcue);
row_nv_sustain=sort(row_nv_sustain);
row_nv_endcue=sort(row_nv_endcue);
row_nv_noun_corr=sort(row_nv_noun_corr);
row_nv_verb_corr=sort(row_nv_verb_corr);
row_nv_error=sort(row_nv_error);
row_mr_startcue=sort(row_mr_startcue);
row_mr_sustain=sort(row_mr_sustain);
row_mr_endcue=sort(row_mr_endcue);
row_mr_same_corr=sort(row_mr_same_corr);
row_mr_mirror_corr=sort(row_mr_mirror_corr);
row_mr_error=sort(row_mr_error);
%Make Tab Delim Row%
if runindex==1;
    dlmwrite('mr_endcue.txt',row_mr_endcue,'delimiter','\t');
    dlmwrite('mr_error.txt',row_mr_error,'delimiter','\t');
    dlmwrite('mr_mirror_corr.txt',row_mr_mirror_corr,'delimiter','\t');
    dlmwrite('mr_same_corr.txt',row_mr_same_corr,'delimiter','\t');
    dlmwrite('mr_starcue.txt',row_mr_startcue,'delimiter','\t');
    dlmwrite('mr_sustain.txt',row_mr_sustain,'delimiter','\t');
    dlmwrite('nv_endcue.txt',row_nv_endcue,'delimiter','\t');
    dlmwrite('nv_error.txt',row_nv_error,'delimiter','\t');
    dlmwrite('nv_noun_corr.txt',row_nv_noun_corr,'delimiter','\t');
    dlmwrite('nv_startcue.txt',row_nv_startcue,'delimiter','\t');
    dlmwrite('nv_sustain.txt',row_nv_sustain,'delimiter','\t');
    dlmwrite('nv_verb_corr.txt',row_nv_verb_corr,'delimiter','\t');
else
    dlmwrite('mr_endcue.txt',row_mr_endcue,'-append','delimiter','\t');
    dlmwrite('mr_error.txt',row_mr_error,'-append','delimiter','\t');
    dlmwrite('mr_mirror_corr.txt',row_mr_mirror_corr,'-append','delimiter','\t');
    dlmwrite('mr_same_corr.txt',row_mr_same_corr,'-append','delimiter','\t');
    dlmwrite('mr_starcue.txt',row_mr_startcue,'-append','delimiter','\t');
    dlmwrite('mr_sustain.txt',row_mr_sustain,'-append','delimiter','\t');
    dlmwrite('nv_endcue.txt',row_nv_endcue,'-append','delimiter','\t');
    dlmwrite('nv_error.txt',row_nv_error,'-append','delimiter','\t');
    dlmwrite('nv_noun_corr.txt',row_nv_noun_corr,'-append','delimiter','\t');
    dlmwrite('nv_startcue.txt',row_nv_startcue,'-append','delimiter','\t');
    dlmwrite('nv_sustain.txt',row_nv_sustain,'-append','delimiter','\t');
    dlmwrite('nv_verb_corr.txt',row_nv_verb_corr,'-append','delimiter','\t');
end
end
for runindex=1:Am_runs;
am_tar=table2array(readtable(AmString{1,runindex}));
%Filter by Predictor%
row_rhy_startcue=transpose(am_tar(:,1).*(am_tar(:,3)==rhy_startcue));
row_rhy_sustain=transpose(am_tar(:,1).*(am_tar(:,3)==rhy_sustain));
row_rhy_endcue=transpose(am_tar(:,1).*(am_tar(:,3)==rhy_endcue));
row_rhy_yes_corr=transpose(am_tar(:,1).*(am_tar(:,3)==rhy_yes_corr));
row_rhy_no_corr=transpose(am_tar(:,1).*(am_tar(:,3)==rhy_no_corr));
row_rhy_error=transpose(am_tar(:,1).*(am_tar(:,3)==rhy_error));
row_rhy_amb=transpose(am_tar(:,1).*(am_tar(:,3)==rhy_amb));
row_abscon_startcue=transpose(am_tar(:,1).*(am_tar(:,3)==abscon_startcue));
row_abscon_sustain=transpose(am_tar(:,1).*(am_tar(:,3)==abscon_sustain));
row_abscon_endcue=transpose(am_tar(:,1).*(am_tar(:,3)==abscon_endcue));
row_abscon_abs_corr=transpose(am_tar(:,1).*(am_tar(:,3)==abscon_abs_corr));
row_abscon_con_corr=transpose(am_tar(:,1).*(am_tar(:,3)==abscon_con_corr));
row_abscon_error=transpose(am_tar(:,1).*(am_tar(:,3)==abscon_error));
row_abscon_am=transpose(am_tar(:,1).*(am_tar(:,3)==abscon_am));
%Remove Zeros: Assuming Zero Time frame not included%
row_rhy_startcue(row_rhy_startcue==0)=[];
row_rhy_sustain(row_rhy_sustain==0)=[];
row_rhy_endcue(row_rhy_endcue==0)=[];
row_rhy_yes_corr(row_rhy_yes_corr==0)=[];
row_rhy_no_corr(row_rhy_no_corr==0)=[];
row_rhy_error(row_rhy_error==0)=[];
row_rhy_amb(row_rhy_amb==0)=[];
row_abscon_startcue(row_abscon_startcue==0)=[];
row_abscon_sustain(row_abscon_sustain==0)=[];
row_abscon_endcue(row_abscon_endcue==0)=[];
row_abscon_abs_corr(row_abscon_abs_corr==0)=[];
row_abscon_con_corr(row_abscon_con_corr==0)=[];
row_abscon_error(row_abscon_error==0)=[];
row_abscon_am(row_abscon_am==0)=[];
%Sort: Probably already fine but just to make sure%
row_rhy_startcue=sort(row_rhy_startcue);
row_rhy_sustain=sort(row_rhy_sustain);
row_rhy_endcue=sort(row_rhy_endcue);
row_rhy_yes_corr=sort(row_rhy_yes_corr);
row_rhy_no_corr=sort(row_rhy_no_corr);
row_rhy_error=sort(row_rhy_error);
row_rhy_amb=sort(row_rhy_amb);
row_abscon_startcue=sort(row_abscon_startcue);
row_abscon_sustain=sort(row_abscon_sustain);
row_abscon_endcue=sort(row_abscon_endcue);
row_abscon_abs_corr=sort(row_abscon_abs_corr);
row_abscon_con_corr=sort(row_abscon_con_corr);
row_abscon_error=sort(row_abscon_error);
row_abscon_am=sort(row_abscon_am);
%Make Tab Delim Row%
if runindex==1;
    dlmwrite('abscon_abs_corr.txt',row_abscon_abs_corr,'delimiter','\t');
    dlmwrite('abscon_amb.txt',row_abscon_am,'delimiter','\t');
    dlmwrite('abscon_con_corr.txt',row_abscon_con_corr,'delimiter','\t');
    dlmwrite('abscon_endcue.txt',row_abscon_endcue,'delimiter','\t');
    dlmwrite('abscon_error.txt',row_abscon_error,'delimiter','\t');
    dlmwrite('abscon_startcue.txt',row_abscon_startcue,'delimiter','\t');
    dlmwrite('abscon_sustain.txt',row_abscon_sustain,'delimiter','\t');
    dlmwrite('rhyme_amb.txt',row_rhy_amb,'delimiter','\t');
    dlmwrite('rhyme_endcue.txt',row_rhy_endcue,'delimiter','\t');
    dlmwrite('rhyme_error.txt',row_rhy_error,'delimiter','\t');
    dlmwrite('rhyme_startcue.txt',row_rhy_startcue,'delimiter','\t');
    dlmwrite('rhyme_sustain.txt',row_rhy_sustain,'delimiter','\t');
    dlmwrite('rhyme_yes_corr.txt',row_rhy_yes_corr,'delimiter','\t');
    dlmwrite('rhyme_no_corr.txt',row_rhy_no_corr,'delimiter','\t');
else
    dlmwrite('abscon_abs_corr.txt',row_abscon_abs_corr,'-append','delimiter','\t');
    dlmwrite('abscon_amb.txt',row_abscon_am,'-append','delimiter','\t');
    dlmwrite('abscon_con_corr.txt',row_abscon_con_corr,'-append','delimiter','\t');
    dlmwrite('abscon_endcue.txt',row_abscon_endcue,'-append','delimiter','\t');
    dlmwrite('abscon_error.txt',row_abscon_error,'-append','delimiter','\t');
    dlmwrite('abscon_startcue.txt',row_abscon_startcue,'-append','delimiter','\t');
    dlmwrite('abscon_sustain.txt',row_abscon_sustain,'-append','delimiter','\t');
    dlmwrite('rhyme_amb.txt',row_rhy_amb,'-append','delimiter','\t');
    dlmwrite('rhyme_endcue.txt',row_rhy_endcue,'-append','delimiter','\t');
    dlmwrite('rhyme_error.txt',row_rhy_error,'-append','delimiter','\t');
    dlmwrite('rhyme_startcue.txt',row_rhy_startcue,'-append','delimiter','\t');
    dlmwrite('rhyme_sustain.txt',row_rhy_sustain,'-append','delimiter','\t');
    dlmwrite('rhyme_yes_corr.txt',row_rhy_yes_corr,'-append','delimiter','\t');
    dlmwrite('rhyme_no_corr.txt',row_rhy_no_corr,'-append','delimiter','\t');
end
end