#!/usr/bin/env python
# -*- coding: latin-1 -*-

import os
import re
from subprocess import call

id = range(1,200)
runs = range(1,10)

#aliceloc
for i in id:
    for r in runs:
        pp = "sub-pp%03d" % i
        run = "run-%03d" % r
        
        run_folder = "/path_to/%s/func/fsl_level_1/%s_ses-01_task-aliceloc_%s_bold" % (pp, pp, run)
        preproc2_output = "%s/preproc2.feat/filtered_func_data.nii.gz" % (run_folder)
        if os.path.isfile(preproc2_output):
            print '%s aliceloc_%s already preprocessed [stage2]' % (pp, run)
        if not os.path.isfile(preproc2_output):
            nuisance_output = "%s/nuisance/confound_EVs.txt" % (run_folder)
            if os.path.isfile(nuisance_output):
                print 'start %s aliceloc_%s ...' % (pp, run)
                design_out = open('design_aliceloc_new.fsf', 'wb')
                lines = open('design_aliceloc.fsf', 'rb').readlines()
                for l1 in lines:
                    l2 = re.sub('\$1', pp, l1) # in design.fsf changed "sub-pp001" --> $1
                    design_out.write(l2)
                design_out.close()
                ###
                design_out = open('design_aliceloc_new1.fsf', 'wb')
                lines = open('design_aliceloc_new.fsf', 'rb').readlines()
                for l3 in lines:
                    l4 = re.sub('\$2', run, l3) # in design.fsf changed "run-001" --> $2
                    design_out.write(l4)
                design_out.close()
                call(['feat', 'design_aliceloc_new1.fsf'])
                call(['rm', 'design_aliceloc_new.fsf'])
                call(['rm', 'design_aliceloc_new1.fsf'])
                print 'preproc2 for %s aliceloc_%s done!' % (pp, run)
