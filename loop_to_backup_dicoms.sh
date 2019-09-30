#may need to run several times if the link to the cluster gets broken
#run from your local computer with the hard drive plugged in, will need to enter password each time

declare -a subs=(CBPD0085_2 CBPD0048_@)

for i in "${subs[@]}"
do
#longitudinal
rsync -prltD --chmod=Dug+rwx,Dg+s,Fug+rw,o-rwx utooley@chead:/data/picsl/mackey_group/BPD/dicoms/${i} /Volumes/Mackey\ Dicoms/Child_Longitudinal_Dicoms/
#non-longitudinal
#rsync -prltD --chmod=Dug+rwx,Dg+s,Fug+rw,o-rwx utooley@chead:/data/picsl/mackey_group/BPD/dicoms/${i} /Volumes/Mackey\ Dicoms/Child_Dicoms/
done
