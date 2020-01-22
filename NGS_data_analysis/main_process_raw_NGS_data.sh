#!/bin/bash

###############################################################################
# uASPIRE                                                                     #
# Bash executable for NGS raw data analysis                                   #
# Simon Höllerer, ETH Zürich, D-BSSE, BPL, Basel, Switzerland                 #
# E-mail: simon.hoellerer@bsse.ethz.ch                                        #
# Authors: Simon Höllerer, Laetitia Papaxanthos, Anja Gumpinger               #
# Date: January, 2020                                                         #
###############################################################################

# DESCRIPTION: This script is the overall executable bash script that executes
# all other bash and python scripts in the process, tracks the time and writes
# all progress to the logfile. Parallelization is done by invocing the scripts
# several times on subsets of the unzipped raw data.

# Dependencies:
# - `agrep` availabe via e.g. https://github.com/Wikinaut/agrep
# - `tre-agrep` available via e.g. https://wiki.ubuntuusers.de/tre-agrep/
# - `python`


# import config
CONFIG=${1}
source "${CONFIG}"


# export config and config variables to environment
export CONFIG=${CONFIG}
set -a
. "${CONFIG}"
set +a


# create folders and check integrity
if [ ! -d "${OUT_DIR}" ]; then
  mkdir -p "${OUT_DIR}"
  if [ ! -d "${OUT_DIR}" ]; then
    printf "ERROR: output directory does not exist or cannot be created!\n"
    printf "Directory = ${OUT_DIR}\nExiting the script.\n"
    exit
  fi
  printf "Output directory successfully created. Continuing ...\n"
else
  printf "Output directory already exists. Continuing ...\n"
fi

if [ ! -d "${RESULT_DIR}" ]; then
  mkdir -p "${RESULT_DIR}"
  if [ ! -d "${RESULT_DIR}" ]; then
    printf "ERROR: output directory does not exist or cannot be created!\n"
    printf "Directory = ${RESULT_DIR}\nExiting the script.\n"
    exit
  fi
  printf "Result directory successfully created. Continuing ...\n"
else
  printf "Result directory already exists. Continuing ...\n"
fi

if [ ! -d "${LOG_DIR}" ]; then
  mkdir -p "${LOG_DIR}"
  if [ ! -d "${LOG_DIR}" ]; then
    printf "ERROR: output directory does not exist or cannot be created!\n"
    printf "Directory = ${LOG_DIR}\nExiting the script.\n"
    exit
  fi
  printf "Log directory successfully created. Continuing ...\n"
else
  printf "Log directory already exists. Continuing ...\n"
fi

# create a logfile with date and time and export it
NOW=$(date +"%F_%H-%M")
export LOGFILE="${LOG_DIR}/log-$NOW.log"
touch "${LOGFILE}"

# write header with parameters to log file
printf "%s\n" \
  "########################" \
  "Logfile of ${PROJECT_NAME}" \
  "########################" \
  "Date and time: $(timestamp)" \
  "Root path: ${ROOT_DIR}" \
  "Raw data file R1: ${IN_FILE_R1}" \
  "Raw data file R2: ${IN_FILE_R2}" \
  "Output path: ${OUT_DIR}" \
  "Result path: ${RESULT_DIR}" \
  "Name of logfile: ${LOGFILE}" \
  "Path to agrep executable: ${AGREP}" \
  "Path to tre-agrep executable: ${TRE}" \
  "Number of parallel tasks: ${PARALLEL_TASKS}" \
  "Number of time samples: ${SAMPLES_NUMBER}" \
  "########################" \
  "" >> "${LOGFILE}"

# time of overall script start
START_0=$(date +%s)



################################## script 0 ##################################
# print current script to STDOUT and logfile (same for all other scripts)
printf "$(timestamp): starting script ${SCRIPT_0} ...\n" | tee -a "${LOGFILE}"

# start time (same for all other scripts)
START=$(date +%s)

# execute script (same for all other scripts)
bash ${SCRIPT_0}

# end time (same for all other scripts)
END=$(date +%s)

# print runtime to STDOUT and logfile
printf "$(timestamp): script ${SCRIPT_0} successfully executed\n" | tee -a "${LOGFILE}"
printf $((END-START)) | awk '{printf "Script 0 runtime: %02d:%02d:%02d\n\n", int($1/3600), int($1/60)-int($1/3600)*60, int($1%60)}' | tee -a "${LOGFILE}"



################################## script 1 ##################################
printf "$(timestamp): starting script ${SCRIPT_1} ...\n" | tee -a "${LOGFILE}"
START=$(date +%s)

# execute script 1 for each parallel task and transfer task number
# all scripts run in parallel and wait for the last
for task in $(eval echo "{01..$PARALLEL_TASKS}"); do
  bash "${SCRIPT_1}" "${task}" &
