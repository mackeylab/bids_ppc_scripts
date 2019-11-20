#!/bin/sh
#$ -cwd
#$ -V
set -euo pipefail

if [ $# -eq 0 ]; then
echo "USAGE: new_subj_second.sh <sub_id> <ses> <T1 for freesurfer> <T2 for freesurfer>

Example: new_subj_second.sh CBPDxxx xxx
This runs MRIQC on this subject, and adds their quality metrics to the MRIQC group output.
Then, it runs Freesurfer using the selected T1 and T2, including hippocampal subfields.
Finally, it start fMRIprep running, which should detect precomputed freesurfer inputs."
exit
fi

${sub}=${1} #CBPDxxxx
${ses}=${2} #01,02,03

######
###Run MRIQC###
######

echo Running MRIQC for ${sub}

#do Heudiconv

echo Finished MRIQC for ${sub}


######
###Collate MRIQC group output again###
######

echo Adding ${sub} to MRIQC group files

#do it

echo Finished adding ${sub} to MRIQC group files

######
###Run Freesurfer with hippocampal subfields, selected T1###
######

#this may change to use both the T1 and T2? Probably this should be the default.
echo Running Freesurfer with hipp subfields for ${sub}

#do it

echo Finished running Freesurfer with hipp subfields for ${sub}

######
###Run fMRIprep###
######

#with precomputed Freesurfer
#we may in the future be able to select which T1 and T2 get fed to fmriprep, without having to .bidsignore them
#also testing using our fieldmaps for distortion correction of EPIs and not just DWIs
echo Running fMRIprep for ${sub}

#do it

echo Finished running fMRIprep for ${sub}
