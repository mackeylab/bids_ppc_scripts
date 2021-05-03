#!/bin/sh
#$ -cwd
#$ -V
#$ -j y
#$ -l h_vmem=10.1G,s_vmem=10.0G
#$ -o /cbica/projects/cbpd_main_data/qsub_output

set -euo pipefail
if [ $# -eq 0 ]; then
echo "USAGE: aggregate_group_mriqc.sh <fd_threshold> <bids_dir>

Example: run_mriqc.sh 2 /cbica/projects/cbpd_main_data/CBPD_bids
This aggregates group output for the MRIQC directory above for all participants
who have been run through MRIQC with a 2 mm FD threshold.
"
exit
fi

MACKEY_HOME=/cbica/projects/cbpd_main_data
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
SINGULARITY_TMPDIR=/scratch/cbpdmaindata; export SINGULARITY_TMPDIR #make sure it mounts this as /tmp inside the container
singularity run --cleanenv ${tools_dir}/mriqc-0.15.1.simg \
${BIDS_folder}/ ${output_dir} \
group \
-w /tmp/cbpdmaindata/ \


#don't have the working dir be a mounted directory or you'll get errors in the logs about busy resources
#must bind to a folder that already exists in the container, and must point to data dir not subject dir
