# #/bin/bash

## loop for fixing study identifiers when heudiconv breaks because of conflicting study identifiers###
###############################
SCRIPTS_DIR=/data/picsl/mackey_group/CBPD/bids_ppc_scripts/heudiconv/
#list of subjs to fix
declare -a arr=(CBPD0134)
cd /data/picsl/mackey_group/BPD/dicoms

## now loop through the above array
for i in "${arr[@]}"
do
   echo "$i"
   cd /data/picsl/mackey_group/BPD/dicoms/${i}
   python ${SCRIPTS_DIR}/fix_conflicting_study_identifiers.py
done
