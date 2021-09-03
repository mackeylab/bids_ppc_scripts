#!/bin/sh
#$ -j y
#$ -l h_vmem=25.1G,s_vmem=25.0G
#$ -o /cbica/projects/cbpd_main_data/qsub_output

sub=${1} #CBPD0007
ses=${2} #01
BIDS_folder=${3} #/cbica/projects/cbpd_main_data/CBPD/CBPD_bids/

# sub=CBPD0077
# ses=03
# BIDS_folder=/cbica/projects/cbpd_main_data/CBPD_bids/

tools_dir=/cbica/projects/cbpd_main_data/tools/singularity
output_dir=${BIDS_folder}/derivatives/
echo ${sub}

user=`whoami` #so that templateflow can go into the home dir of whoever is running.

#may need to limit openblas threads like for heudiconv!
unset PYTHONPATH;
SINGULARITY_TMPDIR=$CBICA_TMPDIR #make sure it mounts this as /tmp inside the container
export SINGULARITY_TMPDIR
echo $CBICA_TMPDIR
export SINGULARITYENV_OPENBLAS_NUM_THREADS=8;export SINGULARITYENV_OMP_NUM_THREADS=8;
singularity run --cleanenv -B ${SINGULARITY_TMPDIR}:/tmp ${tools_dir}/fmriprep-20-2-0.sif \
${BIDS_folder} ${BIDS_folder}/derivatives/fmriprep_t${ses:1} participant \
--participant-label ${sub} \
--fs-license-file $HOME/license.txt \
--fs-subjects-dir ${BIDS_folder}/derivatives/freesurfer_t${ses:1} \
--bids-filter-file ${BIDS_folder}/derivatives/fmriprep/ses_${ses}_${sub}.json \
--skull-strip-template MNIPediatricAsym:res-1:cohort-2 \
--output-spaces MNI152NLin6Asym T1w MNIPediatricAsym:res-1:cohort-2 \
--ignore sbref \
--nthreads 8 \
-w /tmp \

#--fs-subjects_dir #set this to different timepoints to run subjects as different people!
#ignore sbref in newer sequences since we didn't used to save it before.
# we are doing slice-timing correction here.
#fsaverage:den-10k is fsaverage5
#--output-space MNI152NLin6Asym T1w fsnative fsaverage:den-10k \
