set -euo pipefail
#$ -j y
#$ -l h_vmem=10.1G,s_vmem=10.0G
#$ -o /data/picsl/mackey_group/CBPD/output/qsub_output
#$ -q himem.q,all.q,basic.q,gpu.q

subID=${1}
dir=$(cut -d'/' -f 3- <<< ${2}) #take off the /data/ prefix
echo $dir

singularity run -B /data:/mnt --cleanenv /data/picsl/mackey_group/tools/singularity/heudiconv0.5.4.simg -d /mnt/picsl/mackey_group/BPD/dicoms/{subject}_2/*.dcm -o /mnt/${dir} -f /mnt/picsl/mackey_group/CBPD/bids_ppc_scripts/heudiconv/heuristic.py -s ${subID} --ses 02 -c dcm2niix -b --minmeta;
