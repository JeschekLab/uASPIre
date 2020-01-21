#!/bin/bash

###############################################################################
# uASPIRE                                                                     #
# Check BC and discriminator for NGS raw data analysis                        #
# Simon Höllerer, ETH Zürich, D-BSSE, BPL, Basel, Switzerland                 #
# E-mail: simon.hoellerer@bsse.ethz.ch                                        #
# Authors: Simon Höllerer and Laetitia Papaxanthos                            #
# Date: November, 2019                                                        #
###############################################################################

# DESCRIPTION: This script writes the first 12 bases of the forward and reverse
# read into a new file and subsequently checks in each section if the defined
# barcodes are present or not. The resulting indices serve as the selection
# criterion for the next python script.

# import config (necesarry for BC list)
source "${CONFIG}"


# get task number from main script
TASK=$1


# print statement
printf "$(timestamp): start script (t_${TASK})\n"


# This section is unfortunately necessary since 'agrep' cannot search in one
# column or in certain positions, but only in whole lines/records.
# write first 12 bases of forward and reverse read into file
printf "$(timestamp): write first 12 bases of R1 and R2 (t_${TASK})\n"
awk '{print substr($1,1,12)}' "${OUT_PATH}/data_QC_C_${TASK}.tmp" > "${OUT_PATH}/data_QC_C_R1-1-12_${TASK}.tmp"
awk '{print substr($2,1,12)}' "${OUT_PATH}/data_QC_C_${TASK}.tmp" > "${OUT_PATH}/data_QC_C_R2-1-12_${TASK}.tmp"


# write all barcode positions into new files
printf "$(timestamp): print all barcode positions (t_${TASK})\n"
# TO-DO: better going through length of barcodes! Laetitia added this once
awk '{print substr($1,2,6)}' "${OUT_PATH}/data_QC_C_R1-1-12_${TASK}.tmp" > "${OUT_PATH}/data_QC_C_R1-2-6_${TASK}.tmp"
awk '{print substr($1,3,6)}' "${OUT_PATH}/data_QC_C_R1-1-12_${TASK}.tmp" > "${OUT_PATH}/data_QC_C_R1-3-6_${TASK}.tmp"
awk '{print substr($1,4,6)}' "${OUT_PATH}/data_QC_C_R1-1-12_${TASK}.tmp" > "${OUT_PATH}/data_QC_C_R1-4-6_${TASK}.tmp"
awk '{print substr($1,5,6)}' "${OUT_PATH}/data_QC_C_R1-1-12_${TASK}.tmp" > "${OUT_PATH}/data_QC_C_R1-5-6_${TASK}.tmp"
awk '{print substr($1,6,6)}' "${OUT_PATH}/data_QC_C_R1-1-12_${TASK}.tmp" > "${OUT_PATH}/data_QC_C_R1-6-6_${TASK}.tmp"
awk '{print substr($1,7,6)}' "${OUT_PATH}/data_QC_C_R1-1-12_${TASK}.tmp" > "${OUT_PATH}/data_QC_C_R1-7-6_${TASK}.tmp"

awk '{print substr($1,2,6)}' "${OUT_PATH}/data_QC_C_R2-1-12_${TASK}.tmp" > "${OUT_PATH}/data_QC_C_R2-2-6_${TASK}.tmp"
awk '{print substr($1,3,6)}' "${OUT_PATH}/data_QC_C_R2-1-12_${TASK}.tmp" > "${OUT_PATH}/data_QC_C_R2-3-6_${TASK}.tmp"
awk '{print substr($1,4,6)}' "${OUT_PATH}/data_QC_C_R2-1-12_${TASK}.tmp" > "${OUT_PATH}/data_QC_C_R2-4-6_${TASK}.tmp"
awk '{print substr($1,5,6)}' "${OUT_PATH}/data_QC_C_R2-1-12_${TASK}.tmp" > "${OUT_PATH}/data_QC_C_R2-5-6_${TASK}.tmp"
awk '{print substr($1,6,6)}' "${OUT_PATH}/data_QC_C_R2-1-12_${TASK}.tmp" > "${OUT_PATH}/data_QC_C_R2-6-6_${TASK}.tmp"
awk '{print substr($1,7,6)}' "${OUT_PATH}/data_QC_C_R2-1-12_${TASK}.tmp" > "${OUT_PATH}/data_QC_C_R2-7-6_${TASK}.tmp"


