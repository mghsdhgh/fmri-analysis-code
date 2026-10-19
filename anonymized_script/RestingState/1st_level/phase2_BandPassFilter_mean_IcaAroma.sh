#!/bin/bash
#apply band-pass filter on ICA-aroma output for rsfMRI analysis
#The '-bptf' option to fslmaths removes the temporal mean, and does not add it back after filtering.
#tr=2,
#1/(2*f*TR) the high-pass filter--> 1/(2*0.008*2) =  31.25
#1/(18*f*TR) the low-passfilter --> 1/(18*0.08*2) =  0.3472


FSLDIR=/usr/local/fsl
. ${FSLDIR}/etc/fslconf/fsl.sh
PATH=${FSLDIR}/bin:${PATH}
export FSLDIR PATH


for sub_dir in /path_to/new/sub-pp*/
    do
    sub=$(basename "$sub_dir")
    cd "${sub_dir}/func/fsl_level_1/${sub}_ses-01_task-rest_run-001_bold/ICA_AROMA/"
 
    #Calculate the temporal mean
    
    fslmaths denoised_func_data_nonaggr.nii.gz -Tmean ${sub}_denoised_func_data_nonaggr_mean.nii.gz
    
    
    #Bandpass filter, and add the mean back

    fslmaths denoised_func_data_nonaggr.nii.gz -bptf  31.25 0.3472 -add ${sub}_denoised_func_data_nonaggr_mean.nii.gz ${sub}_denoised_func_data_nonaggr_mean_BPfiltered.nii.gz
    
    echo "${sub} and ${str} is done ^--^ "
    
    done