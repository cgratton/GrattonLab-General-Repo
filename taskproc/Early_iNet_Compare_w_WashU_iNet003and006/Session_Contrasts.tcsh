#!/bin/tcsh -xef

# to execute via tcsh: 
#   tcsh -xef Session_Contrasts.tcsh |& tee output.Session_Contrasts.tcsh
# to execute via bash: 
#   tcsh -xef Session_Contrasts.tcsh 2>&1 | tee output.Session_Contrasts.tcsh

3dbucket -prefix AbsCon_SustainedS1 stats.ses1+orig'[199]'

3dbucket -prefix MR_SustainedS1 stats.ses1+orig'[367]'

3dbucket -prefix Rhyme_SustainedS1 stats.ses1+orig'[535]'

3dbucket -prefix Tmap_ContrastsS1 stats.ses1+orig'[571..627(3)]'

3dbucket -prefix AbsCon_SustainedS2 stats.ses2+orig'[199]'

3dbucket -prefix MR_SustainedS2 stats.ses2+orig'[367]'

3dbucket -prefix Rhyme_SustainedS2 stats.ses2+orig'[535]'

3dbucket -prefix Tmap_ContrastsS2 stats.ses2+orig'[571..627(3)]'

3dbucket -prefix AbsCon_SustainedS3 stats.ses3+orig'[199]'

3dbucket -prefix MR_SustainedS3 stats.ses3+orig'[367]'

3dbucket -prefix Rhyme_SustainedS3 stats.ses3+orig'[535]'

3dbucket -prefix Tmap_ContrastsS3 stats.ses3+orig'[571..627(3)]'

3dbucket -prefix AbsCon_SustainedS4 stats.ses4+orig'[199]'

3dbucket -prefix MR_SustainedS4 stats.ses4+orig'[367]'

3dbucket -prefix Rhyme_SustainedS4 stats.ses4+orig'[535]'

3dbucket -prefix Tmap_ContrastsS4 stats.ses4+orig'[571..627(3)]'

3dttest++ -mask full_mask.Mixed_All_Runs_Orig_Together01_RUN+orig -prefix Task_Effect_Ses -setA Tmap_ContrastsS1+orig'[0]' \
Tmap_ContrastsS2+orig'[0]' \
Tmap_ContrastsS3+orig'[0]' \
Tmap_ContrastsS4+orig'[0]'

3dttest++ -mask full_mask.Mixed_All_Runs_Orig_Together01_RUN+orig -prefix Correct_Effect_Ses -setA Tmap_ContrastsS1+orig'[1]' \
Tmap_ContrastsS2+orig'[1]' \
Tmap_ContrastsS3+orig'[1]' \
Tmap_ContrastsS4+orig'[1]'

3dttest++ -mask full_mask.Mixed_All_Runs_Orig_Together01_RUN+orig -prefix Error_Effect_Ses -setA Tmap_ContrastsS1+orig'[2]' \
Tmap_ContrastsS2+orig'[2]' \
Tmap_ContrastsS3+orig'[2]' \
Tmap_ContrastsS4+orig'[2]'

3dttest++ -mask full_mask.Mixed_All_Runs_Orig_Together01_RUN+orig -prefix Sustained_Effect_Ses -setA Tmap_ContrastsS1+orig'[3]' \
Tmap_ContrastsS2+orig'[3]' \
Tmap_ContrastsS3+orig'[3]' \
Tmap_ContrastsS4+orig'[3]'

3dttest++ -mask full_mask.Mixed_All_Runs_Orig_Together01_RUN+orig -prefix All_Cue_Effect_Ses -setA Tmap_ContrastsS1+orig'[4]' \
Tmap_ContrastsS2+orig'[4]' \
Tmap_ContrastsS3+orig'[4]' \
Tmap_ContrastsS4+orig'[4]'

3dttest++ -mask full_mask.Mixed_All_Runs_Orig_Together01_RUN+orig -prefix MR_Effect_Ses -setA Tmap_ContrastsS1+orig'[5]' \
Tmap_ContrastsS2+orig'[5]' \
Tmap_ContrastsS3+orig'[5]' \
Tmap_ContrastsS4+orig'[5]'

3dttest++ -mask full_mask.Mixed_All_Runs_Orig_Together01_RUN+orig -prefix Rhyme_Effect_Ses -setA Tmap_ContrastsS1+orig'[6]' \
Tmap_ContrastsS2+orig'[6]' \
Tmap_ContrastsS3+orig'[6]' \
Tmap_ContrastsS4+orig'[6]'

