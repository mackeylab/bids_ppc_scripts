#!/bin/sh
#$ -j y
#$ -l h_vmem=40.1G,s_vmem=40.0G
#$ -o /data/picsl/mackey_group/CBPD/output/qsub_output
#$ -q himem.q,all.q,basic.q,gpu.q

set -euo pipefail
if [ $# -eq 0 ]; then
echo "USAGE: run_mriqc_for_all_subjs.sh <full-BIDS_input_dir> <output_dir_suffix>

Example: run_mriqc_for_all_subjs.sh /data/picsl/mackey_group/CBPD/CBPD_bids /derivatives/mriqc_fd_1_mm
This runs MRIQC on all subjects in the BIDS input directory, and outputs group results
into the /data/picsl/mackey_group/CBPD/CBPD_bids/derivatives/mriqc_fd_1_mm

NOTE: THIS WILL BE QUITE SLOW!
"
exit
fi

BIDS_folder=$(cd $1 ; pwd) # why is this not working?
MACKEY_HOME=/data/picsl/mackey_group/
tools_dir=${MACKEY_HOME}/tools/singularity
user=`whoami` #so that templateflow can go into the home dir of whoever is running.
output_dir=${BIDS_folder}/derivatives/mriqc_fd_1_mm
echo ${BIDS_folder}

unset PYTHONPATH;
export SINGULARITYENV_TEMPLATEFLOW_HOME=/home/${user}/templateflow
singularity run --cleanenv -B /home/${user}/templateflow:/home/${user}/templateflow,${BIDS_folder}:/mnt ${tools_dir}/mriqc-0.15.1.simg \
/mnt/ /mnt/derivatives/mriqc_fd_1_mm participant -w /tmp --fd_thres 1 --n_procs 10 \
