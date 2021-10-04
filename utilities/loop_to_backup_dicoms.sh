#may need to run several times if the link to the cluster gets broken
#run from your local computer with the hard drive plugged in, will need to enter password each time
#You will need to change the username from TooleyU to your CUBIC username
set -euo pipefail

declare -a subs=(CBPD0091_3
CBPD0212_2
CBPD0209_2
CBPD0199_2
CBPD0182_2
CBPD0142_2
CBPD0163_2
CBPD0205_2
CBPD0141_2
CBPD0190_2
CBPD0184_2
CBPD0160_2)

for i in "${subs[@]}"
do
#longitudinal
rsync -prltD --chmod=Dug+rwx,Dg+s,Fug+rw,o-rwx Tooleyu@cubic-login.uphs.upenn.edu:/cbica/projects/cbpd_main_data/dicoms/${i} /Volumes/Mackey\ Dicoms/Child_Longitudinal_Dicoms/
#non-longitudinal
#rsync -prltD --chmod=Dug+rwx,Dg+s,Fug+rw,o-rwx Tooleyu@cubic-login.uphs.upenn.edu:/cbica/projects/cbpd_main_data/dicoms/${i} /Volumes/Mackey\ Dicoms/Child_Dicoms/
done
