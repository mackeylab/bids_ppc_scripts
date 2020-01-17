#!/bin/sh
set -euo pipefail #set this to kill the script if a variable is not found.

if [ $# -eq 0 ]; then
echo "USAGE: fix_all_topup_sequence.sh <bids-directory>
"
exit
fi

directory=$1

#this script goes through the BIDS directory and splits out just the b=0 volume from the TOPUP scan and the last volume from the DWI scan for use in TOPUP
for sub in `find ${directory} -maxdepth 1 -mindepth 1 -type d -name "sub-*" | sed -e 's|.*/||'`
do
  echo $sub
  for ses in $sub/* #for each session
  do
    echo $ses
cd ${sub}/${ses}
fieldmap_orig=fmap/${sub}_${ses}_run-01_epi.nii.gz #the original fieldmap
echo ${fieldmap_orig}
topup_jpos=fmap/${sub}_${ses}_dir-PA_run-01_epi.nii.gz
topup_jneg=fmap/${sub}_${ses}_dir-AP_run-01_epi.nii.gz
#the fieldmap is acquired in the j direction
3dcalc -a ${fieldmap_orig}[0] -expr '1*a' -prefix ${topup_jpos} #take only the first vol of TOPUP
mv fmap/${sub}_${ses}_run-01_epi.json fmap/${sub}_${ses}_dir-PA_epi.json #rename the TOPUP json
#the dwi scan is acquired in the -j direction, take the last scan of the dwi, which is b=0, before TOPUP
dwi=dwi/${sub}_${ses}_ses-01_run-01_dwi.nii.gz
3dcalc -a ${dwi}[$] -expr '1*a' -prefix ${topup_jneg} #take only the last vol of DWI
cp dwi/${sub}_${ses}_run-01_dwi.json fmap/${sub}_${ses}_dir-AP_epi.json #copy the dwi json

rm ${sub}*.bval
rm ${sub}*.bvec
rm ${fieldmap_orig}
cd ../../

done
done
