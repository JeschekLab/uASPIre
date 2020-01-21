'''

###############################################################################
# uASPIRE                                                                     #
# Final script for NGS raw data analysis                                      #
# Simon Höllerer, ETH Zürich, D-BSSE, BPL, Basel, Switzerland                 #
# E-mail: simon.hoellerer@bsse.ethz.ch                                        #
# Authors: Simon Höllerer and Laetitia Papaxanthos                            #
# Date: November, 2019                                                        #
###############################################################################

# DESCRIPTION: This python script...
# Environment variables are written in CAPITALS.

'''


# import
import pandas as pd
import numpy as np
import os
import sys
import logging
from datetime import datetime
from Bio.Seq import Seq

# functions
def get_environ_var(name):
    if name not in os.environ:
        raise ValueError("Environmental variable {0} not found.".format(name))
    return os.environ[name]

def get_environ_var_array(name):
    if name not in os.environ:
        raise ValueError("Environmental variable {0} not found.".format(name))
    return np.array(os.environ[name].split(' '))

def reverse_complement(dna):
    # Function for reverse complement sequence
    complement = {'A': 'T', 'C': 'G', 'G': 'C', 'T': 'A', 'N': 'N'}
    return ''.join([complement[base] for base in dna[::-1]])


# get environment variables
PATH = get_environ_var("OUT_PATH")
RESULT_PATH = get_environ_var("RESULT_PATH")
PROJECT_NAME = get_environ_var("PROJECT_NAME")
SAMPLES_NUMBER = int(get_environ_var("SAMPLES_NUMBER"))
SAMPLES_TIME_POINTS = list(get_environ_var_array("SAMPLES_TIME_POINTS"))
CUTOFF_OVERALL = int(get_environ_var("CUTOFF_OVERALL"))

# add 'RBS' and 'sum' to time points
colnames=["RBS"] + SAMPLES_TIME_POINTS + ["sum"]

cutoff_overall = 1
# cutoff_per_time_point = 0 # <----------------- ???

print("Starting final python script")

# start logging
logging.basicConfig(filename=os.environ["LOGFILE"], level=logging.INFO)

print("Read flipped and non-flipped")

# read flipped and non-flipped tables
RBS_S_nf = {} # <----------------- not optimal as dictionary
RBS_S_ff = {} # <----------------- not optimal as dictionary
for idx in range(1, SAMPLES_NUMBER + 1):  # files named 1 up to SAMPLES_NUMBER = 9
    dataframe_nf = pd.read_csv(os.path.join(PATH, 'RBS_S{0}_nf_all.tmp'.format(idx)), names='RBS')
    dataframe_nf = pd.value_counts(dataframe_nf.iloc[:, 0]).to_frame().reset_index()
    dataframe_nf.columns = ["RBS", "S{}".format(idx)]
    RBS_S_nf[idx] = dataframe_nf
    
    dataframe_ff = pd.read_csv(os.path.join(PATH, 'RBS_S{0}_ff_all.tmp'.format(idx)), names='RBS')
    dataframe_ff = pd.value_counts(dataframe_ff.iloc[:, 0]).to_frame().reset_index()
    dataframe_ff.columns = ["RBS", "S{}".format(idx)]
    RBS_S_ff[idx] = dataframe_ff

print("Merge and replace NAs")

# merge and replace "NA" with 0
mdataframe_nf = RBS_S_nf[1]
mdataframe_ff = RBS_S_ff[1]
print("mdataframe_nf")
print(mdataframe_nf)
print("mdataframe_ff")
print(mdataframe_ff)

for idx in range(2, SAMPLES_NUMBER + 1):
    mdataframe_nf = mdataframe_nf.merge(RBS_S_nf[idx], left_on='RBS', right_on='RBS', how='outer') # <----------------- ERROR, an outer merge nullifies the cutoff_per_time_point and makes an OR cutoff_per_time_point instead of AND; better: array, minimum per row
    mdataframe_ff = mdataframe_ff.merge(RBS_S_ff[idx], left_on='RBS', right_on='RBS', how='outer') # <----------------- ERROR, an outer merge nullifies the cutoff_per_time_point and makes an OR cutoff_per_time_point instead of AND; better: array, minimum per row

mdataframe_nf = mdataframe_nf.fillna(0)
mdataframe_ff = mdataframe_ff.fillna(0)



logging.info('{0}: Number of lines in non-flipped dataset {1}, number of lines in flipped dataset {2}'.format(
    datetime.now().strftime("%Y-%m-%d %H:%M:%S"), mdataframe_nf.shape[0], mdataframe_ff.shape[0]))

print("Calculate overall reads") # <----------------- very slow step

