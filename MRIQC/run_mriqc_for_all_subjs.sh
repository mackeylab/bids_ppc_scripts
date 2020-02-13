#!/bin/sh
#$ -j y
#$ -l h_vmem=40.1G,s_vmem=40.0G
#$ -o /data/picsl/mackey_group/CBPD/output/qsub_output
#$ -q himem.q,all.q,basic.q,gpu.q

set -euo pipefail
if [ $# -eq 0 ]; then
echo "USAGE: run_mriqc_for_all_subjs.sh <BIDS_input_dir> <output_dir_suffix>

Example: run_mriqc_for_all_subjs.sh /data/picsl/mackey_group/CBPD/CBPD_bids /derivatives/mriqc_fd_1_mm
This runs MRIQC on all subjects in the BIDS input directory, and outputs group results
into the /data/picsl/mackey_group/CBPD/CBPD_bids/derivatives/mriqc_fd_1_mm
"
exit
fi

MACKEY_HOME=/data/picsl/mackey_group/
tools_dir=${MACKEY_HOME}/tools/singularity
BIDS_folder=${1}
output_dir=${BIDS_folder}/derivatives/mriqc_fd_1_mm

unset PYTHONPATH;
singularity run --cleanenv -B ${BIDS_folder}:/mnt ${tools_dir}/mriqc-0.14.2.simg \
/mnt/ /mnt/derivatives/mriqc_fd_1_mm participant \
