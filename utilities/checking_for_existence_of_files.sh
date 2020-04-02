#Checking for completeness in CBPD_bids
#run in BPD/dicoms directory
for sub in `find . -maxdepth 1 -mindepth 1 -type d -name "CBPD*" | sed -e 's|.*/||'`
do
echo $sub
if [ -d /data/picsl/mackey_group/CBPD/CBPD_bids/sub-${sub} ]; then
  echo 'it exists'
  else
  echo $sub 'does not exist'
  fi
done

#for longitudinal subjects
for sub in `find . -maxdepth 1 -mindepth 1 -type d -name "CBPD*_3" | sed -e 's|.*/||'`
do
echo $sub
if [ -d /data/picsl/mackey_group/CBPD/CBPD_bids/sub-${sub:0:8}/ses-03 ]; then
  echo 'it exists'
  else
  echo $sub 'does not exist'
  fi
done

#Checking for completeness in CBPD_bids/derivatives/freesurfer
#run in BPD/surfaces directory
for sub in `find . -maxdepth 1 -mindepth 1 -type d -name "CBPD*_3" | sed -e 's|.*/||'`
do
echo $sub
if [ -d /data/picsl/mackey_group/CBPD/CBPD_bids/derivatives/freesurfer_t3/sub-${sub:0:8} ]; then
  echo 'it exists'
  else
  echo $sub 'does not exist'
  fi
done

declare -a subs=(CBPD0191
CBPD0192
CBPD0193
CBPD0194
CBPD0195
CBPD0196
CBPD0197
CBPD0198)

for sub in "${subs[@]}"
do
mv ${sub} sub-${sub}
#cp ${sub} /data/picsl/mackey_group/CBPD/CBPD_bids/derivatives/freesurfer_t1/ -R
done
