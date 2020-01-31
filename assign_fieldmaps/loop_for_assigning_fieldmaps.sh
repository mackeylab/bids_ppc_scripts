#For all already processed subjects
set -euo pipefail

SCRIPTS_DIR=/data/picsl/mackey_group/CBPD/bids_ppc_scripts/assign_fieldmaps
BIDS_DIR=/data/picsl/mackey_group/CBPD/test_bids/ #need a trailing /

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
    python ${SCRIPTS_DIR}/assign_fieldmaps_to_IntendedFor_field.py ${sub} ${ses} ${BIDS_DIR}
    done
done
