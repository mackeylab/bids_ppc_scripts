#!/bin/sh
#$ -j y
#$ -l h_vmem=19.1G,s_vmem=19.0G
#$ -o /data/picsl/mackey_group/CBPD/output/qsub_output
#$ -q himem.q,all.q,basic.q,gpu.q

unset PYTHONPATH;
sub=${1} #CBPDxxxx
ses=${2} #01
BIDS_folder=${3}
# sub=CBPD0162
# ses=02
# BIDS_folder=/data/picsl/mackey_group/CBPD/CBPD_bids/
tools_dir=/data/picsl/mackey_group/tools/singularity
output_dir=${BIDS_folder}/derivatives/
wd_dir=$( echo ${BIDS_folder}| cut -d "/" -f -5) #remove this after testing
echo ${wd_dir}
echo ${sub}
echo ${BIDS_folder}
user=`whoami` #so that templateflow can go into the home dir of whoever is running.

# ${tools_dir}/fmriprep-1.2.6-1.simg use this when running ABCD
export SINGULARITYENV_TEMPLATEFLOW_HOME=/home/${user}/templateflow
singularity run --cleanenv -B /home/${user}/templateflow:/home/${user}/templateflow,${BIDS_folder}:/mnt,${wd_dir}:/tmp ${tools_dir}/fmriprep-20-0-2.simg \
/mnt/ /mnt/derivatives/fmriprep_t${ses:1} participant \
--participant-label ${sub} \
--fs-license-file $HOME/license.txt \
--fs-subjects-dir /mnt/derivatives/freesurfer_t${ses:1} \
--bids-filter-file /mnt/derivatives/fmriprep/ses-${ses}.json \
--skull-strip-template MNIPediatricAsym:res-1:cohort-2 \
--output-spaces MNI152NLin6Asym T1w MNIPediatricAsym:res-1:cohort-2 \
--ignore sbref \
-w $TMPDIR \

#--fs-subjects_dir #set this to different timepoints to run subjects as different people!
#ignore sbref in newer sequences since we didn't used to save it before.
# we are doing slice-timing correction here.
#fsaverage:den-10k is fsaverage5
#--output-space MNI152NLin6Asym T1w fsnative fsaverage:den-10k \
