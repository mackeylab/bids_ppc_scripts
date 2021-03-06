#This script is for downloading data from Flywheel (the unknown/Unsorted folder)
#to the cbpd_main_data project on CUBIC, and starting the dicom-to-nifti conversion.

CBPD_DATA=/cbica/projects/cbpd_main_data/
SCRIPTS_DIR=/cbica/projects/cbpd_main_data/code/bids_ppc_scripts
APIKEY=upenn.flywheel.io:Rr13pKsGKxYkZ7W8Ux #put your API Key from Flywheel here
SUBJECT_ID=CBPD0212_2

sudo -u cbpdmaindata bash #log in to the cbpdmaindata project user

fw login $APIKEY

cd $CBPD_DATA/dicoms/
mkdir ${SUBJECT_ID}; cd ${SUBJECT_ID} #make a new subject folder

fw download unknown/Unsorted/${SUBJECT_ID}
#you will get prompted for the size being okay-yes/no? Hit yes!

tar -xvf ${SUBJECT_ID}.tar

#move all dicoms that aren't zipped up to the top level folder
mv unknown/Unsorted/${SUBJECT_ID}/**/*/*dcm .

#this unzips all the dicom folders to the top-level subject folder in /dicoms, though they will still be nested.
find /cbica/projects/cbpd_main_data/dicoms/${SUBJECT_ID} -name "*.zip" | while read filename; do unzip -o -d "`basename -s .zip "$filename"`" "$filename"; done;

#run the first processing script to convert the dicoms to nifti!

qsub ${SCRIPTS_DIR}/new_subj_first.sh ${SUBJECT_ID} /cbica/projects/cbpd_main_data/CBPD_bids

# Remember to record in CBPD Scanning Data google sheet that you have copied the dicoms over,
# and any notes on quality or issues.
# Make sure you got all the kids that have been scanned off of Flywheel!
# Remember, data will be deleted so we must get everyone!

# Then, check that the expected nifti files for each sequence (T1w, T2w, rest, etc.)
# are in the CBPD_bids folder for this subject.
# If dicoms are not being converted properly with heudiconv to nifti format,
# check the heuristic is up-to-date for any new sequences that have been added
# for HBCD or otherwise (bids_ppc_scripts/heudiconv/heuristic.py)
