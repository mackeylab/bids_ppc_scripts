# fix_dcmheader_protocol.py

# Rewrites ProtocolName and SeriesDescription in dicom header

import pydicom
import glob
import sys

# Inputs:
dcm_dir = sys.argv[1]    # directory containing each subject's dicom folder
sub = sys.argv[2]        # subject ID
dcm_num = sys.argv[3]    # series number of the dicoms you want to rename
new_name = sys.argv[4]   # new protocol name that you want in the header

alldcm = glob.glob('%s/%s/001_%s_*.dcm' % (dcm_dir, sub, str(dcm_num).zfill(6)))

for jj in range(0,len(alldcm)):
    ds = pydicom.dcmread(alldcm[jj])
    ds.ProtocolName = new_name
    ds.SeriesDescription = new_name
    ds.save_as(alldcm[jj])
