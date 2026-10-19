#!/usr/bin/env python
# -*- coding: latin-1 -*-

import os
import re
from subprocess import call

id = range(1,200)

for i in id:
    pp = "sub-pp%03d" % i
    run_path = "/path_to/%s/func/fsl_level_1/%s_ses-01_task-rest_run-001_bold/" % (pp, pp)
    processed = "%s/SBC_RightHippocamus_WmCsfConfound_mn.feat/stats/cope1.nii.gz" % run_path

    if os.path.isfile(processed):
        print '%s already processed' % (pp)

    if not os.path.isfile(processed):
        source = "%s/ICA_AROMA/%s_denoised_func_data_nonaggr_mean_BPfiltered.nii.gz" % (run_path, pp)
        if os.path.isfile(source):
            
            print 'start SBC for %s ----' % (pp)
            ###
            design_out = open('design_pp_new.fsf', 'wb')
            lines = open('design_pp_RightHippocamus.fsf', 'rb').readlines() # design file for preproc1
            for l1 in lines:
                l2 = re.sub('\$1', pp, l1) # in design.fsf changed "sub-pp001" --> $1 
                design_out.write(l2)
            design_out.close()
            call(['feat', 'design_pp_new.fsf'])
            call(['rm', 'design_pp_new.fsf'])

            print 'SBC for %s done!' % (pp)