3dttest++ -mask full_mask.Mixed_All_Runs_Orig_Together01_RUN+orig -prefix MR_Correct_Effect_Ses -setA Tmap_ContrastsS1+orig'[7]' \
Tmap_ContrastsS2+orig'[7]' \
Tmap_ContrastsS3+orig'[7]' \
Tmap_ContrastsS4+orig'[7]'

3dttest++ -mask full_mask.Mixed_All_Runs_Orig_Together01_RUN+orig -prefix Rhyme_Correct_Effect_Ses -setA Tmap_ContrastsS1+orig'[8]' \
Tmap_ContrastsS2+orig'[8]' \
Tmap_ContrastsS3+orig'[8]' \
Tmap_ContrastsS4+orig'[8]'

3dttest++ -mask full_mask.Mixed_All_Runs_Orig_Together01_RUN+orig -prefix MR_Cue_Effect_Ses -setA Tmap_ContrastsS1+orig'[9]' \
Tmap_ContrastsS2+orig'[9]' \
Tmap_ContrastsS3+orig'[9]' \
Tmap_ContrastsS4+orig'[9]'

3dttest++ -mask full_mask.Mixed_All_Runs_Orig_Together01_RUN+orig -prefix Rhyme_Cue_Effect_Ses -setA Tmap_ContrastsS1+orig'[10]' \
Tmap_ContrastsS2+orig'[10]' \
Tmap_ContrastsS3+orig'[10]' \
Tmap_ContrastsS4+orig'[10]'

3dttest++ -mask full_mask.Mixed_All_Runs_Orig_Together01_RUN+orig -prefix ErrorMinusCorrect_Effect_Ses -setA Tmap_ContrastsS1+orig'[11]' \
Tmap_ContrastsS2+orig'[11]' \
Tmap_ContrastsS3+orig'[11]' \
Tmap_ContrastsS4+orig'[11]'

3dttest++ -mask full_mask.Mixed_All_Runs_Orig_Together01_RUN+orig -prefix AmbMinusCorrect_Effect_Ses -setA Tmap_ContrastsS1+orig'[12]' \
Tmap_ContrastsS2+orig'[12]' \
Tmap_ContrastsS3+orig'[12]' \
Tmap_ContrastsS4+orig'[12]'

3dttest++ -mask full_mask.Mixed_All_Runs_Orig_Together01_RUN+orig -prefix Am_Effect_Ses -setA Tmap_ContrastsS1+orig'[13]' \
Tmap_ContrastsS2+orig'[13]' \
Tmap_ContrastsS3+orig'[13]' \
Tmap_ContrastsS4+orig'[13]'

3dttest++ -mask full_mask.Mixed_All_Runs_Orig_Together01_RUN+orig -prefix AbsCon_Effect_Ses -setA Tmap_ContrastsS1+orig'[14]' \
Tmap_ContrastsS2+orig'[14]' \
Tmap_ContrastsS3+orig'[14]' \
Tmap_ContrastsS4+orig'[14]'

3dttest++ -mask full_mask.Mixed_All_Runs_Orig_Together01_RUN+orig -prefix AbsCon_Correct_Effect_Ses -setA Tmap_ContrastsS1+orig'[15]' \
Tmap_ContrastsS2+orig'[15]' \
Tmap_ContrastsS3+orig'[15]' \
Tmap_ContrastsS4+orig'[15]'

3dttest++ -mask full_mask.Mixed_All_Runs_Orig_Together01_RUN+orig -prefix AbsCon_Cue_Effect_Ses -setA Tmap_ContrastsS1+orig'[16]' \
Tmap_ContrastsS2+orig'[16]' \
Tmap_ContrastsS3+orig'[16]' \
Tmap_ContrastsS4+orig'[16]'

3dttest++ -mask full_mask.Mixed_All_Runs_Orig_Together01_RUN+orig -prefix StartCue_Effect_Ses -setA Tmap_ContrastsS1+orig'[17]' \
Tmap_ContrastsS2+orig'[17]' \
Tmap_ContrastsS3+orig'[17]' \
Tmap_ContrastsS4+orig'[17]'

