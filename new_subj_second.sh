#!/bin/sh
#$ -cwd
#$ -V
#$ -j y
#$ -l h_vmem=19.1G,s_vmem=19.0G
#$ -o /data/picsl/mackey_group/CBPD/output/qsub_output
#$ -q himem.q,all.q,basic.q,gpu.q

#Set Python environment if you have one
if [ `whoami` = CBLuser ]; then
	source activate bids_ppc
fi

set -euo pipefail

if [ $# -eq 0 ]; then
echo "USAGE: qsub new_subj_second.sh <full_path_to_BIDS_input_dir> <sub_id> <ses> <run of T1 for Freesurfer>

Example: new_subj_second.sh /data/picsl/my_bids_dir CBPDxxx 01 run-02
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
SCRIPTS_DIR=/cbica/projects/cbpd_main_data/code/bids_ppc_scripts

echo ~~~~~~~~~~~~~
echo ~~~~ Run MRIQC ~~~~~~
echo ~~~~~~~~~~~~~

echo Running MRIQC with 1 mm FD threshold for ${sub} session ${ses}

if [ -e ${BIDS_dir}/derivatives/mriqc_fd_1_mm/sub-${sub}_ses-${ses}_run-01_T1w.html ]; then
  echo 'MRIQC already run with 1 mm threshold for' ${sub} 'session' ${ses}
else
  bash ${SCRIPTS_DIR}/MRIQC/run_mriqc.sh 1 ${sub} ${ses} ${BIDS_dir}
fi

echo Finished MRIQC with 1 mm FD threshold for ${sub} session ${ses}

echo ~~~~~~~~~~~~~
echo ~~~~ Collate MRIQC group output ~~~~~~
echo ~~~~~~~~~~~~~

echo Adding ${sub} session ${ses} to MRIQC group files

bash ${SCRIPTS_DIR}/MRIQC/aggregate_group_mriqc.sh 1 ${BIDS_dir}

echo Finished adding ${sub} session ${ses} to MRIQC group files

echo ~~~~~~~~~~~~~
echo ~~~~ Filter MRIQC columns ~~~~~~
echo ~~~~~~~~~~~~~

echo Rewriting MRIQC_filtered_columns.csv to add new input

python ${SCRIPTS_DIR}/utilities/parse_mriqc_cols.py ${BIDS_dir} 1

echo Rewrote MRIQC_filtered_columns.csv to add new input

echo ~~~~~~~~~~~~~
echo ~~~~ Freesurfer with hippocampal subfields, selected T1 ~~~~~~
echo ~~~~~~~~~~~~~

#Does Freesurfer already exist for this person? If so, don't rerun!
#If not, run it!
echo Running Freesurfer with hipp subfields for ${sub} session ${ses}

export FREESURFER_HOME=/share/apps/freesurfer/6.0.0-make-fix/
if [ ${ses} == 01 ]; then
  fs_sub=${sub}
  export SUBJECTS_DIR=${BIDS_dir}/derivatives/freesurfer_t1
elif [ ${ses} == 02 ]; then
  fs_sub=${sub}_2
  export SUBJECTS_DIR=${BIDS_dir}/derivatives/freesurfer_t2
elif [ ${ses} == 03 ]; then
  fs_sub=${sub}_3
  export SUBJECTS_DIR=${BIDS_dir}/derivatives/freesurfer_t3
fi
if grep -q RUNTIME_HOURS ${SUBJECTS_DIR}/sub-${sub}/scripts/recon-all.done; then
  echo 'Freesurfer is already run for' ${sub} session ${ses}
# elif [ -e /data/picsl/mackey_group/BPD/surfaces/${fs_sub}/scripts/recon-all.done ]; then
#   echo 'Error, Freesurfer surfaces are in /BPD/surfaces/ but not in the BIDS directory you specified' for ${sub} session ${ses}
#   echo 'Please move them and rename them to begin with sub-'
#   break
else
  freesurfer_input=${BIDS_dir}/sub-${sub}/ses-${ses}/anat/sub-${sub}_ses-${ses}_${T1}_T1w.nii.gz
  echo 'Freesurfer input is' ${freesurfer_input}
  echo recon-all -all -subjid sub-${sub} -i ${freesurfer_input} -hippocampal-subfields-T1
fi

echo Finished running Freesurfer with hipp subfields for ${sub} session ${ses}

echo ~~~~~~~~~~~~~
echo ~~~~ Freesurfer on experimental T1s all timepoints ~~~~~~
echo ~~~~~~~~~~~~~

export SUBJECTS_DIR=${BIDS_dir}/derivatives/freesurfer_acc42/
if [ -e ${BIDS_dir}/sub-${sub}/ses-${ses}/anat/sub-${sub}_ses-${ses}_acq-csacc42*.nii.gz ]; then
  echo 'There is a CSMPRAGE_1mm_acc42 for' ${sub} 'session' ${ses}
  freesurfer_input=${BIDS_dir}/sub-${sub}/ses-${ses}/anat/sub-${sub}_ses-${ses}_acq-csacc42*.nii.gz
  if grep -q RUNTIME_HOURS ${SUBJECTS_DIR}/sub-${fs_sub}/scripts/recon-all.done; then
		echo 'Freesurfer was already run for CSMPRAGE_1mm_acc42 for' ${sub} 'session' ${ses}
	else
		echo 'Running recon-all for CSMPRAGE_1mm_acc42'
		echo $freesurfer_input
		recon-all -all -subjid sub-${fs_sub} -i ${freesurfer_input}
		echo 'Ran recon-all for CSMPRAGE_1mm_acc42'
  fi
else
  echo 'No CSMPRAGE_1mm_acc42 for' ${sub} 'session' ${ses} 'exists'
fi

export SUBJECTS_DIR=${BIDS_dir}/derivatives/freesurfer_acc5/
if [ -e ${BIDS_dir}/sub-${sub}/ses-${ses}/anat/sub-${sub}_ses-${ses}_acq-csacc5*.nii.gz ]; then
  echo 'There is a CSMPRAGE_1mm_acc5 for ' ${sub} 'session' ${ses}
  freesurfer_input=${BIDS_dir}/sub-${sub}/ses-${ses}/anat/sub-${sub}_ses-${ses}_acq-csacc5*.nii.gz
	if grep -q RUNTIME_HOURS ${SUBJECTS_DIR}/sub-${fs_sub}/scripts/recon-all.done; then
		echo 'Freesurfer was already run for CSMPRAGE_1mm_acc5 for' ${sub} 'session' ${ses}
  else
		echo 'Running recon-all for CSMPRAGE_1mm_acc5'
		echo $freesurfer_input
		recon-all -all -subjid sub-${fs_sub} -i ${freesurfer_input}
		echo 'Ran recon-all for CSMPRAGE_1mm_acc5'
  fi
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
if [ -e ${BIDS_dir}/derivatives/fmriprep_t${ses:1}/fmriprep/sub-${sub}.html ]; then
	echo 'fMRIprep is already run for sub' ${sub}
else
	bash ${SCRIPTS_DIR}/fmriprep/fmriprep_cmd_v20.0.2.sh ${sub} ${ses} ${BIDS_dir}
fi
echo Finished running fMRIprep for ${sub} session ${ses}

echo ~~~~~~~~~~~~~
echo ~~~~ All done! ~~~~~~
echo ~~~~~~~~~~~~~
