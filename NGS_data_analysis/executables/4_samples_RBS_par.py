"""

###############################################################################
# uASPIRE                                                                     #
# Retrieve discriminator and barcodes for NGS raw data analysis               #
# Simon Höllerer, ETH Zürich, D-BSSE, BPL, Basel, Switzerland                 #
# E-mail: simon.hoellerer@bsse.ethz.ch                                        #
# Authors: Simon Höllerer and Laetitia Papaxanthos                            #
# Date: November, 2019                                                        #
###############################################################################

# DESCRIPTION: This python script takes the indices of flipped, non-flipped and
# of all barcodes from the previous bash script and writes them to new files.
# It also removes reads with two called discriminators or more than 2 called
# barcodes.
# Environment variables are written in CAPITALS.

"""


# import
import os
import sys
import pandas as pd
import numpy as np
import logging
from datetime import datetime


# def functions
def get_environ_var_array(name):
    if name not in os.environ:
        raise ValueError("Environmental variable {0} not found.".format(name))
    return np.array(os.environ[name].split(' '))

def get_environ_var(name):
    if name not in os.environ:
        raise ValueError("Environmental variable {0} not found.".format(name))
    return os.environ[name]

def fastq2intlist(filename):
    with open(os.path.join(PATH, filename), 'r') as f:
        return np.array([int(line) for line in f]) - 1  # index conversion


# process input arguments
TASK = sys.argv[1]
# TASK = "01"

# get environment variables
PATH = os.environ["OUT_DIR"]
SAMPLES_BC = list(get_environ_var_array("SAMPLES_BC").astype(int))
BARCODES_LEN = int(get_environ_var("BARCODES_NUMBER"))


length = range(1, BARCODES_LEN+1)

# start logging
logging.basicConfig(filename = os.environ["LOGFILE"],
    level = logging.INFO,
    format='%(message)s')


print("{0}: reading data (t_{1})".format(
    datetime.now().strftime("%Y-%m-%d %H:%M:%S"), TASK))

# read data # <------------------- better comment
data_con = pd.read_csv(PATH+'/data_QC_C_{0}.tmp'.format(
    TASK), sep='\t', usecols=(0, 1,), header=None).values

# <------------------- comment missing
length_data_con = len(data_con)

print('{0}: loading RBS data (t_{1})'.format(
    datetime.now().strftime("%Y-%m-%d %H:%M:%S"), TASK))

# <------------------- comment missing
with open(os.path.join(PATH, "data_RBS_exact_{0}.tmp".format(
    TASK)), "r") as data_RBS_exact_file:
    data_RBS_exact = np.array(data_RBS_exact_file.readlines()).reshape((-1, 1))  # Coerce to 2D "column" array

print("{0}: reading forward and reverse indices (t_{1})".format(
    datetime.now().strftime("%Y-%m-%d %H:%M:%S"), TASK))

# read indices for forward and reverse barcodes as dictionary
index_L = {}
index_R = {}

length = range(1, BARCODES_LEN+1)

for idx in length:
    #print(length)
    #print(type(length))
    index_L[idx] = fastq2intlist("data_BC_L{0}_idx_{1}.tmp".format(idx, TASK))
    index_R[idx] = fastq2intlist("data_BC_R{0}_idx_{1}.tmp".format(idx, TASK))

# create extension to data_con with sample, barcodes left and right, fraction flipped
data_con_extension = np.zeros((length_data_con, 4))  # columns are: sample, BC Left, BC Right, ff

# fill with column samples
for idx in length:
    data_con_extension[index_L[idx], 1] = idx # Python starts at 0 and awk at 1
    data_con_extension[index_R[idx], 2] = idx

print("{0}: Determine sample (t_{1})".format(
    datetime.now().strftime("%Y-%m-%d %H:%M:%S"), TASK))

# determine sample
data_con_extension[:, 0] = data_con_extension[:, 1]*10 + data_con_extension[:, 2]

