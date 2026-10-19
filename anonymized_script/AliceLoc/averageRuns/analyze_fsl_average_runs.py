#!/usr/bin/env python
# -*- coding: latin-1 -*-

import os
import re
from subprocess import call

id = range(1,200)

#aliceloc
for i in id:
    pp = "sub-pp%03d" % i
    average_runs_output = "/path_to/%s/func/fsl_level_1/%s_ses-01_task-aliceloc.gfeat/mean_func.nii.gz" % (pp, pp)
    if os.path.isfile(average_runs_output):
        print '%s aliceloc runs average exists' % (pp)
    if not os.path.isfile(average_runs_output):
        preproc2_output = "/path_to/%s/func/fsl_level_1/%s_ses-01_task-aliceloc_run-003_bold/preproc2.feat/example_func.nii.gz" % (pp, pp)
        if os.path.isfile(preproc2_output):
            print 'start %s aliceloc ...' % (pp)
            design_out = open('design_aliceloc_new.fsf', 'wb')
            lines = open('design_aliceloc.fsf', 'rb').readlines()
            for l1 in lines:
                l2 = re.sub('\$1', pp, l1) # in design.fsf changed "sub-pp001" --> $1
                design_out.write(l2)
            design_out.close()
            call(['feat', 'design_aliceloc_new.fsf'])
            call(['rm', 'design_aliceloc_new.fsf'])
            print 'runs average for %s aliceloc done!' % (pp)