# calculate overall reads
Sdata = mdataframe_nf.merge(mdataframe_ff, left_on='RBS', right_on='RBS', how='outer', suffixes=('.nf', '.ff'))
Sdata = Sdata.fillna(0)
Sdata['sum'] = Sdata.sum(axis=1).astype(int)

print("Set cutoff for overall reads")

# set cutoff for overall reads
Cdata = Sdata[Sdata['sum'] >= cutoff_overall]



# merge with  overall read file
Mdataframe_nf = mdataframe_nf.merge(Cdata[['RBS']], left_on='RBS', right_on='RBS', how='inner')
Mdataframe_ff = mdataframe_ff.merge(Cdata[['RBS']], left_on='RBS', right_on='RBS', how='inner')


Mdataframe_ff = Mdataframe_ff.merge(Cdata[['RBS', 'sum']], left_on='RBS', right_on='RBS', how='outer')
Mdataframe_nf = Mdataframe_nf.merge(Cdata[['RBS', 'sum']], left_on='RBS', right_on='RBS', how='outer')
Mdataframe_nf = Mdataframe_nf.fillna(0)
Mdataframe_ff = Mdataframe_ff.fillna(0)

logging.info('{0}: Number of lines in non-flipped dataset {1}, number of lines in flipped dataset {2} after overall cutoff'.format(
    datetime.now().strftime("%Y-%m-%d %H:%M:%S"), Mdataframe_nf.shape[0], Mdataframe_ff.shape[0]))

print("Convert and sort data")

Mdataframe_nf.loc[:, Mdataframe_nf.columns != 'RBS'] = Mdataframe_nf.loc[:, Mdataframe_nf.columns != 'RBS']
Mdataframe_ff.loc[:, Mdataframe_ff.columns != 'RBS'] = Mdataframe_ff.loc[:, Mdataframe_ff.columns != 'RBS']

Mdataframe_nf.columns = colnames
Mdataframe_ff.columns = colnames

Fdata_nf = Mdataframe_nf.sort_values('RBS', axis=0) # sort to calculate fraction flipped below
Fdata_ff = Mdataframe_ff.sort_values('RBS', axis=0)


print("Calculate fraction flipped")

# calculate fraction flipped
Fdata = Fdata_nf.copy()

Fdata_nf_array = Fdata_nf[colnames[1:-1]].values.astype(float)
Fdata_ff_array = Fdata_ff[colnames[1:-1]].values.astype(float)

denominator = Fdata_nf_array + Fdata_ff_array

# Change: Fdata_array[denominator == 0.] is set to np.nan rather than 0 to
# differentiate these cases from those in which denominator != 0 and numerator = 0
Fdata_array = np.zeros_like(Fdata_nf_array)
#calculate fraction flipped
Fdata_array[denominator != 0.] = Fdata_ff_array[denominator != 0.] / denominator[denominator != 0.]
# fill array at positions with denominator = 0 (no ff or nf read) with NA
Fdata_array[denominator == 0.] = np.nan

logging.info('{}: Total number of NaN values as fraction flipped: {}'.format(
    datetime.now().strftime("%Y-%m-%d %H:%M:%S"), np.isnan(Fdata_array).sum()))


count_nans = []
for k, rbs in enumerate(Fdata_array):
    if np.isnan(rbs).sum() != 0:
        count_nans.append(k)

logging.info('{}: Total number of RBSs with NaN values as fraction flipped: {}'.format(
   datetime.now().strftime("%Y-%m-%d %H:%M:%S"), len(count_nans)))



# remove nans
if len(count_nans) != 0:
    mask_nans = np.ones(Fdata_array.shape[0], dtype=bool)
    mask_nans[np.array(count_nans)] = False
    Fdata_array = Fdata_array[mask_nans, :]
    Fdata = Fdata.iloc[mask_nans]


Fdata[colnames[1:-1]] = Fdata_array

# write final files
Fdata['RBS'] = [reverse_complement(sequence) for sequence in Fdata['RBS'].values]
Fdata_nf['RBS'] = [reverse_complement(sequence) for sequence in Fdata_nf['RBS'].values]
Fdata_ff['RBS'] = [reverse_complement(sequence) for sequence in Fdata_ff['RBS'].values]

Fdata.to_csv(os.path.join(RESULT_PATH, "{0}_unsorted_fraction.txt".format(PROJECT_NAME)), sep="\t", index=False)
Fdata_nf.to_csv(os.path.join(RESULT_PATH, "{0}_unsorted_reads_non-flipped.txt".format(PROJECT_NAME)), sep="\t", index=False) # <----------------- print as integer without '.0'
Fdata_ff.to_csv(os.path.join(RESULT_PATH, "{0}_unsorted_reads_flipped.txt".format(PROJECT_NAME)), sep="\t", index=False) # <----------------- print as integer without '.0'


print("Data analysis successfully executed!")
