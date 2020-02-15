#For all already processed subjects
set -euo pipefail
#$ -j y
#$ -o /data/picsl/mackey_group/CBPD/output/qsub_output
#$ -q himem.q,all.q,basic.q,gpu.q

SCRIPTS_DIR=/data/picsl/mackey_group/CBPD/bids_ppc_scripts/assign_fieldmaps

BIDS_DIR=/data/picsl/mackey_group/CBPD/CBPD_bids/ #need a trailing /

cd $BIDS_DIR
for subject in `find . -maxdepth 1 -mindepth 1 -type d -name "sub-*" | sed -e 's|.*/||'`
do
  echo ${subject}
  sub=${subject:4} #take off the sub- part
  for ses in ${subject}/*
  do
    echo ${ses}
    ses=`basename ${ses}` #take only the dirname
    ses=${ses:4} #take off the ses- part
    echo ${sub} ${ses}
    if python ${SCRIPTS_DIR}/assign_fieldmaps_to_IntendedFor_field.py ${sub} ${ses} ${BIDS_DIR} ; then
      echo 'Assigned fieldmap for' ${sub} ${ses}
    else
      echo 'Could not assign fieldmap for' ${sub} ${ses}
    fi
    done
done
