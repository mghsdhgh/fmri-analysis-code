#!/usr/bin/env python
# -*- coding: latin-1 -*-

import os
import re
import subprocess
from subprocess import call

id = range(1,200)

for i in id:

    pp = "sub-pp%03d" % i

    task_folder = "/path_to/%s/func/fsl_level_1/%s_ses-01_task-rest_run-001_bold/" % (pp, pp)
    reg_folder = "%s/SBC_RightHippocamus_WmCsfConfound_mn.feat/reg" % task_folder

    if not os.path.isdir(reg_folder):

        preproc2_output = "%s/SBC_RightHippocamus_WmCsfConfound_mn.feat/mean_func.nii.gz" % task_folder
        if os.path.isfile(preproc2_output):

        # make symbolic link
            val = subprocess.check_call("ln -s %s/preproc1.feat/reg %s/SBC_RightHippocamus_WmCsfConfound_mn.feat/reg" % (task_folder, task_folder),   shell=True)
            print 'Caudate %s ready!' % (pp)

