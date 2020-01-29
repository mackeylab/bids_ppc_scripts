# BIDS Preprocessing Pipeline

This repo contains scripts for minimal containerized preprocessing for Mackey Lab child data in BIDS. These scripts using *containers*, which you can learn more about [here](https://github.com/mackeylab/home/wiki/Singularity-containers). They operate in two chunks.

## First script
The first chunk is run by the `new_subj_first` script. This does the below:

- Convert to nifti format with [Heudiconv](https://heudiconv.readthedocs.io/en/latest/), put into `CBPD_bids` directory (see [here](https://github.com/mackeylab/bids_ppc_scripts/blob/master/heudiconv)).
- Fix TOPUP fieldmaps (see [here](https://github.com/mackeylab/bids_ppc_scripts/blob/master/fix_topup_sequences)).
- Assign `IntendedFor` field to TOPUP fieldmaps (see [here](https://github.com/mackeylab/bids_ppc_scripts/blob/master/assign_fieldmaps)).

Next, if a subject has fallen asleep or we need to discard some data, the BOLD niftis will be edited to reflect this after running the first chunk (x # of TRs removed), and subjects or runs that are bad will be added to the `.bidsignore` file for documentation for posterity.

**Note**: This includes extra T1s that we don't want to use, so that only the good T1s will be used for fMRIprep. However, there are two ongoing issues in fMRIprep development to both select T1s to use and not auto-merge them for Freesurfer, and use manually-edited brains, which may enable us to run Freesurfer within fMRIprep (see [here](https://github.com/poldracklab/smriprep/issues/104) and [here](https://github.com/poldracklab/fmriprep/issues/1769)).

Check the MRI protocol notes ([here](https://docs.google.com/spreadsheets/d/15D3aYw1m127c-BHkAAxGTNqqpewZirn1OTzHZomUpUU/edit#gid=0)) or CBPD Scanning Data ([here](https://docs.google.com/spreadsheets/d/1tEMxyA7doTrpNZVW6m5qZJJG_muINBZU7ryn1AGwQtI/edit#gid=0)) for whether a participant has fallen asleep, and at what time. If we didn't note when they fell asleep, put the whole run into `.bidsignore`. A script for discarding extra TRs is [here](https://github.com/mackeylab/bids_ppc_scripts/blob/master/fix_topup_sequences/README.md).

## Second script
The second chunk is run by `new_subj_second` script. This does the below:
- Run [MRIQC](https://mriqc.readthedocs.io/en/stable/) on that subject.
- Re-run MRIQC group output to auto-add new subjects as they come in.
- Run Freesurfer on that subject’s chosen T1 (*and T2?*), including hippocampal subfields, on the `CBPD_Scanning_Data` Google sheet (longitudinal subjects will be figured out for this, tbd).
- When Freesurfer is done, run fMRIprep, which will then run with precomputed Freesurfer inputs.

Then, someone should put their eyes on fMRIprep `.html` files for each subject run through this, and copy MRIQC outputs (including # of resting-state vols kept) into CBPD Scanning Data file.

There will also be a script to pull only a subset of the columns of MRIQC IQMs and aggregate them into a file to update the `CBPD_Scanning_Data` Google sheet with.

_Requirements_

Most scripts pull Singularity containers from their location in `/data/picsl/mackey_group/tools`, but you do need a few utilities accessible from your path. I recommend installing them all into a Conda environment. 

- Current version of dcm2niix :
	`conda install -c conda-forge dcm2niix` 
- Singularity accessible from your path :
	```
	#add to your ~/.bash_profile
	SINGULARITY_PATH=/share/apps/singularity/2.5.1/bin
	PATH=${SINGULARITY_PATH}:${PATH}
	```
- Python packages : `sys,json,bisect,glob,os,pybids,dateutil`
	```conda install -c aramislab pybids
	  conda install sys,json,bisect,glob,os,dateutil```

__Utilities__
- Copying over dicoms from rico, detecting which have changed in the last four days
- Backing up dicoms to the hard drive (plug in drive, put in IDs, and run the loop)
- Removing extra TRs for sleeping participants
- Fixing conflicting `StudyInstanceUID` (for re-registered participants)