done
wait

END=$(date +%s)
printf "$(timestamp): script ${SCRIPT_1} successfully executed\n" | tee -a "${LOGFILE}"
printf $((END-START)) | awk '{printf "Script 1 runtime: %02d:%02d:%02d\n\n", int($1/3600), int($1/60)-int($1/3600)*60, int($1%60)}' | tee -a "${LOGFILE}"



################################## script 2 ##################################
printf "$(timestamp): starting script ${SCRIPT_2} ...\n" | tee -a "${LOGFILE}"
START=$(date +%s)

for task in $(eval echo "{01..$PARALLEL_TASKS}"); do
  python "${SCRIPT_2}" "${task}" &
done
wait

END=$(date +%s)
printf "$(timestamp): script ${SCRIPT_2} successfully executed\n" | tee -a "${LOGFILE}"
printf $((END-START)) | awk '{printf "Script 2 runtime: %02d:%02d:%02d\n\n", int($1/3600), int($1/60)-int($1/3600)*60, int($1%60)}' | tee -a "${LOGFILE}"



################################## script 3 ##################################
printf "$(timestamp): starting script ${SCRIPT_3} ...\n" | tee -a "${LOGFILE}"
START=$(date +%s)

for task in $(eval echo "{01..$PARALLEL_TASKS}"); do
  bash "${SCRIPT_3}" "${task}" &
done
wait

END=$(date +%s)
printf "$(timestamp): script ${SCRIPT_3} successfully executed\n" | tee -a "${LOGFILE}"
printf $((END-START)) | awk '{printf "Script 3 runtime: %02d:%02d:%02d\n\n", int($1/3600), int($1/60)-int($1/3600)*60, int($1%60)}' | tee -a "${LOGFILE}"



################################## script 4 ##################################
printf "$(timestamp): starting script ${SCRIPT_4} ...\n" | tee -a "${LOGFILE}"
START=$(date +%s)

for task in $(eval echo "{01..$PARALLEL_TASKS}"); do
  python "${SCRIPT_4}" "${task}" &
done
wait

END=$(date +%s)
printf "$(timestamp): script ${SCRIPT_4} successfully executed\n" | tee -a "${LOGFILE}"
printf $((END-START)) | awk '{printf "Script 4 runtime: %02d:%02d:%02d\n\n", int($1/3600), int($1/60)-int($1/3600)*60, int($1%60)}' | tee -a "${LOGFILE}"



################################## script 5 ##################################
printf "$(timestamp): starting script ${SCRIPT_5} ...\n" | tee -a "${LOGFILE}"
START=$(date +%s)

for task in $(eval echo "{01..$PARALLEL_TASKS}"); do
  bash "${SCRIPT_5}" "${task}" &
done
wait

END=$(date +%s)
printf "$(timestamp): script ${SCRIPT_5} successfully executed\n" | tee -a "${LOGFILE}"
printf $((END-START)) | awk '{printf "Script 5 runtime: %02d:%02d:%02d\n\n", int($1/3600), int($1/60)-int($1/3600)*60, int($1%60)}' | tee -a "${LOGFILE}"



################################## script 6 ##################################
printf "$(timestamp): starting script ${SCRIPT_6} ...\n" | tee -a "${LOGFILE}"
START=$(date +%s)

bash "${SCRIPT_6}"

END=$(date +%s)
printf "$(timestamp): script ${SCRIPT_6} successfully executed\n" | tee -a "${LOGFILE}"
printf $((END-START)) | awk '{printf "Script 6 runtime: %02d:%02d:%02d\n\n", int($1/3600), int($1/60)-int($1/3600)*60, int($1%60)}' | tee -a "${LOGFILE}"



################################## script 7 ##################################
printf "$(timestamp): starting script ${SCRIPT_7} ...\n" | tee -a "${LOGFILE}"
START=$(date +%s)

python "${SCRIPT_7}"

END=$(date +%s)
printf "$(timestamp): script ${SCRIPT_7} successfully executed\n" | tee -a "${LOGFILE}"
printf $((END-START)) | awk '{printf "Script 7 runtime: %02d:%02d:%02d\n\n", int($1/3600), int($1/60)-int($1/3600)*60, int($1%60)}' | tee -a "${LOGFILE}"



############################# final time function #############################
# time of overall script end
END_0=$(date +%s)

# print total runtime
printf "########################\n" | tee -a "${LOGFILE}"
printf "Script successfully executed!\n" | tee -a "${LOGFILE}"
printf $((END_0-START_0)) | awk '{printf "Total runtime: %02d:%02d:%02d\n", int($1/3600), int($1/60)-int($1/3600)*60, int($1%60)}' | tee -a "${LOGFILE}"
printf "########################\n" | tee -a "${LOGFILE}"

# print end statement
printf "The End!\n"
