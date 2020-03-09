## Freesurfer

**Note**: Here we treat longitudinal timepoints as separate subjects for Freesurfer and fMRIprep, given that we might expect significant anatomical change between timepoints. Longitudinal Freesurfer pipelines will be run separately, as they are not being used for functional preprocessing (per APM 03/2020).

We run "cross-sectional" Freesurfer, including hippocampal subfields, with a separate Freesurfer `SUBJECTS_DIR` for each timepoint. This allows us to specify session-specific runs of fMRIprep with session-specific Freesurfer using the fMRIprep flag `--fs-subjects-dir` set for each timepoint.

There is a new feature in fMRIprep to select which data to run based on a filter constructed in `pybids`. We select which session and acquisitions to process within fMRIprep using the `--bids-filter-file` flag (see [here](https://github.com/mackeylab/bids_ppc_scripts/tree/master/fmriprep)).
