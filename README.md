# BIDS Preprocessing Pipeline

This repo contains scripts for minimal preprocessing pipeline for Mackey Lab data in BIDS. These scripts operate in two chunks.

The first chunk is run by the `new_subj_first` script. This does the below:

- Convert to nifti, put into `CBPD_bids` directory.
- Fix TOPUP fieldmaps (see [here](https://github.com/mackeylab/bids_ppc_scripts/blob/master/fix_topup_sequences/README.md)).
- Assign `IntendedFor` field to TOPUP fieldmaps  (see [here](https://github.com/mackeylab/bids_ppc_scripts/blob/master/assign_fieldmaps/README.md)).

Next, if a subject has fallen asleep or we need to discard some data, the BOLD niftis will be edited to reflect this (x # of TRs removed), and subjects or runs that are bad will be added to the `.bidsignore` file for documentation for posterity. This includes extra T1s that we don't want to use, so that only the good T1s will be used for fmriprep. A script for discarding extra TRs is [here](https://github.com/mackeylab/bids_ppc_scripts/blob/master/fix_topup_sequences/README.md).

The second chunk is run by `new_subj_second` script. This does the below:
- Run MRIQC on that subject
- Re-run MRIQC group output to auto-add new subjs as they come in
- Run Freesurfer on that subject’s chosen T1 on the `CBPD_Scanning_Data` Google sheet (longitudinal subjects will be figured out for this, tbd).
- When freesurfer is done, start fMRIprep which will then run with precomputed Freesurfer inputs.

Then, someone should put their eyes on fmriprep `.html` files for each subject run through this, and copy MRIQC outputs including # of resting-state vols into CBPD Scanning Data file.

There will also be a script to pull only a subset of the columns of MRIQC IQMs and aggregate them into a file to update the `CBPD_Scanning_Data` Google sheet with.
