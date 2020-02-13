#!/bin/sh
#$ -j y
#$ -l h_vmem=10.1G,s_vmem=10.0G
#$ -o /data/picsl/mackey_group/CBPD/output/qsub_output
#$ -q himem.q,all.q,basic.q,gpu.q

set -euo pipefail
if [ $# -eq 0 ]; then
echo "USAGE: run_mriqc.sh <subj_id> <session> <bids_dir>

Example: run_mriqc.sh CBPDxxxx 02 /data/picsl/my_bids_dir
This runs MRIQC on session 02 of subject CBPDxxxx in the BIDS input directory, and outputs group results
into the /data/picsl/my_bids_dir/derivatives/mriqc_fd_1_mm
"
exit
fi
MACKEY_HOME=/data/picsl/mackey_group/
tools_dir=${MACKEY_HOME}/tools/singularity
subject=${1}
ses=${2}
BIDS_folder=${3}
output_dir=${BIDS_folder}/derivatives/mriqc_fd_1_mm

unset PYTHONPATH;
singularity run --cleanenv -B ${BIDS_folder}:/mnt ${tools_dir}/mriqc-0.15.1.simg \
/mnt/ /mnt/derivatives/mriqc_fd_1_mm \
participant \
-w /tmp \
--participant_label ${subject} \
--session-id ${ses} \
--fd_thres 1 \
--no-sub \
--n_procs 10 \

#must bind to a folder that already exists in the container, and must point to data dir not subject dir

#MRIQC group command

MACKEY_HOME=/data/picsl/mackey_group/
#BIDS_folder=/data/picsl/mackey_group/BPD/niftis
BIDS_folder=/data/picsl/mackey_group/BPD/CBPD_bids
tools_dir=${MACKEY_HOME}/tools/singularity
output_dir=${BIDS_folder}/derivatives/mriqc_fd_.5_mm

unset PYTHONPATH;
singularity run --cleanenv -B ${BIDS_folder}:/mnt ${tools_dir}/mriqc-0.14.2.simg \
/mnt/ /mnt/derivatives/mriqc_fd_.5_mm \
group \
-w ${TMP} \


#don't have the working dir be a mounted directory or you'll get errors in the logs about busy resources
#must bind to a folder that already exists in the container, and must point to data dir not subject dir