3dttest++ -mask full_mask.Mixed_All_Runs_Orig_Together01_RUN+orig -prefix EndCue_Effect_Ses -setA Tmap_ContrastsS1+orig'[18]' \
Tmap_ContrastsS2+orig'[18]' \
Tmap_ContrastsS3+orig'[18]' \
Tmap_ContrastsS4+orig'[18]'

3dttest++ -mask full_mask.Mixed_All_Runs_Orig_Together01_RUN+orig -prefix MR_Sustained_Effect_Ses -setA MR_SustainedS1+orig'[0]' \
MR_SustainedS2+orig'[0]' \
MR_SustainedS3+orig'[0]' \
MR_SustainedS4+orig'[0]'

3dttest++ -mask full_mask.Mixed_All_Runs_Orig_Together01_RUN+orig -prefix Rhyme_Sustained_Effect_Ses -setA Rhyme_SustainedS1+orig'[0]' \
Rhyme_SustainedS2+orig'[0]' \
Rhyme_SustainedS3+orig'[0]' \
Rhyme_SustainedS4+orig'[0]'

3dttest++ -mask full_mask.Mixed_All_Runs_Orig_Together01_RUN+orig -prefix AbsCon_Sustained_Effect_Ses -setA AbsCon_SustainedS1+orig'[0]' \
AbsCon_SustainedS2+orig'[0]' \
AbsCon_SustainedS3+orig'[0]' \
AbsCon_SustainedS4+orig'[0]'

@auto_tlrc -apar anat_final.Mixed_All_Runs_Orig_Together01_RUN+tlrc -input Task_Effect_Ses+orig
@auto_tlrc -apar anat_final.Mixed_All_Runs_Orig_Together01_RUN+tlrc -input Correct_Effect_Ses+orig
@auto_tlrc -apar anat_final.Mixed_All_Runs_Orig_Together01_RUN+tlrc -input Error_Effect_Ses+orig
@auto_tlrc -apar anat_final.Mixed_All_Runs_Orig_Together01_RUN+tlrc -input Sustained_Effect_Ses+orig
@auto_tlrc -apar anat_final.Mixed_All_Runs_Orig_Together01_RUN+tlrc -input All_Cue_Effect_Ses+orig
@auto_tlrc -apar anat_final.Mixed_All_Runs_Orig_Together01_RUN+tlrc -input MR_Effect_Ses+orig
@auto_tlrc -apar anat_final.Mixed_All_Runs_Orig_Together01_RUN+tlrc -input Rhyme_Effect_Ses+orig
@auto_tlrc -apar anat_final.Mixed_All_Runs_Orig_Together01_RUN+tlrc -input MR_Correct_Effect_Ses+orig
@auto_tlrc -apar anat_final.Mixed_All_Runs_Orig_Together01_RUN+tlrc -input Rhyme_Correct_Effect_Ses+orig
@auto_tlrc -apar anat_final.Mixed_All_Runs_Orig_Together01_RUN+tlrc -input MR_Cue_Effect_Ses+orig
@auto_tlrc -apar anat_final.Mixed_All_Runs_Orig_Together01_RUN+tlrc -input Rhyme_Cue_Effect_Ses+orig
@auto_tlrc -apar anat_final.Mixed_All_Runs_Orig_Together01_RUN+tlrc -input ErrorMinusCorrect_Effect_Ses+orig
@auto_tlrc -apar anat_final.Mixed_All_Runs_Orig_Together01_RUN+tlrc -input AmbMinusCorrect_Effect_Ses+orig
@auto_tlrc -apar anat_final.Mixed_All_Runs_Orig_Together01_RUN+tlrc -input Am_Effect_Ses+orig
@auto_tlrc -apar anat_final.Mixed_All_Runs_Orig_Together01_RUN+tlrc -input AbsCon_Effect_Ses+orig
@auto_tlrc -apar anat_final.Mixed_All_Runs_Orig_Together01_RUN+tlrc -input AbsCon_Correct_Effect_Ses+orig
@auto_tlrc -apar anat_final.Mixed_All_Runs_Orig_Together01_RUN+tlrc -input AbsCon_Cue_Effect_Ses+orig
@auto_tlrc -apar anat_final.Mixed_All_Runs_Orig_Together01_RUN+tlrc -input StartCue_Effect_Ses+orig
@auto_tlrc -apar anat_final.Mixed_All_Runs_Orig_Together01_RUN+tlrc -input EndCue_Effect_Ses+orig
@auto_tlrc -apar anat_final.Mixed_All_Runs_Orig_Together01_RUN+tlrc -input Rhyme_Sustained_Effect_Ses+orig
@auto_tlrc -apar anat_final.Mixed_All_Runs_Orig_Together01_RUN+tlrc -input Abscon_Sustained_Effect_Ses+orig
@auto_tlrc -apar anat_final.Mixed_All_Runs_Orig_Together01_RUN+tlrc -input MR_Sustained_Effect_Ses+orig

