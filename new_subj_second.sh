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

BIDS_dir=$(readlink -f $1)
sub=${2} #CBPDxxxx
ses=${3} #01,02,03
T1=${4}
SCRIPTS_DIR=/data/picsl/mackey_group/CBPD/bids_ppc_scripts

echo ~~~~~~~~~~~~~
echo ~~~~ Run MRIQC ~~~~~~
echo ~~~~~~~~~~~~~

echo Running MRIQC with 1 mm FD threshold for ${sub} session ${ses}

bash ${SCRIPTS_DIR}/MRIQC/run_mriqc.sh 1 ${sub} ${ses} ${BIDS_dir}

echo Finished MRIQC with 1 mm FD threshold for ${sub} session ${ses}

echo ~~~~~~~~~~~~~
echo ~~~~ Collate MRIQC group output ~~~~~~
echo ~~~~~~~~~~~~~

echo Adding ${sub} session ${ses} to MRIQC group files

bash ${SCRIPTS_DIR}/MRIQC/aggregate_group_mriqc.sh 1 ${BIDS_dir}

echo Finished adding ${sub} session ${ses} to MRIQC group files

echo ~~~~~~~~~~~~~
echo ~~~~ Freesurfer with hippocampal subfields, selected T1 ~~~~~~
echo ~~~~~~~~~~~~~

#Does Freesurfer already exist for this person? If so, don't rerun!
#If not, run it!
echo Running Freesurfer with hipp subfields for ${sub} session ${ses}

export SUBJECTS_DIR=${BIDS_dir}/derivatives/freesurfer/
export FREESURFER_HOME=/share/apps/freesurfer/6.0.0-make-fix/
if [ ${ses} == 01 ]; then
  fs_sub=${sub}
elif [ ${ses} == 02 ]; then
  fs_sub=${sub}_2
elif [ ${ses} == 03 ]; then
  fs_sub=${sub}_3
fi
if [ -e ${BIDS_dir}/derivatives/freesurfer/${fs_sub}/scripts/recon-all.done ]; then
  echo 'Freesurfer is already run for' ${sub} session ${ses}
elif [ -e /data/picsl/mackey_group/BPD/surfaces/${fs_sub}/scripts/recon-all.done ]; then
  echo 'Freesurfer surfaces are in /BPD/surfaces/ but not in the BIDS directory you specified' for ${sub} session ${ses}
  break
else
  freesurfer_input=${BIDS_dir}/sub-${sub}/ses-${ses}/anat/sub-${sub}_ses-${ses}_${T1}_T1w.nii.gz
  echo 'Freesurfer input is' ${freesurfer_input}
  recon-all -all -subjid ${fs_sub} -i ${freesurfer_input} -hippocampal-subfields-T1
fi

echo Finished running Freesurfer with hipp subfields for ${sub} session ${ses}

echo ~~~~~~~~~~~~~
echo ~~~~ Freesurfer on experimental T1s ~~~~~~
echo ~~~~~~~~~~~~~

export SUBJECTS_DIR=${BIDS_dir}/derivatives/freesurfer_acc42/
if [ -e ${BIDS_dir}/sub-${sub}/ses-${ses}/anat/sub-${sub}_ses-${ses}_acq-csacc42*.nii.gz ] && [ ! -d ${SUBJECTS_DIR}/${sub}/ ]; then
  echo 'There is a CSMPRAGE_1mm_acc42 for' ${sub} 'session' ${ses}
  freesurfer_input=${BIDS_dir}/sub-${sub}/ses-${ses}/anat/sub-${sub}_ses-${ses}_acq-csacc42*.nii.gz
  echo $freesurfer_input
  recon-all -all -subjid ${fs_sub} -i ${freesurfer_input}
  echo 'Ran recon-all for CSMPRAGE_1mm_acc4'
else
  echo 'No CSMPRAGE_1mm_acc42 for' ${sub} 'session' ${ses} 'exists'
fi

export SUBJECTS_DIR=${BIDS_dir}/derivatives/freesurfer_acc5/
if [ -e ${BIDS_dir}/sub-${sub}/ses-${ses}/anat/sub-${sub}_ses-${ses}_acq-csacc5*.nii.gz ] && [ ! -d ${SUBJECTS_DIR}/${sub}/ ]; then
  echo 'There is a CSMPRAGE_1mm_acc5 for ' ${sub} 'session' ${ses}
  freesurfer_input=${BIDS_dir}/sub-${sub}/ses-${ses}/anat/sub-${sub}_ses-${ses}_acq-csacc5*.nii.gz
  echo $freesurfer_input
  recon-all -all -subjid ${fs_sub} -i ${freesurfer_input}
  echo 'Ran recon-all for CSMPRAGE_1mm_acc5'
else
  echo 'No CSMPRAGE_1mm_acc5 for' ${sub} 'session' ${ses} 'exists'
fi

echo ~~~~~~~~~~~~~
echo ~~~~ Run fMRIprep ~~~~~~
echo ~~~~~~~~~~~~~

#with precomputed Freesurfer
#we may be able to run Freesurfer cross-sectionally within fmriprep by using --bids-filter-file
export SUBJECTS_DIR=${BIDS_dir}/derivatives/freesurfer
echo Running fMRIprep for ${sub} session ${ses}

echo bash ${SCRIPTS_DIR}/fmriprep/fmriprep_cmd_v20.0.1.sh ${sub} ${ses} ${BIDS_dir}

echo Finished running fMRIprep for ${sub} session ${ses}

echo ~~~~~~~~~~~~~
echo ~~~~ All done! ~~~~~~
echo ~~~~~~~~~~~~~
