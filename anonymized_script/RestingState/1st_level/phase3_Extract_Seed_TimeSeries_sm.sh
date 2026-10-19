#!/bin/bash
#Extract Time Series from Seed Region


FSLDIR=/usr/local/fsl
. ${FSLDIR}/etc/fslconf/fsl.sh
PATH=${FSLDIR}/bin:${PATH}
export FSLDIR PATH


for sub_dir in /path_to/new/sub-pp*/; do
    
    sub=$(basename "$sub_dir")
    dir2="${sub_dir}/func/fsl_level_1/${sub}_ses-01_task-rest_run-001_bold/"
    mkdir "${dir2}/SBC/"
#--eig
    
    fslmeants -i ${dir2}/ICA_AROMA/${sub}_denoised_func_data_nonaggr_mean_BPfiltered.nii.gz -o ${dir2}/SBC/${sub}_RightHippocampus_mean.txt   -m "${dir2}/preproc1.feat/reg/${sub}_RightHippocampus_native.nii.gz"     
  

echo "${sub} is done ^--^ "

done