"""

###############################################################################
# uASPIRE                                                                     #
# Retrieve constant reads and RBS sequence for NGS raw data analysis          #
# Simon Höllerer, ETH Zürich, D-BSSE, BPL, Basel, Switzerland                 #
# E-mail: simon.hoellerer@bsse.ethz.ch                                        #
# Authors: Simon Höllerer and Laetitia Papaxanthos                            #
# Date: November, 2019                                                        #
###############################################################################

# DESCRIPTION: This python scripts reads the position of the constant region
# and extracts the RBS sequence, which is defined as the subsequent 17 bases
# after the end of the constant region.
# It furthermore writes all lines with the constant region (index from previous
# script) to a new file.
# [...] find all raw NGS reads that contain the constant region detected by the previous script
# Environment variables are written in CAPITALS.
"""


# import
import numpy as np
import os
import sys
import logging
from datetime import datetime

# get task number
TASK = sys.argv[1]

# start logging
logging.basicConfig(filename = os.environ["LOGFILE"],
    level = logging.INFO,
    format='%(message)s')

print("{0}: Get constant sequence (t_{1})".format(
    datetime.now().strftime("%Y-%m-%d %H:%M:%S"), TASK))

# get PATH, RBS length and offset from environment
PATH = os.environ["OUT_DIR"]
RBS_LENGTH = int(os.environ["RBS_LENGTH"])
RBS_OFFSET = int(os.environ["RBS_OFFSET"])

# initialize positions and indices as list
positions = []
indices = []

# open position file
print("{0}: Create positions (t_{1})".format(datetime.now().strftime("%Y-%m-%d %H:%M:%S"), TASK))
with open(os.path.join(PATH, 'data_R2-7-17_C-pos_{0}.tmp'.format(TASK)), 'r') as file_1:
    # iterate through all lines
    for line_1 in file_1:
        linestrip = line_1.strip('\n').split(':')
        positions.append(linestrip[1].split('-'))
        indices.append(linestrip[0])

len_indices = len(indices)

positions = np.array(positions).astype(int)
indices = np.array(indices).astype(int) - 1  # bash to python index conversion

# write RBS sequence to a file
print("{0}: Writing data_RBS_exact_{1}.tmp (t_{1})".format(datetime.now().strftime("%Y-%m-%d %H:%M:%S"), TASK))
with open(os.path.join(PATH, 'data_R2_{0}.tmp'.format(TASK)), 'r') as file_2, \
        open(os.path.join(PATH, 'data_RBS_exact_{0}.tmp'.format(TASK)), 'w') as RBS:
    pointer_indices = 0
    for k, line_2 in enumerate(file_2):
        if k == indices[pointer_indices]:
            RBS.write(line_2.strip('\n')[RBS_OFFSET + positions[pointer_indices, 1]:
                RBS_OFFSET + positions[pointer_indices, 1] + RBS_LENGTH] + '\n')
            pointer_indices += 1
        if pointer_indices == len_indices:
            break

print("{0}: Write data_QC_C_{1}.tmp".format(
    datetime.now().strftime("%Y-%m-%d %H:%M:%S"), TASK))

# write the forward read of the selected RBSs to a new file
with open(os.path.join(PATH, "data_QC_{0}.tmp".format(TASK)), 'r') as data, \
    open(os.path.join(PATH, "data_QC_C_{0}.tmp".format(TASK)), 'w') as new_data:
    count = 0
    dataline = data.readline()
    for index in indices:
        while count < index:
            dataline = data.readline()
            count += 1
        new_data.write(dataline)


# done!
logging.info('{0}: Total number of reads in data_QC_C_{1}.tmp: {2}'.format(
    datetime.now().strftime("%Y-%m-%d %H:%M:%S"), TASK, len_indices))
