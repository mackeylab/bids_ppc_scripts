#!/bin/sh
#$ -cwd
#$ -V

if [ $# -eq 0 ]; then
echo "USAGE: new_subj_first.sh <sub_id> <ses>

Example: new_subj_first.sh CBPDxxx xxx
This runs heudiconv, fixes the blip-up blip-down sequences, and assigns the IntendedFor field to the fieldmaps.
After this is run, check for any runs that need to be .bidsignored, and any sleep during resting-state."
exit
fi

${sub}=${1} #CBPDxxxx
${ses}=${2} #01,02,03

######
###convert using heudiconv###
######

echo Doing Heudiconv conversion for ${sub}

#do Heudiconv

echo Finished heudiconv conversion for ${sub}


######
###Fix TOPUP scans###
######

echo Fixing TOPUP scan for ${sub}

#do it

echo Finished fixing TOPUP scan for ${sub}

######
###Assign Intended For field to fieldmaps###
######

echo Assigning Intended For field for ${sub}

python assign_fieldmaps_to_IntendedFor_field.py ${sub} ${ses}

echo Finished assigning Intended For field for ${sub}

echo Now check whether you need to remove some TRs for sleeping, or whether we should add some scans to the .bidsignore file.
