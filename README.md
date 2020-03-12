# BIDS Preprocessing Pipeline

This repo contains scripts for minimal containerized preprocessing for Mackey Lab child data in BIDS. These scripts using *containers*, which you can learn more about [here](https://github.com/mackeylab/home/wiki/Singularity-containers), and work on our longitudinal data. They operate in two chunks.

## First script
The first chunk is run by the `new_subj_first` script. This does the below:

- Convert to nifti format with [Heudiconv](https://heudiconv.readthedocs.io/en/latest/), put into `CBPD_bids` directory (see [here](https://github.com/mackeylab/bids_ppc_scripts/blob/master/heudiconv)).
- Fix TOPUP fieldmaps for diffusion (see [here](https://github.com/mackeylab/bids_ppc_scripts/blob/master/fix_topup_sequences)).
- Assign `IntendedFor` field to TOPUP fieldmaps (see [here](https://github.com/mackeylab/bids_ppc_scripts/blob/master/assign_fieldmaps)).

Next, if a subject has fallen asleep or we need to discard some data, the BOLD niftis will be edited to reflect this after running the first chunk (some number # of TRs removed, for example, for sleeping), and subjects or runs that are bad or incomplete (total number of volumes < 130) will be documented in the CBPD Scanning Notes.

**Note**: *Adding to the `.bidsignore` does not affect running of any downstream tools such as MRIQC, which will run on these subjects anyways. This simply tells the `bids-validator` to ignore these files when checking whether the folder is valid.*

Check the MRI protocol notes ([here](https://docs.google.com/spreadsheets/d/15D3aYw1m127c-BHkAAxGTNqqpewZirn1OTzHZomUpUU/edit#gid=0)) or CBPD Scanning Data ([here](https://docs.google.com/spreadsheets/d/1tEMxyA7doTrpNZVW6m5qZJJG_muINBZU7ryn1AGwQtI/edit#gid=0)) for whether a participant has fallen asleep, and at what time. If we didn't note when they fell asleep, mark the whole run to discard for sleeping. A script for discarding extra TRs is [here](https://github.com/mackeylab/bids_ppc_scripts/blob/master/fix_topup_sequences/README.md).

## Second script
The second chunk is run by `new_subj_second` script. This does the below:
- Run [MRIQC](https://mriqc.readthedocs.io/en/stable/) on that subject.
- Re-run MRIQC group command to add the new subject to the group MRIQC tsv files.
- Run cross-sectional Freesurfer on that subject’s chosen T1, including hippocampal subfields. The T1 used is documented on the `CBPD_Scanning_Data` Google sheet. Each timepoint has a separate Freesurfer `SUBJECTS_DIR` (see [here](https://github.com/mackeylab/bids_ppc_scripts/tree/master/freesurfer)).
- Run cross-sectional Freesurfer on any experimental T1 sequences. Each experimental sequence has a separate Freesurfer `SUBJECTS_DIR`.
- When Freesurfer is done, run fMRIprep specifically *on this session*, which will then run with precomputed session-specific Freesurfer inputs. (see [here](https://github.com/mackeylab/bids_ppc_scripts/tree/master/fmriprep)).

Then, someone should put their eyes on fMRIprep `.html` files for the subject, and copy MRIQC outputs (including # of resting-state vols kept) into CBPD Scanning Data file.

There will also be a script to pull only a subset of the columns of MRIQC IQMs and aggregate them into a file to update the `CBPD_Scanning_Data` Google sheet with.

**Note**: Here we treat longitudinal timepoints as separate subjects for Freesurfer and fMRIprep, given that we might expect significant anatomical change between timepoints. Longitudinal Freesurfer pipelines will be run separately, as they are not being used for functional preprocessing (per APM 03/2020).

## Requirements

Most scripts pull Singularity containers from their location in `/data/picsl/mackey_group/tools`, but you do need a few utilities accessible from your path. I recommend installing them all into a Conda environment (maybe your base environment).

- Singularity accessible from your path :
	```
	#add to your ~/.bash_profile
	SINGULARITY_PATH=/share/apps/singularity/2.5.1/bin
	PATH=${SINGULARITY_PATH}:${PATH}
	```
- Python packages in your Conda environment: `python-dateutil, dcm2niix`
	You need a *current* version of dcm2niix, do not use the one in `/data/picsl/mackey_group/BPD/envs/bpd_py`! You may need to remove that from your path.
	```
	  conda create -n <env-name> python=3.7
	  source activate <env-name>
	  conda config --append channels conda-forge
	  conda install python-dateutil dcm2niix
	  pip install pybids
	```
- Freesurfer :
	Use the 6.0.0-make-fix version if you're going to be brain-editing. You will need to add this to your `.bash_profile` or `.bashrc`.
	More information on the `make-fix` version is [here](https://www.mail-archive.com/freesurfer@nmr.mgh.harvard.edu/msg55648.html).

## Utilities
- Copying over dicoms from rico, detecting which have changed in the last four days
- Backing up dicoms to the hard drive (plug in drive, put in IDs, and run the loop)
- Removing extra TRs for sleeping participants
- Fixing conflicting `StudyInstanceUID` (for re-registered participants)
- Fixing protocol names of wrongly-named dicom headers
- Pulling a subset of MRIQC metrics

## Using the data
Please read the `README` and `CHANGES` at the top-level of the BIDS dataset!