# search all lines with barcodes in position file with agrep and write indices
printf "$(timestamp): search for lines with barcodes in position file (t_${TASK})\n"
# TO-DO: better going through length of barcodes! Laetitia added this once
${AGREP} -${MM_BC} -u -n -V0 -D1 -I1 ${BARCODES_L[0]} "${OUT_PATH}/data_QC_C_R1-2-6_${TASK}.tmp" > "${OUT_PATH}/data_BC_L1_${TASK}.tmp"
${AGREP} -${MM_BC} -u -n -V0 -D1 -I1 ${BARCODES_L[1]} "${OUT_PATH}/data_QC_C_R1-3-6_${TASK}.tmp" > "${OUT_PATH}/data_BC_L2_${TASK}.tmp"
${AGREP} -${MM_BC} -u -n -V0 -D1 -I1 ${BARCODES_L[2]} "${OUT_PATH}/data_QC_C_R1-4-6_${TASK}.tmp" > "${OUT_PATH}/data_BC_L3_${TASK}.tmp"
${AGREP} -${MM_BC} -u -n -V0 -D1 -I1 ${BARCODES_L[3]} "${OUT_PATH}/data_QC_C_R1-5-6_${TASK}.tmp" > "${OUT_PATH}/data_BC_L4_${TASK}.tmp"
${AGREP} -${MM_BC} -u -n -V0 -D1 -I1 ${BARCODES_L[4]} "${OUT_PATH}/data_QC_C_R1-6-6_${TASK}.tmp" > "${OUT_PATH}/data_BC_L5_${TASK}.tmp"
${AGREP} -${MM_BC} -u -n -V0 -D1 -I1 ${BARCODES_L[5]} "${OUT_PATH}/data_QC_C_R1-7-6_${TASK}.tmp" > "${OUT_PATH}/data_BC_L6_${TASK}.tmp"

${AGREP} -${MM_BC} -u -n -V0 -D1 -I1 ${BARCODES_R[0]} "${OUT_PATH}/data_QC_C_R2-2-6_${TASK}.tmp" > "${OUT_PATH}/data_BC_R1_${TASK}.tmp"
${AGREP} -${MM_BC} -u -n -V0 -D1 -I1 ${BARCODES_R[1]} "${OUT_PATH}/data_QC_C_R2-3-6_${TASK}.tmp" > "${OUT_PATH}/data_BC_R2_${TASK}.tmp"
${AGREP} -${MM_BC} -u -n -V0 -D1 -I1 ${BARCODES_R[2]} "${OUT_PATH}/data_QC_C_R2-4-6_${TASK}.tmp" > "${OUT_PATH}/data_BC_R3_${TASK}.tmp"
${AGREP} -${MM_BC} -u -n -V0 -D1 -I1 ${BARCODES_R[3]} "${OUT_PATH}/data_QC_C_R2-5-6_${TASK}.tmp" > "${OUT_PATH}/data_BC_R4_${TASK}.tmp"
${AGREP} -${MM_BC} -u -n -V0 -D1 -I1 ${BARCODES_R[4]} "${OUT_PATH}/data_QC_C_R2-6-6_${TASK}.tmp" > "${OUT_PATH}/data_BC_R5_${TASK}.tmp"
${AGREP} -${MM_BC} -u -n -V0 -D1 -I1 ${BARCODES_R[5]} "${OUT_PATH}/data_QC_C_R2-7-6_${TASK}.tmp" > "${OUT_PATH}/data_BC_R6_${TASK}.tmp"


# remove colons in index file
# left barcodes
printf "$(timestamp): remove colons in forward read (t_${TASK})\n"
for i in {1..6}; do
  tr -d \: < "${OUT_PATH}/data_BC_L${i}_${TASK}.tmp" > "${OUT_PATH}/data_BC_L${i}_idx_${TASK}.tmp" # could be piped
done

# right barcodes
printf "$(timestamp): remove colons in reverse read (t_${TASK})\n"
for i in {1..6}; do
  tr -d \: < "${OUT_PATH}/data_BC_R${i}_${TASK}.tmp" > "${OUT_PATH}/data_BC_R${i}_idx_${TASK}.tmp" # could be piped
done


# determine flipped and non-flipped
# write last 24 bases of the forward read to new file
printf "$(timestamp): write last 24 bases of the forward read to new file (t_${TASK})\n" # <------------------- needs to be changed depending on read length (put in config!!!)
awk '{print substr($1,13,'$LAST')}' "${OUT_PATH}/data_QC_C_${TASK}.tmp" > "${OUT_PATH}/data_QC_C_R1-13-24_${TASK}.tmp" # <------------------- needs to be changed depending on read length (put in config!!!)

# search for non-flipped and flipped sequences
printf "$(timestamp): search for non-flipped and flipped sequences (t_${TASK})\n"
${AGREP} -${MM_NF} -u -n -V0 -D1 -I1 ${SEQ_NF} "${OUT_PATH}/data_QC_C_R1-13-24_${TASK}.tmp" > "${OUT_PATH}/data_nf_${TASK}.tmp"
${AGREP} -${MM_FF} -u -n -V0 -D1 -I1 ${SEQ_FF} "${OUT_PATH}/data_QC_C_R1-13-24_${TASK}.tmp" > "${OUT_PATH}/data_ff_${TASK}.tmp"


# remove colons in index file
printf "$(timestamp): remove colons (t_${TASK})\n"
tr -d \: < "${OUT_PATH}/data_nf_${TASK}.tmp" > "${OUT_PATH}/data_nf_idx_${TASK}.tmp"
tr -d \: < "${OUT_PATH}/data_ff_${TASK}.tmp" > "${OUT_PATH}/data_ff_idx_${TASK}.tmp"


# done!
printf "$(timestamp): done (t_${TASK})!\n"
