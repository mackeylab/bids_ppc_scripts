#!/bin/sh
#$ -j y
#$ -l h_vmem=19.1G,s_vmem=19.0G
#$ -o /data/picsl/mackey_group/CBPD/output/qsub_output
#$ -q himem.q,all.q,basic.q,gpu.q

unset PYTHONPATH;
sub=${1} #CBPDxxxx
ses=${2} #01
BIDS_folder=${3}
tools_dir=/data/picsl/mackey_group/tools/singularity
output_dir=${BIDS_folder}/derivatives/
echo ${sub}
echo ${BIDS_folder}
user=`whoami` #so that templateflow can go into the home dir of whoever is running.
#echo 'hello'

# ${tools_dir}/fmriprep-1.2.6-1.simg use this when running ABCD
export SINGULARITYENV_TEMPLATEFLOW_HOME=/home/${user}/templateflow
singularity run --cleanenv -B /home/${user}/templateflow:/home/${user}/templateflow,${BIDS_folder}:/mnt ${tools_dir}/fmriprep-20-0-1.simg \
/mnt/ /mnt/derivatives/ participant \
--participant-label ${sub} \
--fs-license-file $HOME/license.txt \
--fs-subjects-dir ${BIDS_folder}/derivatives/freesurfer \
--bids-filter-file ${location_of_filter_file}/ses-${ses}.json \
--output-spaces MNI152NLin6Asym T1w \
--ignore slicetiming sbref \ #ignore sbref in newer sequences since we didn't used to save it.
-w $TMPDIR \

#fsaverage:den-10k is fsaverage5
#--output-space MNI152NLin6Asym T1w fsnative fsaverage:den-10k \