print("{0}: Read non-flipped and flipped indices (t_{1})".format(
    datetime.now().strftime("%Y-%m-%d %H:%M:%S"), TASK))

# read non-flipped and flipped indices
index_nf = fastq2intlist("data_nf_idx_{0}.tmp".format(TASK))
index_ff = fastq2intlist("data_ff_idx_{0}.tmp".format(TASK))

# check intersect for quality control
intersect_nfff = len(set(index_ff).intersection(index_nf))
logging.info('{0}: Number of RBSs that are both flipped and non-flipped: {1}; task {2}'.format(datetime.now().strftime("%Y-%m-%d %H:%M:%S"), intersect_nfff, TASK))

# write flipping to numpy array
data_con_extension[index_nf, 3] = -1
data_con_extension[index_ff, 3] = 1  # python starts at 0 and awk at 1

# detect double called barcodes
db = np.zeros((length_data_con, 2*BARCODES_LEN))

for idx in length:
    db[index_L[idx], idx - 1] = 1
    db[index_R[idx], idx + BARCODES_LEN - 1] = 1

# 
index_db = np.logical_not(np.logical_and(db[:, :BARCODES_LEN].sum(axis=1) == 1,
                                         db[:, BARCODES_LEN:BARCODES_LEN*2].sum(axis=1) == 1))

# remove sequences that are called as both flipped and non-flipped for quality control
print("{0}: Remove double called discriminators (t_{1})".format(
    datetime.now().strftime("%Y-%m-%d %H:%M:%S"), TASK))

dff = np.zeros((length_data_con, 3))  # nf, ff, sum
dff[index_nf, 0] = 1 # index conversion
dff[index_ff, 1] = 1
dff[:, 2] = np.sum(dff[:, :2], axis=1)

# determine all rows with more than 1 or no called discriminator state
index_dff = np.logical_or(dff[:, 2] > 1, dff[:, 2] < 1)

# set sample and flipping for those reads to 0 <------------------- not optimal, this would mean non-flipped
data_con_extension[index_db, 0] = 0
data_con_extension[index_dff, 3] = 2

print('{0}: Identify BC and split data, (t_{1})'.format(datetime.now().strftime("%Y-%m-%d %H:%M:%S"), TASK))

# split data frames
data_S_nf = {} # <------------------- not optimal as dictionary
data_S_ff = {} # <------------------- not optimal as dictionary
count_ = 1

# normal run
for idx in SAMPLES_BC:
    #print(SAMPLES_BC)
    #print(type(SAMPLES_BC))
    index_nf_bool = (data_con_extension[:, 0] == idx) & (data_con_extension[:, 3] == -1) # <----------------- ERROR, non-flipped is determined as default !!! # edit Anja 19.12., '== 0' => '== -1'
    index_ff_bool = (data_con_extension[:, 0] == idx) & (data_con_extension[:, 3] == 1)
    data_S_nf[count_] = np.hstack((data_con[index_nf_bool], data_RBS_exact[index_nf_bool]))
    data_S_ff[count_] = np.hstack((data_con[index_ff_bool], data_RBS_exact[index_ff_bool]))
    count_ += 1



print('{0}: Saving files (t_{1})'.format(datetime.now().strftime("%Y-%m-%d %H:%M:%S"), TASK))
for count_ in np.arange(1, len(SAMPLES_BC) + 1):
    np.savetxt(os.path.join(PATH, "data_S{0}_ff_{1}.tmp".format(count_, TASK)), data_S_ff[count_], delimiter="\t", fmt='%s', newline='')
    np.savetxt(os.path.join(PATH, "data_S{0}_nf_{1}.tmp".format(count_, TASK)), data_S_nf[count_], delimiter="\t", fmt='%s', newline='')

print('{0}: 4_samples_RBS_par.py executed (t_{1})'.format(datetime.now().strftime("%Y-%m-%d %H:%M:%S"), TASK))
