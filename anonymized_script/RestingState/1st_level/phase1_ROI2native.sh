#!/bin/bash

FSLDIR=/usr/local/fsl
. ${FSLDIR}/etc/fslconf/fsl.sh
PATH=${FSLDIR}/bin:${PATH}
export FSLDIR PATH

ROI_dir="/path_to/ROIs/ROIS/"

for sub_dir in /path_to/new/sub-pp*/

    do
    
    sub=$(basename "$sub_dir")
    
    
    cd "${sub_dir}/func/fsl_level_1/${sub}_ses-01_task-rest_run-001_bold/preproc1.feat/reg/"
    
    
    #Apply the transformations mni 2 native space 
    
   
    flirt -in "${ROI_dir}/harvardoxford-subcortical_prob_Right_Hippocampus-th50-bw.nii.gz"   -ref "example_func.nii.gz" -applyxfm -init "standard2example_func.mat" -out "${sub}_RightHippocampus_native.nii.gz"
    
     #  echo "${sub} and ${str} is done ^--^ "
    
    done
    
