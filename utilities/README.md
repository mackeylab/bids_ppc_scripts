
## Fixing study identifiers

If you get an error during dicom conversion about `Conflicting study identifiers found`. This typically occurs if a subject was registered twice, or taken out of the scanner and then put back in. Essentially, each time you register a subject, they get a new `StudyInstanceUID`, which messes up the conversion to nifti.

**Edit: With a new heudiconv version, we should be able to fix this with heudiconv(see [here](https://github.com/nipy/heudiconv/pull/359))**.
For subjects who have different `StudyInstanceUID`, we can run heudiconv using the flag `--grouping all` to assign all dicoms in a subject folder to that subject. UAT has not tested this but should just take a new heudiconv script for that subject.


## Fixing protocol name

Rewrites ProtocolName and SeriesDescription in the dicom header. Originally needed because when we first introduced the PIPER movie scan, we continued to use the "BOLD_resting1" protocol for a while - this makes it difficult to use the protocol name in heudiconv's heuristic file to differentiate between rest scans and PIPER movie scans.

Usage for running on one subject:

`python fix_dcmheader_protocol.py [dicom directory] [subject ID] [dicom number] [new name]`


`python fix_dcmheader_protocol.py /data/picsl/mackey_group/BPD/dicoms/ CBPD0183 17 BOLD_piper`

If looping through multiple subjects, run them through the `loop_for_fixing_protocol.sh`. Requires having a text file where each line contains the subject ID and the dicom number of the scan that you want to fix (separated by a comma, no spaces). See the `subs_to_rename_template.txt` if unsure.

`bash loop_for_fixing_protocol.sh [dicom directory] [full path to text file with sub IDs and dicom numbers] [new name]`
