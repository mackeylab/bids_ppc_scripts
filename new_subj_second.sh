#!/bin/sh
#$ -cwd
#$ -V
#$ -j y
#$ -l h_vmem=19.1G,s_vmem=19.0G
#$ -o /data/picsl/mackey_group/CBPD/output/qsub_output
#$ -q himem.q,all.q,basic.q,gpu.q

set -euo pipefail

if [ $# -eq 0 ]; then
echo "USAGE: qsub new_subj_second.sh <BIDS_input_dir> <sub_id> <ses> <run of T1 for Freesurfer>

Example: new_subj_second.sh /data/picsl/my_bids_dir CBPDxxx xxx run-02
This runs MRIQC on this subject, and adds their quality metrics to the MRIQC group output.
Then, it runs Freesurfer using the second MPRAGE of CBPDxxxx's first session,
including hippocampal subfields. Finally, it start fMRIprep running,
which should detect precomputed freesurfer inputs.
"
exit
fi

BIDS_dir=${1}
sub=${2} #CBPDxxxx
ses=${3} #01,02,03
T1=${4}
SCRIPTS_DIR=/data/picsl/mackey_group/CBPD/bids_ppc_scripts

echo ~~~~~~~~~~~~~
echo ~~~~ Run MRIQC ~~~~~~
echo ~~~~~~~~~~~~~

echo Running MRIQC with 1 mm FD threshold for ${sub} session ${ses}

bash ${SCRIPTS_DIR}/mriqc/run_mriqc.sh ${sub} ${ses} ${BIDS_dir}

echo Finished MRIQC with 1 mm FD threshold for ${sub} session ${ses}

echo ~~~~~~~~~~~~~
echo ~~~~ Collate MRIQC group output ~~~~~~
echo ~~~~~~~~~~~~~

echo Adding ${sub} session ${ses} to MRIQC group files

bash ${SCRIPTS_DIR}/mriqc/aggregate_group_mriqc.sh ${BIDS_dir}/mriqc_fd_1_mm

echo Finished adding ${sub} session ${ses} to MRIQC group files

echo ~~~~~~~~~~~~~
echo ~~~~ Freesurfer with hippocampal subfields, selected T1 ~~~~~~
echo ~~~~~~~~~~~~~

#Does Freesurfer already exist for this person? If so, don't rerun!
#If not, run it!
echo Running Freesurfer with hipp subfields for ${sub} session ${ses}

export SUBJECTS_DIR=${BIDS_dir}/derivatives/freesurfer/
if [ -e ${BIDS_dir}/derivatives/freesurfer/${sub}/scripts/recon-all.done ]; then
  echo 'Freesurfer is already run for' ${sub} session ${ses}
elif [ -e /data/picsl/mackey_group/BPD/surfaces/${sub}/scripts/recon-all.done ]; then
  echo 'Freesurfer surfaces are in /BPD/surfaces/ but not in the BIDS directory you specified' for ${sub} session ${ses}
else
  freesurfer_input=${BIDS_dir}/sub-${sub}/ses-${ses}/anat/sub-${sub}_ses-${ses}_${T1}_T1w.nii.gz
  echo 'Freesurfer input is' ${freesurfer_input}
  recon-all -all -subjid ${sub} -i ${freesurfer_input} -hippocampal-subfields-T1

echo Finished running Freesurfer with hipp subfields for ${sub} session ${ses}

echo ~~~~~~~~~~~~~
echo ~~~~ Run fMRIprep ~~~~~~
echo ~~~~~~~~~~~~~

#with precomputed Freesurfer
#we may in the future be able to select which T1 gets fed to fmriprep, without having to .bidsignore them

echo Running fMRIprep for ${sub} session ${ses}

#do it

echo Finished running fMRIprep for ${sub} session ${ses}
