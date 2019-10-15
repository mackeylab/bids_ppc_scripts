#!/bin/sh

#$ -cwd
#$ -V

set -euxo pipefail

if [ $# -eq 0 ]; then
echo "USAGE: syncing_dicoms_from_rico.sh

Must be logged in to the Rico computer.
This will change directories to the dicom export directory and then sync anything that matches our protocol number (825656) that was modified within the last 4 days."
exit
fi

cd /mnt/rtexport/RTexport_Current
for x in `find . -type d -name '*825656*' -ctime -4`
#for all directories in the folder that match and were modified in the last 4 days
do
echo ${x}
rsync -prltD --chmod=Dug+rwx,Dg+s,Fug+rw,o-rwx ${x} utooley@chead:/data/picsl/mackey_group/BPD/dicoms
#enter password here, I set up ssh keys from Rico to my cluster account to not do this.
done
