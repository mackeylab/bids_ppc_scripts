#!/bin/sh

#$ -cwd
#$ -V

if [ $# -eq 0 ]; then
echo "USAGE: remove_TRs.sh <sub_id> <ses> <rest scan number> <num of TRS to keep>

Example: remove_TRs.sh CBPD0173 01 02 140
Keeps only the first 140 TRs from the second resting-state scan in the first session for CBPD0173.
This removes TRs from the resting-state scans only. In the CBPD dataset, TRs are 2s for resting-state data. "
exit
fi

sub=${1}
ses=${2}
scannum=${3}
num=${4}

data_dir=/data/picsl/mackey_group/CBPD/CBPD_bids
scan=${data_dir}/sub-${sub}/ses-${ses}/func/sub-${sub}_ses-${ses}_task-rest_run-${scannum}_bold.nii.gz

chmod 750 ${scan}
fslroi ${scan} ${scan} 0 ${num} #go with FSL
#AFNI version is an alternative
#3dcalc -a ${scan}[0-"$num"] -expr 'a' -prefix new.nii.gz

dataleft=`mri_info --nframes ${scan}`

echo You have ${dataleft} TRs x 2 s left for ${scan}
