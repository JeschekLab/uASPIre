#!/bin/bash

###############################################################################
# uASPIRE                                                                     #
# Concatenate files for NGS raw data analysis                                 #
# Simon Höllerer, ETH Zürich, D-BSSE, BPL, Basel, Switzerland                 #
# E-mail: simon.hoellerer@bsse.ethz.ch                                        #
# Authors: Simon Höllerer and Laetitia Papaxanthos                            #
# Date: November, 2019                                                        #
###############################################################################

# DESCRIPTION: This bash script takes the for the next step necessary files
# that were created in the parallel tasks and concatenates them into one.


# import config
source "${CONFIG}"


# write non-flipped reads
# iterate through all samples
for count in $(eval echo "{1..$SAMPLES_NUMBER}"); do
  # remove concatenated file if it exists
  rm -f "${OUT_PATH}/RBS_S${count}_nf_all.tmp"
  # interate through all parallel tasks
  for task_number in $(eval echo "{01..$PARALLEL_TASKS}"); do
    # append each file to the previous (or empty) file
    printf "$(timestamp): writing RBS_S${count}_nf_${task_number}\n"
    cat "${OUT_PATH}/RBS_S${count}_nf_${task_number}.tmp" >> "${OUT_PATH}/RBS_S${count}_nf_all.tmp"
  done
done


# write flipped reads
# iterate through all samples
for count in $(eval echo "{1..$SAMPLES_NUMBER}"); do
  # remove concatenated file if it exists
  rm -f "${OUT_PATH}/RBS_S${count}_ff_all.tmp"
  # interate through all parallel tasks
  for task_number in $(eval echo "{01..$PARALLEL_TASKS}"); do
    # append each file to the previous (or empty) file
    printf "$(timestamp): writing RBS_S${count}_ff_${task_number}\n"
    cat "${OUT_PATH}/RBS_S${count}_ff_${task_number}.tmp" >> "${OUT_PATH}/RBS_S${count}_ff_all.tmp"
  done
done


# count non-flipped reads
for sample in $(eval echo "{1..$SAMPLES_NUMBER}"); do
  printf "$(timestamp): Counting lines in RBS_S${sample}_nf_all\n"
  NUM_LINES=$(wc -l ${OUT_PATH}/RBS_S${sample}_nf_all.tmp | awk '{print $1}')
  printf "$(timestamp): Total number of non-flipped reads in sample\t${sample}:\t${NUM_LINES}\n" | tee -a "${LOGFILE}"
done


# count flipped reads
for sample in $(eval echo "{1..$SAMPLES_NUMBER}"); do
  printf "$(timestamp): Counting lines in RBS_S${sample}_ff_all\n"
  NUM_LINES=$(wc -l ${OUT_PATH}/RBS_S${sample}_ff_all.tmp | awk '{print $1}')
  printf "$(timestamp): Total number of flipped reads in sample\t${sample}:\t${NUM_LINES}\n" | tee -a "${LOGFILE}"
done


# done!
printf "$(timestamp): done!\n"
