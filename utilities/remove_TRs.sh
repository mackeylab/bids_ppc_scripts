#!/bin/sh

#$ -cwd
#$ -V

if [ $# -eq 0 ]; then
echo "Usage: remove_TRs.sh <sub_id> <ses> <scan> <num of TRS to remove> \n
Example: remove_TRs.sh CBPDxxx xxx 16"
exit
fi

sub=${1}
ses=${2}
scan=${3}
num=${4}
num=30
scan=sub-CBPD0173_ses-01_task-rest_run-01_bold.nii.gz
#AFNI version is the alternative
#3dcalc -a ${scan}[0-"$num"] -expr 'a' -prefix new.nii.gz

fslroi ${scan} new.nii.gz 0 ${num} #go with FSL

dataleft=`mri_info --nframes new.nii.gz`

echo `you have ${dataleft} TRs x 2 s left for ${sub}`
