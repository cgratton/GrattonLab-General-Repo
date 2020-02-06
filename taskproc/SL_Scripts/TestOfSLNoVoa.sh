subject=01

runname=RUN
echo $subject
cd /Users/derek.smith/Desktop/General_Testing_Folder/iNetworks_AFNI_Tstat_Test/sl
afni_proc.py                                                          \
-subj_id TestOfSL_NoVoa${subject}_${runname}                                        \
-copy_anat /Users/derek.smith/Desktop/General_Testing_Folder/iNetworks_AFNI_Tstat_Test/sl/anat/struc1_e1.nii                         \
-dsets /Users/derek.smith/Desktop/General_Testing_Folder/iNetworks_AFNI_Tstat_Test/sl/func/func_?.nii                     \
-blocks despike align volreg blur mask scale regress                                                   \
-script TestOfSL_NoVoa.tcsh                               \
-volreg_align_to MIN_OUTLIER                                                \
-volreg_align_e2a                                                     \
-volreg_allin_cost lpa+zz \
-volreg_post_vr_allin yes \
-volreg_pvra_base_index MIN_OUTLIER  \
-align_opts_aea -AddEdge -giant_move                                              \
-blur_size 4                                                          \
-regress_stim_times /Users/derek.smith/Desktop/General_Testing_Folder/iNetworks_AFNI_Tstat_Test/sl/stimuli_No_VOA/*.txt  \
-regress_stim_labels corr1_3 corr4 corr5 corr6 corr7 error_omission error4 error5 error6 error7             \
-regress_basis_multi 'TENT(0,28.6,27)' 'TENT(0,28.6,27)' 'TENT(0,28.6,27)' 'TENT(0,28.6,27)' 'TENT(0,28.6,27)' 'TENT(0,28.6,27)' 'TENT(0,28.6,27)' 'TENT(0,28.6,27)' 'TENT(0,28.6,27)' 'TENT(0,28.6,27)' \
-regress_local_times                                                  \
-regress_censor_motion 0.3                                            \
-regress_motion_per_run   \
-regress_opts_3dD                                                     \
-float                                                                \
-jobs 4                                                               \
-regress_est_blur_epits                                               \
-regress_est_blur_errts                                               \
-regress_run_clustsim no                                             \
-bash