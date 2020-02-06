 afni_proc.py -subj_id INET006 -script                                                                                                               \
     /projects/b1081/proc.preprocAFNI.sub-INET006.sess-1_PathtoBase                      \
     -scr_overwrite -out_dir                                                                                                                         \
     /projects/b1081/ses_1_TestOutput/                                                    \
     -blocks despike align tlrc volreg mask scale -copy_anat                                                                                         \
     /projects/b1081/Input_Globus/ForQuest/sub-INET006/ses-1/anat/sub-INET006_ses-1_acq-RMS_T1w_defaced.nii.gz \
     -tcat_remove_first_trs 0 -dsets                                                                                                                 \
     /projects/b1081/Input_Globus/ForQuest/sub-INET006/ses-1/func/sub-INET006_ses-1_task-mixed_run-01_bold.nii.gz             \
     /projects/b1081/Input_Globus/ForQuest/sub-INET006/ses-1/func/sub-INET006_ses-1_task-mixed_run-02_bold.nii.gz             \
     /projects/b1081/Input_Globus/ForQuest/sub-INET006/ses-1/func/sub-INET006_ses-1_task-mixed_run-03_bold.nii.gz             \
     /projects/b1081/Input_Globus/ForQuest/sub-INET006/ses-1/func/sub-INET006_ses-1_task-mixed_run-04_bold.nii.gz             \
     /projects/b1081/Input_Globus/ForQuest/sub-INET006/ses-1/func/sub-INET006_ses-1_task-rest_run-01_bold.nii.gz              \
     /projects/b1081/Input_Globus/ForQuest/sub-INET006/ses-1/func/sub-INET006_ses-1_task-rest_run-02_bold.nii.gz              \
     /projects/b1081/Input_Globus/ForQuest/sub-INET006/ses-1/func/sub-INET006_ses-1_task-rest_run-03_bold.nii.gz              \
     /projects/b1081/Input_Globus/ForQuest/sub-INET006/ses-1/func/sub-INET006_ses-1_task-rest_run-04_bold.nii.gz              \
     /projects/b1081/Input_Globus/ForQuest/sub-INET006/ses-1/func/sub-INET006_ses-1_task-rest_run-05_bold.nii.gz              \
     /projects/b1081/Input_Globus/ForQuest/sub-INET006/ses-1/func/sub-INET006_ses-1_task-rest_run-06_bold.nii.gz              \
     /projects/b1081/Input_Globus/ForQuest/sub-INET006/ses-1/func/sub-INET006_ses-1_task-rest_run-07_bold.nii.gz              \
     /projects/b1081/Input_Globus/ForQuest/sub-INET006/ses-1/func/sub-INET006_ses-1_task-slowreveal_run-01_bold.nii.gz        \
     /projects/b1081/Input_Globus/ForQuest/sub-INET006/ses-1/func/sub-INET006_ses-1_task-slowreveal_run-02_bold.nii.gz        \
     /projects/b1081/Input_Globus/ForQuest/sub-INET006/ses-1/func/sub-INET006_ses-1_task-slowreveal_run-03_bold.nii.gz        \
     /projects/b1081/Input_Globus/ForQuest/sub-INET006/ses-1/func/sub-INET006_ses-1_task-slowreveal_run-04_bold.nii.gz        \
     -align_opts_aea -cost lpc+ZZ -AddEdge -giant_move -tlrc_base                                                                                    \
     /projects/b1081/Templates/MNI152_T1_2009c+tlrc -tlrc_NL_warp -volreg_align_to MIN_OUTLIER                                                                                 \
     -volreg_post_vr_allin yes -volreg_align_e2a -volreg_tlrc_warp -bash
