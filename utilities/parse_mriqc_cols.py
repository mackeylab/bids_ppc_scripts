"""
Filtering out only relevant columns from MRIQC
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Takes columns in derivatives/mriqc_fd_<threshold>_mm and rewrites into a file
for CBPD Scanning Data.

USAGE: parse_mriqc_cols.py <full_bids_dir> <fd_threshold>

"""

import pandas as pd
import sys
from os.path import join

BIDS_dir=sys.argv[1]
threshold = str(sys.argv[2])
# subj_dir *must* have trailing /, use os.path.join to do
MRIQC_dir = join(BIDS_dir,"derivatives",("mriqc_fd_"+threshold+ "_mm"))
output_filename= join(MRIQC_dir,"MRIQC_filtered_columns_"+threshold+"mm.csv")

df = pd.read_csv(join(MRIQC_dir,"group_bold.tsv"),
    sep = '\t')
df=df[['bids_name', 'size_t','fd_mean', 'fd_num', 'fd_perc']]
df = df.rename(columns={'size_t':'MRIQC # of vols', 'fd_mean':'MRIQC mean FD', 'fd_num':'MRIQC # outliers > '+threshold+' mm',
    'fd_perc':'MRIQC % outliers > '+threshold+' mm'})
df.to_csv(output_filename)
