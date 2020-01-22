#!/bin/bash

###############################################################################
# uASPIRE                                                                     #
# Extract raw data and merge reads                                            #
# Simon Höllerer, ETH Zürich, D-BSSE, BPL, Basel, Switzerland                 #
# E-mail: simon.hoellerer@bsse.ethz.ch                                        #
# Authors: Simon Höllerer and Laetitia Papaxanthos                            #
# Date: November, 2019                                                        #
###############################################################################

# DESCRIPTION: This script takes the raw compressed input files, unpacks them
# on the fly and writes the sequence of the forward read and the reverse read
# together into the output file 'data.fastq'. It also counts the number of
# total sequencing reads.


# import config
source "${CONFIG}"


# write the sequence of the forward and reverse read into 'data.fastq' (without quality)
printf "$(timestamp): unpacking raw data\n"
paste <(awk 'NR%4==2' <(gzip -dc ${IN_FILE_R1})) <(awk 'NR%4==2' <(gzip -dc ${IN_FILE_R2})) > "${OUT_DIR}/data.fastq"
printf "$(timestamp): Input files extracted and 'data.fastq' written.\n"


# count lines in 'data_seq.fast'
printf "$(timestamp): counting lines in 'data.fastq'\n"
NUM_LINES=$(wc -l ${OUT_DIR}/data.fastq | awk '{print $1}')
printf "$(timestamp): Total number of reads in ${OUT_DIR}/data.fastq: ${NUM_LINES}\n" | tee -a "$LOGFILE"

# done!
printf "$(timestamp): done (t_${TASK})!\n"
