Here, we convert dicoms from the scanner to niftis in BIDS format. `heudiconv_loop.sh` loops through all subjects that start with `CBPD` in our `dicoms` directory. It detects whether their subject ID ends in `_2`, in which case it runs `heudiconv_cmd_longitud.sh`, which assigns that set of runs to `ses-02`, or if not, it runs vanilla `heudiconv_cmd.sh`.


**Note** This script will need to be added to to process T3 longitudinal scans.
