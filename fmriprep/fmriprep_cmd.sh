#$ -j y
#$ -l h_vmem=25.1G,s_vmem=25G
#$ -o /data/jux/mackey_group/Ursula/projects/in_progress/within_between_network_conn_CBPD/output/qsub_output
#$ -q himem.q,all.q,basic.q,gpu.q

MACKEY_HOME=/data/picsl/mackey_group
BIDS_folder=/data/picsl/mackey_group/BPD/CBPD_bids
working_dir=/data/jux/mackey_group/Ursula/projects/in_progress/within_between_network_conn_CBPD/data/fmriprep_working
subject=${1}
tools_dir=${MACKEY_HOME}/tools/singularity
output_dir=${BIDS_folder}/derivatives/

unset PYTHONPATH;
echo 'job is running'
singularity run --cleanenv -B ${BIDS_folder}:/mnt ${tools_dir}/fmriprep-1.2.6-1.simg \
/mnt/ /mnt/derivatives \
participant \
-w /tmp/utooley${subject} \
--participant-label ${subject} \
--fs-license-file $HOME/license.txt \
--use-aroma \
--output-space T1w template fsaverage5 \
--cifti-output \
--nthreads 1 \


#--skip-bids-validation \
#--templace-resampling-grid native \
#must bind to a folder that already exists in the container, and must point to data dir not subject dir
