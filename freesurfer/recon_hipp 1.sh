#!/bin/sh

#$ -cwd
#$ -V
#$ -l h_vmem=20.1G,s_vmem=20G
#$ -q himem.q

set -euo pipefail

if [ $# -eq 0 ]; then
echo "Usage: recon_hipp.sh <sub_id>"
exit
fi

SUB=$1

recon-all -s ${SUB} -hippocampal-subfields-T1
