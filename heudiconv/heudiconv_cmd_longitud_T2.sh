set -euo pipefail
#$ -j y
#$ -l h_vmem=10.1G,s_vmem=10.0G
#$ -o /cbica/projects/cbpd_main_data/qsub_output
#$ -q himem.q,all.q,basic.q,gpu.q

if [ $# -eq 0 ]; then
echo "USAGE: heudiconv_cmd_longitud_T2.sh <sub_id> <BIDS_output_dir>

Example: heudiconv_cmd_longitud_T2.sh CBPDxxx /cbica/projects/cbpd_main_data/CBPD_bids
This runs heudiconv for T2 subjects ONLY! You do not need the time suffix (_2).
For longitudinal T3 or baseline subjects, use the appropriate heudiconv_cmd_longitud_T3.sh
or heudiconv_cmd.sh
"
exit
fi

subID=${1}
#dir=$(cut -d'/' -f 3- <<< ${2}) #take off the /data/ prefix
dir=${2}
echo $dir

singularity run --cleanenv --env OPENBLAS_NUM_THREADS=4,OMP_NUM_THREADS=4 /cbica/projects/cbpd_main_data/tools/singularity/heudiconv.0.9.0.simg --files /cbica/projects/cbpd_main_data/dicoms/${subID}_2/** -o ${dir} -f /cbica/projects/cbpd_main_data/code/bids_ppc_scripts/heudiconv/heuristic.py -s ${subID} --ses 02 -c dcm2niix -b --minmeta;

#old conversion using -d and -s
#singularity run --cleanenv --env OPENBLAS_NUM_THREADS=4,OMP_NUM_THREADS=4 /cbica/projects/cbpd_main_data/tools/singularity/heudiconv0.5.4.simg -d /cbica/projects/cbpd_main_data/dicoms/{subject}_2/*.dcm -o ${dir} -f /cbica/projects/cbpd_main_data/code/bids_ppc_scripts/heudiconv/heuristic.py -s ${subID} --ses 02 -c dcm2niix -b --minmeta;
