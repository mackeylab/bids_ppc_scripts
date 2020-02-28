#!/bin/sh
set -euo pipefail #set this to kill the script if a variable is not found.

if [ $# -eq 0 ]; then
echo "USAGE: fix_all_topup_sequence.sh <bids-directory>

This goes through the converted niftis in <bids-directory> for all subjects and
sessions,and splits out just the b=0 volume from the TOPUP fieldmap
scan and the last volume from the DWI scan for use in eventual distortion
correction with TOPUP.

See https://github.com/mackeylab/bids_ppc_scripts/tree/master/fix_topup_sequences
"
exit
fi

BIDS_dir=$(readlink -f $1) #resolve relative paths, make them absolute
echo $BIDS_dir

for sub in `find ${BIDS_dir} -maxdepth 1 -mindepth 1 -type d -name "sub-*" | sed -e 's|.*/||'`
do
  echo $sub
  for ses in ${BIDS_dir}/${sub}/* #for each session
  do
    echo $ses
    ses=`basename ${ses}` #take only the dirname
    #cd ${BIDS_dir}/${sub}/${ses}
    fieldmap_orig=${BIDS_dir}/${sub}/${ses}/fmap/${sub}_${ses}_run-01_epi.nii.gz #the original fieldmap
    echo ${fieldmap_orig}
    topup_jpos=${BIDS_dir}/${sub}/${ses}/fmap/${sub}_${ses}_acq-dwi_dir-PA_run-01_epi.nii.gz
    topup_jneg=${BIDS_dir}/${sub}/${ses}/fmap/${sub}_${ses}_acq-dwi_dir-AP_run-01_epi.nii.gz
    #the fieldmap is acquired in the j direction
    if [ -e ${topup_jpos} ]; then
      echo 'files exist already' #we already fixed the files
    elif 3dcalc -a ${fieldmap_orig}[0] -expr '1*a' -prefix ${topup_jpos} ; then  #take only the first vol of TOPUP scan
      mv ${BIDS_dir}/${sub}/${ses}/fmap/${sub}_${ses}_run-01_epi.json ${BIDS_dir}/${sub}/${ses}/fmap/${sub}_${ses}_acq-dwi_dir-PA_epi.json #rename the TOPUP json
      #the dwi scan is acquired in the -j direction, take the last scan of the dwi, which is b=0, before TOPUP
      dwi=${BIDS_dir}/${sub}/${ses}/dwi/${sub}_${ses}_run-01_dwi.nii.gz
      3dcalc -a ${dwi}[$] -expr '1*a' -prefix ${topup_jneg} #take only the last vol of DWI
      cp ${BIDS_dir}/${sub}/${ses}/dwi/${sub}_${ses}_run-01_dwi.json ${BIDS_dir}/${sub}/${ses}/fmap/${sub}_${ses}_acq-dwi_dir-AP_epi.json #copy the dwi json
      if [ ! -w "${BIDS_dir}/${sub}/${ses}/fmap/${sub}_${ses}_acq-dwi_dir-PA_epi.json" ] #if file is not writable then
      then
        echo 'file is not writable'
        chmod 775 ${BIDS_dir}/${sub}/${ses}/fmap/* #change the permissions so you can write into the .json files later
      else
        echo 'file is writable'
      fi

      rm ${BIDS_dir}/${sub}/${ses}/fmap/${sub}*.bval
      rm ${BIDS_dir}/${sub}/${ses}/fmap/${sub}*.bvec
      rm ${fieldmap_orig}
    else
      echo ${sub} ${ses} 'could not fix TOPUP sequences'
    #cd ../../
  fi

done
done
