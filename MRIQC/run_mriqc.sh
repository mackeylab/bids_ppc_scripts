#!/bin/sh
#$ -j y
#$ -l h_vmem=10.1G,s_vmem=10.0G
#$ -o /data/picsl/mackey_group/CBPD/output/qsub_output
#$ -q himem.q,all.q,basic.q,gpu.q

set -euo pipefail
if [ $# -eq 0 ]; then
echo "USAGE: run_mriqc.sh <fd_threshold> <subj_id> <session> <bids_dir>

Example: run_mriqc.sh 1 CBPDxxxx 02 /data/picsl/my_bids_dir
This runs MRIQC with FD threshold of 1 mm on session 02 of subject CBPDxxxx,
in the BIDS input directory, and outputs group results
into the /data/picsl/my_bids_dir/derivatives/mriqc_fd_<threshold>_mm
"
exit
fi
MACKEY_HOME=/data/picsl/mackey_group/
tools_dir=${MACKEY_HOME}/tools/singularity
threshold=${1}
subject=${2}
ses=${3}
BIDS_folder=$(readlink -f $4)
output_dir=${BIDS_folder}/derivatives/mriqc_fd_${threshold}_mm
user=`whoami`

unset PYTHONPATH;
export SINGULARITYENV_TEMPLATEFLOW_HOME=/home/${user}/templateflow
singularity run --cleanenv -B /home/${user}/templateflow:/home/${user}/templateflow,${BIDS_folder}:/mnt ${tools_dir}/mriqc-0.15.1.simg \
/mnt/ /mnt/derivatives/mriqc_fd_${threshold}_mm \
participant \
-w /tmp \
--participant_label ${subject} \
--session-id ${ses} \
--fd_thres ${threshold} \
--no-sub \
--n_procs 10 \

#must bind to a folder that already exists in the container, and must point to data dir not subject dir
