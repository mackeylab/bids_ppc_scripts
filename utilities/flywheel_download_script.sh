#This script is for downloading data from Flywheel (the unknown/Unsorted folder)
#to the cbpd_main_data project on CUBIC, and starting the dicom-to-nifti conversion.

sudo -u cbpdmaindata bash #log in to the cbpdmaindata project user

CBPD_DATA=/cbica/projects/cbpd_main_data/
SCRIPTS_DIR=/cbica/projects/cbpd_main_data/code/bids_ppc_scripts
APIKEY= #put your API Key from Flywheel here
SUBJECT_ID=CBPD0199_2

fw login $APIKEY

cd $CBPD_DATA/dicoms/
mkdir ${SUBJECT_ID}; cd ${SUBJECT_ID} #make a new subject folder

fw download unknown/Unsorted/${SUBJECT_ID}
#you will get prompted for the size being okay-yes/no? Hit yes!

tar -xvf ${SUBJECT_ID}.tar

#move all dicoms that aren't zipped up to the top level folder
mv unknown/Unsorted/${SUBJECT_ID}/**/*/*dcm .

#NOTE! If for some reason the subject was registered multiple times, there may be multiple folders under
# unknown/Unsorted/${SUBJECT_ID} that will need to be sorted through. If this is the case,
# it may be helpful to only mv and unzip the dicoms you want to use from the folders
# in the folder structure, and delete or hide the others from heudiconv.

# You can also investigate using --grouping all when converting using heudiconv

#this unzips all the dicom folders to the top-level subject folder in /dicoms, though they will still be nested.
find /cbica/projects/cbpd_main_data/dicoms/${SUBJECT_ID} -name "*.zip" | while read filename; do unzip -o -d "`basename -s .zip "$filename"`" "$filename"; done;

# Lourdes' update 23-mar-2022
# this unzips all the dicom folders to the top-level subject folder in /dicoms, though they will still be nested and
# now it names the folder according to the name of the sequence (taken from the folder where the dicom is sitting at)
find /cbica/projects/cbpd_main_data/dicoms/${SUBJECT_ID} -name "*.zip" | while read filename; do unzip -o -d "`basename -s .zip "$(dirname "$filename")"`" "$filename"; done;

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