3dcalc -a Task_Effect_Ses+tlrc'[1]' -prefix Task_Effect_SesZ.nii -expr 'fitt_t2z(a,3)'
3dcalc -a Correct_Effect_Ses+tlrc'[1]' -prefix Correct_Effect_SesZ.nii -expr 'fitt_t2z(a,3)'
3dcalc -a Error_Effect_Ses+tlrc'[1]' -prefix Error_Effect_SesZ.nii -expr 'fitt_t2z(a,3)'
3dcalc -a Sustained_Effect_Ses+tlrc'[1]' -prefix Sustained_Effect_SesZ.nii -expr 'fitt_t2z(a,3)'
3dcalc -a All_Cue_Effect_Ses+tlrc'[1]' -prefix All_Cue_Effect_SesZ.nii -expr 'fitt_t2z(a,3)'
3dcalc -a MR_Effect_Ses+tlrc'[1]' -prefix MR_Effect_SesZ.nii -expr 'fitt_t2z(a,3)'
3dcalc -a Rhyme_Effect_Ses+tlrc'[1]' -prefix Rhyme_Effect_SesZ.nii -expr 'fitt_t2z(a,3)'
3dcalc -a MR_Correct_Effect_Ses+tlrc'[1]' -prefix MR_Correct_SesZ.nii -expr 'fitt_t2z(a,3)'
3dcalc -a Rhyme_Correct_Effect_Ses+tlrc'[1]' -prefix Rhyme_Correct_SesZ.nii -expr 'fitt_t2z(a,3)'
3dcalc -a MR_Cue_Effect_Ses+tlrc'[1]' -prefix MR_Cue_Effect_SesZ.nii -expr 'fitt_t2z(a,3)'
3dcalc -a Rhyme_Cue_Effect_Ses+tlrc'[1]' -prefix Rhyme_Cue_Effect_SesZ.nii -expr 'fitt_t2z(a,3)'
3dcalc -a ErrorMinusCorrect_Effect_Ses+tlrc'[1]' -prefix ErrorMinusCorrect_Effect_SesZ.nii -expr 'fitt_t2z(a,3)'
3dcalc -a AmbMinusCorrect_Effect_Ses+tlrc'[1]' -prefix AmbMinusCorrect_Effect_SesZ.nii -expr 'fitt_t2z(a,3)'
3dcalc -a Am_Effect_Ses+tlrc'[1]' -prefix Am_Effect_SesZ.nii -expr 'fitt_t2z(a,3)'
3dcalc -a AbsCon_Effect_Ses+tlrc'[1]' -prefix AbsCon_Effect_SesZ.nii -expr 'fitt_t2z(a,3)'
3dcalc -a AbsCon_Correct_Effect_Ses+tlrc'[1]' -prefix AbsCon_Correct_Effect_SesZ.nii -expr 'fitt_t2z(a,3)'
3dcalc -a AbsCon_Cue_Effect_Ses+tlrc'[1]' -prefix AbsCon_Cue_Effect_SesZ.nii -expr 'fitt_t2z(a,3)'
3dcalc -a StartCue_Effect_Ses+tlrc'[1]' -prefix StartCue_Effect_SesZ.nii -expr 'fitt_t2z(a,3)'
3dcalc -a EndCue_Effect_Ses+tlrc'[1]' -prefix EndCue_Effect_SesZ.nii -expr 'fitt_t2z(a,3)'
3dcalc -a Rhyme_Sustained_Effect_Ses+tlrc'[1]' -prefix Rhyme_Sustained_Effect_SesZ.nii -expr 'fitt_t2z(a,3)'
3dcalc -a Abscon_Sustained_Effect_Ses+tlrc'[1]' -prefix Abscon_Sustained_Effect_SesZ.nii -expr 'fitt_t2z(a,3)'
3dcalc -a MR_Sustained_Effect_Ses+tlrc'[1]' -prefix MR_Sustained_Effect_SesZ.nii -expr 'fitt_t2z(a,3)'