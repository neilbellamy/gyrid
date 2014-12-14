#!/bin/bash

# configure log path

LOGPATH="logs"

# set the log file

DETECTIONLOG="${LOGPATH}/`date +%Y%m%d`.detection.log"
DEVICELOG="${LOGPATH}/`date +%Y%m%d`.device.log"

# remember when the script started

START=`date +%H:%M:%S`

# create log path if it doesn't exist

if [ ! -d ${LOGPATH} ]
then 
  mkdir ${LOGPATH}
fi

# create log files if they doesn't exist

if [ ! -e ${DETECTIONLOG} ]
then
  touch ${DETECTIONLOG}
fi

if [ ! -e ${DEVICELOG} ]
then
  touch ${DEVICELOG}
fi

# scan

while [ 1 ] 
do

  # find out how many detections have been made so far

  DETECTIONS=`wc -l ${DETECTIONLOG} | awk '{print $1}'`
  DEVICES=`wc -l ${DEVICELOG} | awk '{print $1}'`

  # remember when the scan started

  TIME=`date +%H:%M:%S`

  # update the screen

  clear
  echo "                                                                BLUETOOTH SCANNER"
  echo "================================================================================="
  echo -e "Time\t\tMAC\t\t\tDevice name"
  echo "---------------------------------------------------------------------------------"
  cat ${LOG}
  echo "================================================================================="
  echo "${DETECTIONS} detections recorded in ${DETECTIONLOG}"
  echo "${DEVICES} devices recorded in ${DEVICELOG}"
  echo "Scanning every 10s since ${START}, last scan at ${TIME}"
  echo "                                                          Ctrl+C to stop scanning"

  # scan

  hcitool scan | while read DEVICE
  do

    # ignore the first line of hcitool's output

    if [ "${DEVICE}" != "Scanning ..." ]
    then

      # isolate the device address

      ADDR=$(echo "${DEVICE}" | awk '{print $1}')

      # isolate the device name

      NAME=$(echo "${DEVICE}" | sed "s/^.*${ADDR}\t//")

      # update the detections log

      echo -e "${TIME}\t${ADDR}" >> ${DETECTIONLOG}

      # update the devices log

      echo -e "${ADDR}\t${NAME}" >> ${DEVICELOG}

    fi

  done

done
