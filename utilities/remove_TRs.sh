#!/bin/sh

#$ -cwd
#$ -V

if [ $# -eq 0 ]; then
echo "USAGE: remove_TRs.sh <sub_id> <ses> <scan> <num of TRS to keep>

Example: remove_TRs.sh CBPDxxx xxx 16
TRs in the CBPD dataset are 2s for resting-state data. "
exit
fi

sub=${1}
ses=${2}
scan=${3}
num=${4}

num=211
scan=sub-CBPD0173_ses-01_task-rest_run-01_bold.nii.gz
#AFNI version is an alternative
#3dcalc -a ${scan}[0-"$num"] -expr 'a' -prefix new.nii.gz

fslroi ${scan} ${scan} 0 ${num} #go with FSL

dataleft=`mri_info --nframes ${scan}`

echo You have ${dataleft} TRs x 2 s left for ${scan}
