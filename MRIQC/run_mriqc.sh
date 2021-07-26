#!/bin/sh
#$ -cwd
#$ -V
#$ -j y
#$ -l h_vmem=15.1G,s_vmem=15.0G
#$ -o /cbica/projects/cbpd_main_data/qsub_output

set -euo pipefail
if [ $# -eq 0 ]; then
echo "USAGE: run_mriqc.sh <fd_threshold> <subj_id> <session> <full_bids_dir>

Example: run_mriqc.sh 1 CBPDxxxx 02 /cbica/projects/cbpd_main_data/my_bids_dir
This runs MRIQC with FD threshold of 1 mm on session 02 of subject CBPDxxxx,
in the BIDS input directory, and outputs group results
into the /cbica/projects/cbpd_main_data/my_bids_dir/derivatives/mriqc_fd_<threshold>_mm
"
exit
fi
echo ${1} ${2} ${3} ${4}
MACKEY_HOME=/cbica/projects/cbpd_main_data/
tools_dir=${MACKEY_HOME}/tools/singularity
threshold=${1}
subject=${2}
ses=${3}
BIDS_folder=${4}
echo $BIDS_folder
output_dir=${BIDS_folder}/derivatives/mriqc_fd_${threshold}_mm
user=`whoami`

unset PYTHONPATH;
#may need to limit openblas threads like for heudiconv!
SINGULARITY_TMPDIR=$CBICA_TMPDIR #make sure it mounts this as /tmp inside the container
export SINGULARITY_TMPDIR
singularity run --cleanenv -B ${SINGULARITY_TMPDIR}:/tmp ${tools_dir}/mriqc-0.15.1.simg \
${BIDS_folder} ${output_dir} \
participant \
-w /tmp \
--participant_label ${subject} \
--session-id ${ses} \
--fd_thres ${threshold} \
--no-sub \
--n_procs 10 \

# export SINGULARITYENV_TEMPLATEFLOW_HOME=/cbica/home/${user}/templateflow
# singularity run --cleanenv -B /cbica/home/${user}/templateflow:/cbica/home/${user}/templateflow,${BIDS_folder}:/mnt ${tools_dir}/mriqc-0.15.1.simg \
# /mnt/ /mnt/derivatives/mriqc_fd_${threshold}_mm \
# participant \
# -w $TMPDIR \
# --participant_label ${subject} \
# --session-id ${ses} \
# --fd_thres ${threshold} \
# --no-sub \
# --n_procs 10 \

#must bind to a folder that already exists in the container, and must point to data dir not subject dir
