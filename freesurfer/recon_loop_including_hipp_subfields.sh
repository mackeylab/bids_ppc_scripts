#!/bin/sh
# Loop for running recons on many participants
set -euo pipefail

declare -a array=(CBPD0182
CBPD0183
CBPD0203
CBPD0204)

ses=01
T1=run-01
export SUBJECTS_DIR=${BIDS_dir}/derivatives/freesurfer/
for sub in "${array[@]}"
do
  freesurfer_input=${BIDS_dir}/sub-${sub}/ses-${ses}/anat/sub-${sub}_ses-${ses}_${T1}_T1w.nii.gz
  qsub -j y -o /cbica/projects/cbpd_main_data/qsub_output -q himem.q,all.q,basic.q,gpu.q "recon-all -all -subjid ${sub} -i ${freesurfer_input} -hippocampal-subfields-T1"
done
