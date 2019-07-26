# bids_ppc_scripts

This repo contains scripts for minimal preprocessing pipeline for Mackey Lab data in BIDS.

This script should:
Convert to nifti, put into `CBPD_bids` directory.
Run MRIQC on that subject
Re-run MRIQC group output to auto-add new subjs as they come in
Run freesurfer on that subject’s chosen T1 on the `CBPD_Scanning_Data` Google sheet (longitudinal subjects will be figured out, tbd).
When freesurfer is done, start fmriprep which will then run with precomputed freesurfer inputs.

Then, someone should put eyes on fmriprep `.html` files for each subject run through this, and copy MRIQC outputs including # of resting-state vols  into CBPD Scanning Data file.

There will also be a script to pull only a subset of the columns of MRIQC IQMs and aggregate them into a file to update the `CBPD_Scanning_Data` Google sheet with.
