#!/bin/bash

###############################################################################
# uASPIRE                                                                     #
# Extract RBS sequence for NGS raw data analysis                              #
# Simon Höllerer, ETH Zürich, D-BSSE, BPL, Basel, Switzerland                 #
# E-mail: simon.hoellerer@bsse.ethz.ch                                        #
# Authors: Simon Höllerer and Laetitia Papaxanthos                            #
# Date: November, 2019                                                        #
###############################################################################

# DESCRIPTION: This script writes the exact RBS sequence of all non-flipped
# (nf) and flipped (ff) reads into a new file.



# import config
source "${CONFIG}"


# get file number = task number from main script
TASK=$1


# determine RBS and append RBS sequence to output file
# write non-flipped
for file in $(eval echo "{1..$SAMPLES_NUMBER}"); do
  printf "$(timestamp): writing non-flipped S${file} (t_${TASK})\n"
  awk '{print $3}' "${OUT_PATH}/data_S${file}_nf_${TASK}.tmp" > "${OUT_PATH}/RBS_S${file}_nf_${TASK}.tmp"
done


# write flipped
for file in $(eval echo "{1..$SAMPLES_NUMBER}"); do
  printf "$(timestamp): writing flipped S${file} (t_${TASK})\n"
  awk '{print $3}' "${OUT_PATH}/data_S${file}_ff_${TASK}.tmp" > "${OUT_PATH}/RBS_S${file}_ff_${TASK}.tmp"
done


# done!
printf "$(timestamp): done (t_${TASK})!\n"
