#!/bin/sh
#$ -cwd
#$ -V
#$ -j y
#$ -l h_vmem=10.1G,s_vmem=10.0G
#$ -o /data/picsl/mackey_group/CBPD/output/qsub_output
#$ -q himem.q,all.q,basic.q,gpu.q

set -euo pipefail
if [ $# -eq 0 ]; then
echo "USAGE: aggregate_group_mriqc.sh <fd_threshold> <bids_dir>

Example: run_mriqc.sh 2 /data/picsl/my_bids_dir
This aggregates group output for the MRIQC directory above for all participants
who have been run through MRIQC with a 2 mm FD threshold.
"
exit
fi

MACKEY_HOME=/data/picsl/mackey_group/
tools_dir=${MACKEY_HOME}/tools/singularity
threshold=${1}
BIDS_folder=${2}
output_dir=${BIDS_folder}/derivatives/mriqc_fd_${threshold}_mm

if [ ! -e ${output_dir} ]; then
  echo 'No one has been run through MRIQC with the threshold of' ${threshold}
  echo 'Does' ${output_dir} 'exist?'
  break
fi


unset PYTHONPATH;
singularity run --cleanenv -B ${BIDS_folder}:/mnt ${tools_dir}/mriqc-0.15.1.simg \
/mnt/ /mnt/derivatives/mriqc_fd_${threshold}_mm \
group \
-w ${TMP} \


#don't have the working dir be a mounted directory or you'll get errors in the logs about busy resources
#must bind to a folder that already exists in the container, and must point to data dir not subject dir
