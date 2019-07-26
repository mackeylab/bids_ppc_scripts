import os

def create_key(template, outtype=('nii.gz',), annotation_classes=None):
    if template is None or not template:
        raise ValueError('Template must be a valid format string')
    return template, outtype, annotation_classes

def infotodict(seqinfo):
    """Heuristic evaluator for determining which runs belong where

    allowed template fields - follow python string module:

    item: index within category
    subject: participant id
    seqitem: run number during scanning
    subindex: sub index within group
    session: scan index for longitudinal acq
    """

    # paths done in BIDS format
    t1w = create_key('sub-{subject}/{session}/anat/sub-{subject}_{session}_run-{item:02d}_T1w')
    t2w = create_key('sub-{subject}/{session}/anat/sub-{subject}_{session}_run-{item:02d}_T2w')
    rest = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-rest_run-{item:02d}_bold')
    task_nback = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-nback_run-{item:02d}_bold')
    task_num = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-number_run-{item:02d}_bold')
    dwi = create_key('sub-{subject}/{session}/dwi/sub-{subject}_{session}_run-{item:02d}_dwi')
    fmap = create_key('sub-{subject}/{session}/fmap/sub-{subject}_{session}_run-{item:02d}_epi')

    info = {t1w: [], t2w: [], rest: [], task_nback: [], task_num: [], dwi: [], fmap: []}

    for s in seqinfo:
        """
        The namedtuple `s` contains the following fields:

        * total_files_till_now
        * example_dcm_file
        * series_number
        * dcm_dir_name
        * unspecified2
        * unspecified3
        * dim1
        * dim2
        * dim3
        * dim4
        * TR
        * TE
        * protocol_name
        * is_motion_corrected
        * is_derived
        * patient_id
        * study_description
        * referring_physician_name
        * series_description
        * image_type
        """
        if s.dim3 == 176 and 'MPRAGE' in s.protocol_name:
            info[t1w].append(s.series_id)
        if 'T2' in s.protocol_name:
            info[t2w].append(s.series_id)
        if 'rest' in s.protocol_name:
            info[rest].append(s.series_id)
        if 'n_back' in s.protocol_name:
            info[task_nback].append(s.series_id)
        if 'number' in s.protocol_name:
            info[task_num].append(s.series_id)
        if 'DTI_64' in s.protocol_name:
            info[dwi].append(s.series_id)
        if 'DTI_TOPUP' in s.protocol_name:
            info[fmap].append(s.series_id)

    return info
