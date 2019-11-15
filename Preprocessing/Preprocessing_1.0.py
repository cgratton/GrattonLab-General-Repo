"""
Preprocessing script for the Gratton lab
-------------------------------
Currently optimized to work for iNetworks project protocols
Assumes BIDS organized file structure

v1.0: Created by CG on 2019-08-27
Based on examples from D. Smith, E. Gordon, Bids-App AFNI code



"""

# imports
import os
import glob

# Initialization of directory information:
# EDIT AS NEEDED
#this_dir = os.getcwd() + '/'
data_dir = '~/Box/DATA/iNetworks/Nifti/' # location of the nifti input data
afni_dir = '~/abin/' #needs to be downloaded and installed
out_dir_top = '~/Desktop/derivatives/preproc_afni/' # location to put output; for now put on desktop so I can make needed simlinks (doesn't work with Box)
if not os.path.exists(out_dir_top):
    os.mkdir(out_dir_top)
script_dir = out_dir_top + 'proc_scripts/' #location to put afni_proc scripts
if not os.path.exists(script_dir):
    os.mkdir(script_dir)

# Things to run (for now here, eventually read as inputs/from a params file)
subs = ['INET006']
sess = [1,2,3,4]

# loop through subjects
for sub in subs:
    sub_name = sub #'iNet%03d' % sub
    sub_dir_in = data_dir + 'sub-' + sub_name + '/'
    sub_dir_out = out_dir_top + 'sub-' + sub_name + '/'
    if not os.path.exists(sub_dir_out):
        os.mkdir(sub_dir_out)

    # anatomical inputs
    sub_dir_in_anat = sub_dir_out + 'anat_ses-all/' # put this in derivatives directory
    if not os.path.exists(sub_dir_in_anat): # to link in all anatomicals
        os.mkdir(sub_dir_in_anat)
    for ses in sess:
        ses_dir_in = sub_dir_in + 'ses-' + str(ses) + '/'

        # set up the antomical files to all be linked into the subject level directory
        # NOTE: may eventually want to do this outside of this script, so that we can QC
        # anatomical files first and select which we want ot move orward with
        anat_files = glob.glob(ses_dir_in + 'anat/sub-' + sub_name
                                   +'_ses-' + str(ses) + '*.nii.gz')
        for af in anat_files:
            afpath, affile = os.path.split(af)
            cmd = 'ln -s %s %s%s' %(af,sub_dir_in_anat,affile) # Box can't simlink - switch to cp if needed
            os.system(cmd)

    # functional inputs
    # eventually: put these all in the same directory so that functional data will be aligned together
    
    # loop through sessions for processing
    for ses in sess:
        ses_dir_in = sub_dir_in + 'ses-' + str(ses) + '/'
        ses_dir_out = sub_dir_out + 'ses-' + str(ses) + '/'
        if os.path.exists(ses_dir_out): # in this case, remove previous instances of this directory
            os.system('rm -rf %s' %(ses_dir_out))
        #os.mkdir(ses_dir_out)

        # now write out afni command
        afni_command = 'python ' + afni_dir + 'afni_proc.py -subj_id ' + sub_name + ' \
        -script ' + script_dir + 'proc.preprocAFNI.sub-' + sub_name + '.sess-' + str(ses) + ' \
        -scr_overwrite -out_dir ' + ses_dir_out + ' \
        -blocks despike align tlrc volreg mask scale \
        -copy_anat ' + sub_dir_in_anat + '*_T1w_2.nii.gz -tcat_remove_first_trs 0 \
        -dsets ' + ses_dir_in + 'func/*bold.nii.gz -align_opts_aea -cost lpc+ZZ -AddEdge -giant_move \
        -tlrc_base MNI152_T1_2009c+tlrc -tlrc_NL_warp \
        -volreg_align_to MIN_OUTLIER \
        -volreg_post_vr_allin yes \
        -volreg_align_e2a -volreg_tlrc_warp \
        -bash'

        print(afni_command)
        os.system(afni_command)

        # run output file
        os.system('tcsh -xef ' + script_dir + 'proc.preprocAFNI.sub-' + sub_name + '.sess-' + str(ses) +
                      ' 2>&1 | tee ' + script_dir + 'output.proc.preprocAFNI.sub-' + sub_name + '.sess-' + str(ses))

        # FOR ME:
        # 1. need to think about how we want to do alignment
        # across different sessions. Right now, every session is
        # handlede separately, and each is aligned to the T1. BUT may
        # want to instead do functional alignment across days first.

        # 2. need to determine how to incoporate field maps







