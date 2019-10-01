#!/bin/sh

#$ -cwd
#$ -V

if [ $# -eq 0 ]; then
echo "Usage: remove_TRs.sh <sub_id> <ses> <scan> <num of TRS to remove> \n
Example: remove_TRs.sh CBPDxxx xxx 16"
exit
fi

sub=${1}
ses=${2}
scan=${3}
num=${4}

3dCalc xxxx from before

dataleft=`mriinfo TRs `

echo `you have ${dataleft} TRs x 2 s left for ${sub}`
