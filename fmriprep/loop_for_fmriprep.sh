set -euo pipefail
if [ $# -eq 0 ]; then
echo "USAGE: loop_for_fmriprep.sh <scanning_data_sheet> <full_path_to_BIDS_input_dir>

Example: loop_for_fmriprep.sh /cbica/projects/cbpd_main_data/bids_ppc_scripts/fmriprep/CBPD_Scanning_Data_MRI_Quality.csv
/cbica/projects/cbpd_main_data/CBPD_bids
This runs fMRIprep on all subjects and sessions in the scan data csv,
pulling from the BIDS input directory and using their pre-run Freesurfer, using only the
run of the T1w image that was used for Freesurfer (documented in the scan sheet)
as input to fMRIprep, by submitting separate jobs for each subject.
"
exit
fi

#PULL WHICH T1 TO USE FROM THE GOOGLE SHEET HERE:
# https://docs.google.com/spreadsheets/d/1tEMxyA7doTrpNZVW6m5qZJJG_muINBZU7ryn1AGwQtI/edit#gid=0
#There is a copy of this sheet saved in the bids_ppc_scripts/fmriprep folder on CUBIC,
# but it is not on Github

SCRIPTS_DIR=/cbica/projects/cbpd_main_data/code/bids_ppc_scripts
#subjectlist=${SCRIPTS_DIR}/fmriprep/CBPD_Scanning_Data_MRI_Quality.csv
subjectlist=${1}
BIDS_dir=$(cd ${2}; pwd)

for line in `cat $subjectlist | awk -F, '{print $1"|"$2}'`
do
  echo $line #parse the csv file into sessions and runs
  sub=$(echo $line| cut -d'|' -f1)
  if [[ $sub =~ "_" ]]; then
    echo It is longitudinal
    ses=0$(echo $sub| cut -d'_' -f2)
    echo $ses
  else
    echo It is not longitudinal
    ses=01
  fi
  T1=$(echo $line| cut -d'|' -f2)
  # echo $sub
  # echo $ses
  # echo $T1
  echo Running fMRIprep for ${sub} session ${ses}
  if [ -e ${BIDS_dir}/derivatives/fmriprep_t${ses:1}/fmriprep/sub-${sub}.html ]; then
  	echo 'fMRIprep is already run for sub' ${sub}
  else
  	echo 'Passing the T1' ${T1} 'to fMRIprep BIDS filter file'
  	cp ${BIDS_dir}/derivatives/fmriprep/ses-${ses}.json ${BIDS_dir}/derivatives/fmriprep/ses_${ses}_${sub}.json
  	jq -r --arg T1 "${T1:4}" '.t1w.run |= $T1' ${BIDS_dir}/derivatives/fmriprep/ses-${ses}.json > ${BIDS_dir}/derivatives/fmriprep/ses_${ses}_${sub}.json
  	#this uses jq to add the argument for the T1 run, then update the value for key
  	#run in the bids-filter-file json called ses-01.json
  	qsub ${SCRIPTS_DIR}/fmriprep/fmriprep_cmd_v20.2.0.sh ${sub} ${ses} ${BIDS_dir}
  fi
done