## fMRIprep

**Note**: Here we treat longitudinal timepoints as separate subjects for Freesurfer and fMRIprep, given that we might expect significant anatomical change between timepoints. Longitudinal Freesurfer pipelines will be run separately, as they are not being used for functional preprocessing (per APM 03/2020).

There is a new feature in fMRIprep to select which data to run based on a filter constructed in `pybids`. We may be able to run cross-sectional Freesurfer within fMRIprep using the `--bids-filter-file` flag.