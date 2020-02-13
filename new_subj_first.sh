#!/bin/sh
#$ -cwd
#$ -V
#$ -j y
#$ -o /data/picsl/mackey_group/CBPD/output/qsub_output
#$ -q himem.q,all.q,basic.q,gpu.q
set -euo pipefail

if [ $# -eq 0 ]; then
echo "USAGE: qsub new_subj_first.sh <sub_id> <BIDS_output_dir>

Example: new_subj_first.sh CBPDxxx[_x] /data/picsl/mackey_group/BIDS/
This runs heudiconv, fixes the blip-up blip-down/TOPUP sequences, and assigns the IntendedFor field to the fieldmaps.
After this is run, check for any runs that need to be truncated or .bidsignored, and any sleep during resting-state.
"
exit
fi

sub=${1:0:8} #CBPDxxxx
ses=0${1:9} #change timepoint to 01,02,03
if [[ ${ses} == 0 ]]; then #no suffix is timepoint 01
  ses=01
fi
BIDS_dir=$(readlink -f $2) #resolve relative path, make it absolute

echo ~~~~~~~~~~~~~
echo ~~~~ Convert using Heudiconv ~~~~~~
echo ~~~~~~~~~~~~~

echo Doing Heudiconv conversion for ${sub} session ${ses}
echo BIDS directory is ${BIDS_dir}
SCRIPTS_DIR=/data/picsl/mackey_group/CBPD/bids_ppc_scripts

sleep .5
if [[ $ses == 02 ]]; then #the ID is longer than x digits and ends in _2, it's a longitudinal subject, then convert
   echo 'its longitudinal T2'
   bash ${SCRIPTS_DIR}/heudiconv/heudiconv_cmd_longitud_T2.sh ${sub} ${BIDS_dir}
 elif [[ $ses == 03 ]]; then
   echo 'its longitudinal T3'
   bash ${SCRIPTS_DIR}/heudiconv/heudiconv_cmd_longitud_T3.sh ${sub} ${BIDS_dir}
 else
   echo 'its not longitudinal'
   bash ${SCRIPTS_DIR}/heudiconv/heudiconv_cmd.sh ${sub} ${BIDS_dir}
fi

echo Finished heudiconv conversion for ${sub} session ${ses}

echo ~~~~~~~~~~~~~
echo ~~~~ Fix TOPUP scans ~~~~~~
echo ~~~~~~~~~~~~~

echo Fixing TOPUP scan for ${sub} session ${ses}

sleep .5
bash ${SCRIPTS_DIR}/fix_topup_sequences/fix_one_sub_topup_sequence.sh ${sub} ${ses} ${BIDS_dir}

echo Finished fixing TOPUP scan for ${sub} session ${ses}

echo ~~~~~~~~~~~~~
echo ~~~~ Assign IntendedFor field to fieldmap scans ~~~~~~
echo ~~~~~~~~~~~~~

echo Assigning Intended For field for ${sub} session ${ses}
echo python ${SCRIPTS_DIR}/assign_fieldmaps/assign_fieldmaps_to_IntendedFor_field.py ${sub} ${ses} ${BIDS_dir}

python ${SCRIPTS_DIR}/assign_fieldmaps/assign_fieldmaps_to_IntendedFor_field.py ${sub} ${ses} ${BIDS_dir}

echo Finished assigning Intended For field for ${sub} session ${ses}

echo Now check whether you need to remove some TRs for sleeping, or whether we should add some scans to the .bidsignore file.
