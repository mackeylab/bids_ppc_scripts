#!/bin/sh
#run hipp subfields on everyone it hasn't been run on but who has baseline Freesurfer

set -euo pipefail
qsub_output=/data/picsl/mackey_group/CBPD/output/qsub_output

export SUBJECTS_DIR=/data/picsl/mackey_group/CBPD/CBPD_bids/derivatives/freesurfer
for sub in `find ${SUBJECTS_DIR} -maxdepth 1 -mindepth 1 -type d -name "CBPD*" -exec basename {} \;`;
do
  echo ${sub}
if [ -e ${SUBJECTS_DIR}/${sub}/scripts/recon-all.done ] && [ ! -e ${SUBJECTS_DIR}/${sub}/mri/lh.hippoSfLabels-T1.v10.mgz ]; then
  echo 'hipp subfields not done for' ${sub}
  echo "recon-all -s ${sub} -hippocampal-subfields-T1" > script.sh
  qsub -j y -o ${qsub_output} -l h_vmem=20.1G,s_vmem=20G -V -q himem.q,all.q,basic.q,gpu.q script.sh
elif [ -e ${SUBJECTS_DIR}/${sub}/mri/lh.hippoSfLabels-T1.v10.mgz ]; then
  echo 'hipp subfields done for' ${sub}
fi
done
