#!/bin/sh

#$ -cwd
#$ -V
set -euo pipefail

if [ $# -eq 0 ]; then
echo "Usage: recon_all_init.sh <sub_id> <run_num>"
exit
fi

SUB=$1
RUN_NUM=$2

export SUBJECTS_DIR=/data/picsl/mackey_group/CBPD/CBPD_bids/derivatives/freesurfer_t1t2_test
NII_DIR=/data/picsl/mackey_group/CBPD/CBPD_bids/
NII=${NII_DIR}/sub-${SUB}/ses-01/anat/sub-${SUB}_ses-01_run-0${RUN_NUM}_T1w.nii.gz

recon-all -subjid ${SUB} -i ${NII} -all
