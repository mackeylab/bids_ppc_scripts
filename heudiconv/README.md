Here, we convert dicoms from the scanner to niftis in BIDS format using [heudiconv](https://heudiconv.readthedocs.io/). We use a `heudiconv` Singularity [container](https://github.com/mackeylab/home/wiki/Singularity-containers) to run heudiconv. 

`heudiconv_loop.sh` loops through all subjects that start with `CBPD` in our `dicoms` directory. It detects whether their subject ID ends in `_2` or `_3`, in which case it runs the relevant `heudiconv_cmd_longitud.sh`, which assigns that set of runs to `ses-02` or `ses-03`. If not, it runs vanilla `heudiconv_cmd.sh`.

**Note**: If you get an error about `conflicting StudyInstanceUID`, see [here](https://github.com/mackeylab/bids_ppc_scripts/utilities).

**Troubleshooting:** See heudiconv [tutorials](https://heudiconv.readthedocs.io/en/latest/tutorials.html).
