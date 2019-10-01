Here, we convert dicoms from the scanner to niftis in BIDS format. `heudiconv_loop.sh` loops through all subjects that start with `CBPD` in our `dicoms` directory. It detects whether their subject ID ends in `_2`, in which case it runs `heudiconv_cmd_longitud.sh`, which assigns that set of runs to `ses-02`, or if not, it runs vanilla `heudiconv_cmd.sh`.

**Note** This script will need to be added to to process T3 longitudinal scans.

Fixing study identifiers only applies if you get an error about `Conflicting study identifiers found`. This typically occurs if a subject was registered twice, or taken out of the scanner and then put back in. Essentially, each time you register a subject, they get a new `StudyInstanceUID`, which messes up the conversion to nifti. If this occurs, run them through the `loop_for_fixing_study_identifiers.sh`. See Github issues and draft fix for this here [here] (https://github.com/nipy/heudiconv/pull/359), eventually we should be able to fix this by running using the flag `--grouping all`.

