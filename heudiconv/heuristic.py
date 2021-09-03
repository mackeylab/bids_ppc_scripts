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
    t1w_hbcd = create_key('sub-{subject}/{session}/anat/sub-{subject}_{session}_acq-hbcd_run-{item:02d}_T1w')
    t2w_vnav = create_key('sub-{subject}/{session}/anat/sub-{subject}_{session}_acq-vnav_run-{item:02d}_T2w')
    t2w_hbcd = create_key('sub-{subject}/{session}/anat/sub-{subject}_{session}_acq-hbcd_run-{item:02d}_T2w')
    rest = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-rest_run-{item:02d}_bold')
    rest_sbref=create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-rest_run-{item:02d}_sbref')
    piper = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-piper_run-{item:02d}_bold')
    piper_sbref = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-piper_run-{item:02d}_sbref')
    dwi = create_key('sub-{subject}/{session}/dwi/sub-{subject}_{session}_run-{item:02d}_dwi')
    dwi_fmap = create_key('sub-{subject}/{session}/fmap/sub-{subject}_{session}_run-{item:02d}_epi')
    #no longer actively used, for legacy conversion.
    abcd_fmap = create_key('sub-{subject}/{session}/fmap/sub-{subject}_{session}_acq-{label}_dir-{dir}_epi')
    rest_abcd=create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-rest_acq-abcd_run-{item:02d}_bold')
    piper_abcd = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-piper_acq-abcd_run-{item:02d}_bold')
    task_nback = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-nback_run-{item:02d}_bold')
    task_num = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-number_run-{item:02d}_bold')
    cs_acc5_t1w = create_key('sub-{subject}/{session}/anat/sub-{subject}_{session}_acq-csacc5_run-{item:02d}_T1w')
    cs_acc42_t1w = create_key('sub-{subject}/{session}/anat/sub-{subject}_{session}_acq-csacc42_run-{item:02d}_T1w')
    t2w = create_key('sub-{subject}/{session}/anat/sub-{subject}_{session}_run-{item:02d}_T2w')
    #we no longer collect a non-vnav T2 as of May 2021

    info = {t1w: [], t1w_hbcd: [], cs_acc5_t1w: [], cs_acc42_t1w: [], t2w: [], t2w_vnav: [], t2w_hbcd: [], rest: [], rest_abcd: [], piper: [],
            piper_abcd: [], task_nback: [], task_num: [], dwi: [], dwi_fmap: [], abcd_fmap: [], rest_sbref: [], piper_sbref: []}

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
        if s.dim3 == 176 and 'vNav_MPRAGE' in s.protocol_name:
            info[t1w].append(s.series_id)
        if s.dim3 == 176 and 'HBCD_vNav_MEMPRAGE' in s.protocol_name:
            info[t1w_hbcd].append(s.series_id) #not sure if this will work.
        if s.dim3 == 176 and 'HBCD_T2_' in s.protocol_name and 'NORM' in s.image_type:
            info[t2w_hbcd].append(s.series_id)
        if s.dim3 == 176 and 'vNav_T2_SPACE' in s.protocol_name and 'NORM' in s.image_type:
            info[t2w_vnav].append(s.series_id)
        if 'rest' in s.protocol_name and s.TR == 2 and s.dim4 > 3:
            info[rest].append(s.series_id)
        if 'rest' in s.protocol_name and s.TR == 2 and 'SBRef' in s.series_description:
            info[rest_sbref].append(s.series_id)
        if 'piper' in s.protocol_name and s.TR == 2 and s.dim4 > 3:
            info[piper].append(s.series_id)
        if 'piper' in s.protocol_name and s.TR == 2 and 'SBRef' in s.series_description:
            info[piper_sbref].append(s.series_id)
        if 'DTI_64' in s.protocol_name:
            info[dwi].append(s.series_id)
        if 'DTI_TOPUP' in s.protocol_name:
            info[dwi_fmap].append(s.series_id)
        #for legacy conversion
        if 'n_back' in s.protocol_name:
            info[task_nback].append(s.series_id)
        if 'number' in s.protocol_name:
            info[task_num].append(s.series_id)
        if 'piper' in s.protocol_name and s.TR == 0.8:
            info[piper_abcd].append(s.series_id)
        if 'rest' in s.protocol_name and s.TR == 0.8:
            info[rest_abcd].append(s.series_id)
        if 'fMRI' in s.protocol_name and'DistortionMap' in s.protocol_name and '_PA' in s.protocol_name:
            info[abcd_fmap].append({'item': s.series_id, 'dir': 'PA', 'label': 'fMRI'});
        if 'fMRI' in s.protocol_name and 'DistortionMap' in s.protocol_name and '_AP' in s.protocol_name:
            info[abcd_fmap].append({'item': s.series_id, 'dir': 'AP', 'label': 'fMRI'});
        if 'CSMPRAGE_1mm_acc5' in s.protocol_name:
            info[cs_acc5_t1w].append(s.series_id)
        if 'CSMPRAGE_1mm_acc4.2' in s.protocol_name:
            info[cs_acc42_t1w].append(s.series_id);
        if '-T2_' in s.series_id and s.dim3 == 176:
            info[t2w].append(s.series_id) #keep only the regular T2s that start with -T2 and that aren't vNav setter
        #for BPD data only
        # if s.dim3 == 176 and 'MPRAGE_' in s.protocol_name:
        #     info[t1w].append(s.series_id)


    return info
