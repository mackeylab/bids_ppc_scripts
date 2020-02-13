set -euo pipefail
#$ -j y
#$ -l h_vmem=10.1G,s_vmem=10.0G
#$ -o /data/picsl/mackey_group/CBPD/output/qsub_output
#$ -q himem.q,all.q,basic.q,gpu.q
if [ $# -eq 0 ]; then
echo "USAGE: heudiconv_cmd_longitud_T3.sh <sub_id> <BIDS_output_dir>

Example: heudiconv_cmd.sh CBPDxxx /data/picsl/mackey_group/BIDS/
This runs heudiconv for T3 subjects ONLY! You do not need the time suffix (_3)
For longitudinal T2 or baseline subjects, use the appropriate heudiconv_cmd_longitud_T2.sh
or heudiconv_cmd.sh
"
exit
fi

subID=${1}
dir=$(cut -d'/' -f 3- <<< ${2}) #take off the /data/ prefix
echo $dir

singularity run -B /data:/mnt --cleanenv /data/picsl/mackey_group/tools/singularity/heudiconv0.5.4.simg -d /mnt/picsl/mackey_group/BPD/dicoms/{subject}_3/*.dcm -o /mnt/${dir} -f /mnt/picsl/mackey_group/CBPD/bids_ppc_scripts/heudiconv/heuristic.py -s ${subID} --ses 03 -c dcm2niix -b --minmeta;
