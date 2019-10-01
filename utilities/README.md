
__Fixing study identifiers__

Applies if you get an error during dicom conversion about `Conflicting study identifiers found`. This typically occurs if a subject was registered twice, or taken out of the scanner and then put back in. Essentially, each time you register a subject, they get a new `StudyInstanceUID`, which messes up the conversion to nifti. If this occurs, run them through the `loop_for_fixing_study_identifiers.sh`.

**See Github issues and draft fix for this [here](https://github.com/nipy/heudiconv/pull/359)**.
Eventually we should be able to fix this by running using the flag `--grouping all` in heudiconv.
