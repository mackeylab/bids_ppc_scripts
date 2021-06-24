#may need to run several times if the link to the cluster gets broken
#run from your local computer with the hard drive plugged in, will need to enter password each time
#You will need to change the username from TooleyU to your CUBIC username
set -euo pipefail

declare -a subs=(CBPD0162_2)

for i in "${subs[@]}"
do
#longitudinal
rsync -prltD --chmod=Dug+rwx,Dg+s,Fug+rw,o-rwx Tooleyu@cubic-login.uphs.upenn.edu:/cbica/projects/cbpd_main_data/dicoms/${i} /Volumes/Mackey\ Dicoms/Child_Longitudinal_Dicoms/
#non-longitudinal
#rsync -prltD --chmod=Dug+rwx,Dg+s,Fug+rw,o-rwx Tooleyu@cubic-login.uphs.upenn.edu:/cbica/projects/cbpd_main_data/dicoms/${i} /Volumes/Mackey\ Dicoms/Child_Dicoms/
done
