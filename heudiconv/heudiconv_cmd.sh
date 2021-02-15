set -euo pipefail
#$ -j y
#$ -l h_vmem=10.1G,s_vmem=10.0G
#$ -o /cbica/projects/cbpd_main_data/output/qsub_output
#$ -q himem.q,all.q,basic.q,gpu.q
if [ $# -eq 0 ]; then
echo "USAGE: heudiconv_cmd.sh <sub_id> <BIDS_output_dir>

Example: heudiconv_cmd.sh CBPDxxx /cbica/projects/cbpd_main_data/CBPD_bids
This runs heudiconv for T1 subjects ONLY!
For longitudinal T2 or T3 subjects, use the appropriate heudiconv_cmd_longitud_T2.sh
or heudiconv_cmd_longitud_T3.sh
"
exit
fi

subID=${1}
#dir=$(cut -d'/' -f 3- <<< ${2}) #take off the /data/ prefix
echo $dir

singularity run -B ${SBIA_TMPDIR}:/tmp --cleanenv /cbica/projects/cbpd_main_data/tools/singularity/heudiconv0.5.4.simg -d /cbica/cbpd_main_data/dicoms/{subject}/*.dcm -o ${dir} -f /cbica/cbpd_main_data/code/bids_ppc_scripts/heudiconv/heuristic.py -s ${subID} --ses 01 -c dcm2niix -b --minmeta;

#to get dicom information
#singularity run -B /data:/mnt --cleanenv /data/picsl/mackey_group/tools/singularity/heudiconv0.5.4.simg -d /mnt/picsl/mackey_group/BPD/dicoms/{subject}/*.dcm -o /mnt/${dir} -f convertall -s ${subID} --ses 01 -c none -b --minmeta;
