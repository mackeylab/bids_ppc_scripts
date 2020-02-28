
set -euo pipefail
if [ $# -eq 0 ]; then
echo "USAGE: loop_for_mriqc.sh <fd_threshold> <full_BIDS_input_dir>

Example: loop_for_mriqc.sh 1 /data/picsl/mackey_group/CBPD/CBPD_bids /derivatives/mriqc_fd_1_mm
This runs MRIQC with FD threshold 1 mm on all subjects and all sessions
in the BIDS input directory, by submitting separate jobs for each subject,
and outputs group results into
/data/picsl/mackey_group/<BIDS_input_dir>/derivatives/mriqc_fd_<threshold>_mm
"
exit
fi

threshold=${1}
BIDS_folder=${2}
SCRIPTS_DIR=/data/picsl/mackey_group/CBPD/bids_ppc_scripts

for sub in `find ${BIDS_folder} -maxdepth 1 -mindepth 1 -type d -name "sub-*" | sed -e 's|.*/||'`
do
echo $sub
sub=${sub:4}
for ses in ${BIDS_folder}/sub-${sub}/* #for each session
do
  ses=`basename ${ses}`
echo $ses
ses=${ses:4}
qsub ${SCRIPTS_DIR}/MRIQC/run_mriqc.sh ${threshold} ${sub} ${ses} ${BIDS_folder}
done
done
