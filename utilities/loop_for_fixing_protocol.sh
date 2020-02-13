#!/bin/sh

# loop_for_fixing_protocol

dcm_dir=$1     # directory containing each subject's dicom folder
subs_fname=$2  # full path to text file that contains subject IDs and dicom numbers
new_name=$3    # new protocol name that you want in the header

for line in `cat $subs_fname`
  do IFS=, read sub dcm_num <<< $line
  python rename_protocol.py $dcm_dir $sub $dcm_num $new_name
done
