#!/bin/tcsh -xef

# to execute via tcsh: 
#   tcsh -xef Polrot2TestSession1.tcsh |& tee output.Polrot2TestSession1.tcsh
# to execute via bash: 
#   tcsh -xef Polrot2TestSession1.tcsh 2>&1 | tee output.Polrot2TestSession1.tcsh

# ------------------------------
# run the regression analysis
3dDeconvolve -input pb04.Mixed_All_Runs_Orig01_RUN.r01.scale+orig.HEAD pb04.Mixed_All_Runs_Orig01_RUN.r02.scale+orig.HEAD pb04.Mixed_All_Runs_Orig01_RUN.r03.scale+orig.HEAD pb04.Mixed_All_Runs_Orig01_RUN.r04.scale+orig.HEAD \
    -ortvec mot_demean.r01_ses1.1D mot_demean_r01_ses1                                  \
    -ortvec mot_demean.r02_ses1.1D mot_demean_r02_ses1                                  \
    -ortvec mot_demean.r03_ses1.1D mot_demean_r03_ses1                                  \
    -ortvec mot_demean.r04_ses1.1D mot_demean_r04_ses1                                  \
    -polort 2                                                                 \
    -local_times                                                              \
    -num_stimts 20                                                            \
    -stim_times 1 stimuli_ses1/AbsCon_abs_corr.txt 'TENT(0,17.6,16)'               \
    -stim_label 1 AbsCon_abs_corr                                             \
    -stim_times 2 stimuli_ses1/AbsCon_amb.txt 'TENT(0,17.6,16)'                    \
    -stim_label 2 AbsCon_amb                                                  \
    -stim_times 3 stimuli_ses1/AbsCon_con_corr.txt 'TENT(0,17.6,16)'               \
    -stim_label 3 AbsCon_con_corr                                             \
    -stim_times 4 stimuli_ses1/AbsCon_endcue.txt 'TENT(0,17.6,16)'                 \
    -stim_label 4 AbsCon_endcue                                               \
    -stim_times 5 stimuli_ses1/AbsCon_error.txt 'TENT(0,17.6,16)'                  \
    -stim_label 5 AbsCon_error                                                \
    -stim_times 6 stimuli_ses1/AbsCon_startcue.txt 'TENT(0,17.6,16)'               \
    -stim_label 6 AbsCon_startcue                                             \
    -stim_times 7 stimuli_ses1/AbsCon_sustained.txt 'BLOCK(104.5,1)'               \
    -stim_label 7 AbsCon_sustained                                            \
    -stim_times 8 stimuli_ses1/MR_endcue.txt 'TENT(0,17.6,16)'                     \
    -stim_label 8 MR_endcue                                                   \
    -stim_times 9 stimuli_ses1/MR_error.txt 'TENT(0,17.6,16)'                      \
    -stim_label 9 MR_error                                                    \
    -stim_times 10 stimuli_ses1/MR_mirror_corr.txt 'TENT(0,17.6,16)'               \
    -stim_label 10 MR_mirror_corr                                             \
    -stim_times 11 stimuli_ses1/MR_same_corr.txt 'TENT(0,17.6,16)'                 \
    -stim_label 11 MR_same_corr                                               \
    -stim_times 12 stimuli_ses1/MR_startcue.txt 'TENT(0,17.6,16)'                  \
    -stim_label 12 MR_startcue                                                \
    -stim_times 13 stimuli_ses1/MR_sustained.txt 'BLOCK(104.5,1)'                  \
    -stim_label 13 MR_sustained                                               \
    -stim_times 14 stimuli_ses1/Rhyme_amb.txt 'TENT(0,17.6,16)'                    \
    -stim_label 14 Rhyme_amb                                                  \
    -stim_times 15 stimuli_ses1/Rhyme_endcue.txt 'TENT(0,17.6,16)'                 \
    -stim_label 15 Rhyme_endcue                                               \
    -stim_times 16 stimuli_ses1/Rhyme_error.txt 'TENT(0,17.6,16)'                  \
    -stim_label 16 Rhyme_error                                                \
    -stim_times 17 stimuli_ses1/Rhyme_no_corr.txt 'TENT(0,17.6,16)'                \
    -stim_label 17 Rhyme_no_corr                                              \
    -stim_times 18 stimuli_ses1/Rhyme_startcue.txt 'TENT(0,17.6,16)'               \
    -stim_label 18 Rhyme_startcue                                             \
    -stim_times 19 stimuli_ses1/Rhyme_sustained.txt 'BLOCK(104.5,1)'               \
    -stim_label 19 Rhyme_sustained                                            \
    -stim_times 20 stimuli_ses1/Rhyme_yes_corr.txt 'TENT(0,17.6,16)'               \
    -stim_label 20 Rhyme_yes_corr                                             \
    -iresp 1 iresp_AbsCon_abs_corr.ses1p2                                      \
    -iresp 2 iresp_AbsCon_amb.ses1p2                                           \
    -iresp 3 iresp_AbsCon_con_corr.ses1p2                                      \
    -iresp 4 iresp_AbsCon_endcue.ses1p2                                        \
    -iresp 5 iresp_AbsCon_error.ses1p2                                         \
    -iresp 6 iresp_AbsCon_startcue.ses1p2                                      \
    -iresp 8 iresp_MR_endcue.ses1p2                                            \
    -iresp 9 iresp_MR_error.ses1p2                                             \
    -iresp 10 iresp_MR_mirror_corr.ses1p2                                      \
    -iresp 11 iresp_MR_same_corr.ses1p2                                        \
    -iresp 12 iresp_MR_startcue.ses1p2                                         \
    -iresp 14 iresp_Rhyme_amb.ses1p2                                           \
    -iresp 15 iresp_Rhyme_endcue.ses1p2                                        \
    -iresp 16 iresp_Rhyme_error.ses1p2                                         \
    -iresp 17 iresp_Rhyme_no_corr.ses1p2                                       \
    -iresp 18 iresp_Rhyme_startcue.ses1p2                                      \
    -iresp 20 iresp_Rhyme_yes_corr.ses1p2                                      \
    -num_glt 19                                                               \
    -gltsym 'SYM: +.05*AbsCon_abs_corr +.05*AbsCon_amb +.05*AbsCon_con_corr   \
    +.05*AbsCon_endcue +.05*AbsCon_error +.05*AbsCon_startcue                 \
    +.05*AbsCon_sustained +.05*MR_endcue +.05*MR_error +.05*MR_mirror_corr    \
    +.05*MR_same_corr +.05*MR_startcue +.05*MR_sustained +.05*Rhyme_amb       \
    +.05*Rhyme_endcue +.05*Rhyme_error +.05*Rhyme_no_corr +.05*Rhyme_startcue \
    +.05*Rhyme_sustained +.05*Rhyme_yes_corr'                                 \
    -glt_label 1 Task_Effect                                                  \
    -gltsym 'SYM: +.167*AbsCon_abs_corr +.167*AbsCon_con_corr                 \
    +.167*MR_mirror_corr +.167*MR_same_corr +.167*Rhyme_no_corr               \
    +.167*Rhyme_yes_corr'                                                     \
    -glt_label 2 Correct_Effect                                               \
    -gltsym 'SYM: +.33*AbsCon_error +.33*MR_error +.33*Rhyme_error'           \
    -glt_label 3 Error_Effect                                                 \
    -gltsym 'SYM: +.33*AbsCon_sustained +.33*MR_sustained                     \
    +.33*Rhyme_sustained'                                                     \
    -glt_label 4 Sustained_Effect                                             \
    -gltsym 'SYM: +.167*AbsCon_endcue +.167*AbsCon_startcue +.167*MR_endcue   \
    +.167*MR_startcue +.167*Rhyme_endcue +.167*Rhyme_startcue'                \
    -glt_label 5 All_Cue_Effect                                               \
    -gltsym 'SYM: +.167*MR_endcue +.167*MR_error +.167*MR_mirror_corr         \
    +.167*MR_same_corr +.167*MR_startcue +.167*MR_sustained'                  \
    -glt_label 6 MR_Effect                                                    \
    -gltsym 'SYM: +.143*Rhyme_amb +.143*Rhyme_endcue +.143*Rhyme_error        \
    +.143*Rhyme_no_corr +.143*Rhyme_startcue +.143*Rhyme_sustained            \
    +.143*Rhyme_yes_corr'                                                     \
    -glt_label 7 Rhyme_Effect                                                 \
    -gltsym 'SYM: +.5*MR_mirror_corr +.5*MR_same_corr'                        \
    -glt_label 8 MR_Correct_Effect                                            \
    -gltsym 'SYM: +.5*Rhyme_no_corr +.5*Rhyme_yes_corr'                       \
    -glt_label 9 Rhyme_Correct_Effect                                         \
    -gltsym 'SYM: +.5*MR_endcue +.5*MR_startcue'                              \
    -glt_label 10 MR_Cue_Effect                                               \
    -gltsym 'SYM: +.5*Rhyme_endcue +.5*Rhyme_startcue'                        \
    -glt_label 11 Rhyme_Cue_Effect                                            \
    -gltsym 'SYM: -.167*AbsCon_abs_corr -.167*AbsCon_con_corr                 \
    +.33*AbsCon_error +.33*MR_error -.167*MR_mirror_corr -.167*MR_same_corr   \
    +.33*Rhyme_error -.167*Rhyme_no_corr -.167*Rhyme_yes_corr'                \
    -glt_label 12 ErrorMinusCorrect_Effect                                    \
    -gltsym 'SYM: -.25*AbsCon_abs_corr +.5*AbsCon_amb -.25*AbsCon_con_corr    \
    +.5*Rhyme_amb -.25*Rhyme_no_corr -.25*Rhyme_yes_corr'                     \
    -glt_label 13 AmbMinusCorrect_Effect                                      \
    -gltsym 'SYM: +.5*AbsCon_amb +.5*Rhyme_amb'                               \
    -glt_label 14 Am_Effect                                                   \
    -gltsym 'SYM: +.143*AbsCon_amb +.143*AbsCon_abs_corr                      \
    +.143*AbsCon_con_corr +.143*AbsCon_endcue +.143*AbsCon_error              \
    +.143*AbsCon_startcue +.143*AbsCon_sustained'                             \
    -glt_label 15 AbsCon_Effect                                               \
    -gltsym 'SYM: +.5*AbsCon_abs_corr +.5*AbsCon_con_corr'                    \
    -glt_label 16 AbsCon_Correct_Effect                                       \
    -gltsym 'SYM: +.5*AbsCon_endcue +.5*AbsCon_startcue'                      \
    -glt_label 17 AbsCon_Cue_Effect                                           \
    -gltsym 'SYM: +.33*AbsCon_startcue +.33*MR_startcue +.33*Rhyme_startcue'  \
    -glt_label 18 StartCue_Effect                                             \
    -gltsym 'SYM: +.33*AbsCon_endcue +.33*MR_endcue +.33*Rhyme_endcue'        \
    -glt_label 19 Endcue_Effect                                               \
    -float                                                                    \
    -jobs 4                                                                   \
    -fout -tout -x1D X.xmatses1p2.1D -xjpeg Xses1p2.jpg                                   \
    -fitts fitts.ses1p2                                                        \
    -errts errts.ses1p2                                                      \
    -bucket stats.ses1p2