#!/bin/bash

###############################################################################
# uASPIRE                                                                     #
# QC and constant for NGS raw data analysis                                   #
# Simon Höllerer, ETH Zürich, D-BSSE, BPL, Basel, Switzerland                 #
# E-mail: simon.hoellerer@bsse.ethz.ch                                        #
# Authors: Simon Höllerer and Laetitia Papaxanthos                            #
# Date: November, 2019                                                        #
###############################################################################

# DESCRIPTION: This script takes the the file with all reads ('data.fastq')
# and processes them according to the number of parallel tasks. If there are
# x parallel tasks, the script processes each x'th lines starting from line
# i = 1, ..., x. The script selects all lines with less than 6 consecutive Ns
# and writes them to a new file as first quality filter. The 17 bases starting
# from position 7 in the reverse read are also written to check for the
# constant region. Then, the indices of all lines with constant GAGCTCGCAT and
# its position in the read are written to a new file.


# import config
source "${CONFIG}"


# get task number from main script, which is the starting line
TASK=${1}
STARTING_LANE=${TASK}


# set starting line to 1 for last task (otherwise line 1 would be excluded)
if [ "$TASK" -eq "$PARALLEL_TASKS" ]; then
  STARTING_LANE=0
fi


# write all lines with less than 6 consecutive Ns in reverse read to new file
# as quality control
printf "$(timestamp): parallel copy <6 N in reverse read (t_${TASK})\n"
awk "NR%$PARALLEL_TASKS==$STARTING_LANE" "${OUT_DIR}/data.fastq" | awk '$2 !~ /NNNNNN/' > "${OUT_DIR}/data_QC_${TASK}.tmp"


# write only the reverse read to new file to get the RBS sequence
printf "$(timestamp): copy only 2nd column (t_${TASK})\n"
awk '{print $2}' "${OUT_DIR}/data_QC_${TASK}.tmp" > "${OUT_DIR}/data_R2_${TASK}.tmp"


# write first 17 bases starting on position 7 from reverse read to new file to
# check for the constant sequence
printf "$(timestamp): copy first bases in reverse read (t_${TASK})\n"
awk '{print substr($2,7,17)}' "${OUT_DIR}/data_QC_${TASK}.tmp" > "${OUT_DIR}/data_R2-7-17_${TASK}.tmp"


# write all lines with constant region to new file
printf "$(timestamp): get index of lines with constant region (t_${TASK})\n"
${TRE} -${MM_CONSTANT} -n --show-position ${SEQ_CONSTANT} "${OUT_DIR}/data_R2-7-17_${TASK}.tmp" > "${OUT_DIR}/data_R2-7-17_C-pos_${TASK}.tmp"


# count lines in 'data_R2-7-17_C-pos_${TASK}.tmp'
printf "$(timestamp): Counting lines (t_${TASK})\n"
NUM_LINES=$(wc -l "${OUT_DIR}/data_R2-7-17_C-pos_${TASK}.tmp" | awk '{print $1}')
printf "$(timestamp): Total number of reads with constant region in data_R2-7-17_C-pos_${TASK}.tmp: ${NUM_LINES}\n" | tee -a "${LOGFILE}"


# done!
printf "$(timestamp): done (t_${TASK})!\n"
