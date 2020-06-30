# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

### User specific aliases and functions

## CG ADDED 01-15-2019
# 4dfp tools
export REFDIR="/projects/b1081/Scripts/4dfp_tools/lin64-atlas"
export RELEASE="/projects/b1081/Scripts/4dfp_tools/lin64-tools"
export PATH="$RELEASE:$PATH"

## CG ADDED 01-28-2020
# files needed to build fmriprep singularity containers
export PATH="/usr/sbin:$PATH"

## CG ADDED 05-07-2020
# fsl related information
export FSL_HOME="/software/fsl_508/"
. /software/fsl/fsl_508/etc/fslconf/fsl.sh

# freesurfer related information
export FREESURFER_HOME="/software/freesurfer/6.0/"
