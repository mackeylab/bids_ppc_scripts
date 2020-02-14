#!/bin/sh

#$ -cwd
#$ -V
set -euo pipefail

if [ $# -eq 0 ]; then
echo "Usage: recon_all_init_wT2.sh <sub_id> <run_num_t1> <run_num_t2>"
exit
fi

SUB=$1
RUN_NUM_T1=$2
RUN_NUM_T2=$3

export SUBJECTS_DIR=/data/picsl/mackey_group/CBPD/CBPD_bids/derivatives/freesurfer_t1t2_test
NII_DIR=/data/picsl/mackey_group/CBPD/CBPD_bids/
T1=${NII_DIR}/sub-${SUB}/ses-01/anat/sub-${SUB}_ses-01_run-0${RUN_NUM_T1}_T1w.nii.gz
T2=${NII_DIR}/sub-${SUB}/ses-01/anat/sub-${SUB}_ses-01_run-0${RUN_NUM_T2}_T2w.nii.gz


recon-all -subject ${SUB}_T1T2 -i ${T1} -T2 ${T2} -T2pial -all
