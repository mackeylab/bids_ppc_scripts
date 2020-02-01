#/bin/bash
set -euo pipefail

# obtain scan and session labels
scans=/data/picsl/mackey_group/BPD/dicoms
SCRIPTS_DIR=/data/picsl/mackey_group/CBPD/bids_ppc_scripts/heudiconv
BIDS_dir=/data/picsl/mackey_group/CBPD/CBPD_bids

declare -a subs=(CBPD0195 CBPD0002_2 CBPD0037_2 CBPD0039_2 CBPD0085_2 CBPD0048_3 CBPD0074_3 CBPD0188)

cd $scans
#for sub in `find . -maxdepth 1 -mindepth 1 -type d -name "CBPD*" | sed -e 's|.*/||'`
#for only those in the last 10 days
#for sub in `find . -maxdepth 1 -mindepth 1 -type d -name "CBPD*" -ctime -10 | sed -e 's|.*/||'| sort`
for sub in "${subs[@]}"
do
echo $sub
sleep .5
if [[ $sub == *_2 ]]; then #the ID is longer than x digits and ends in _2, it's a longitudinal subject, then convert
   echo 'its longitudinal T2'
   sub=${sub:0:8}
   qsub ${SCRIPTS_DIR}/heudiconv_cmd_longitud_T2.sh ${sub} ${BIDS_dir}
 elif [[ $sub == *_3 ]]; then
   echo 'its longitudinal T3'
   sub=${sub:0:8}
   qsub ${SCRIPTS_DIR}/heudiconv_cmd_longitud_T3.sh ${sub} ${BIDS_dir}
 else
   echo 'its not longitudinal'
   qsub ${SCRIPTS_DIR}/heudiconv_cmd.sh ${sub} ${BIDS_dir}
fi
done