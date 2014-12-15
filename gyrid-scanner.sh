#!/bin/bash

clear

# configure log path

LOGPATH="logs"

# set the log files

DETECTIONLOG="${LOGPATH}/`date +%Y%m%d`.detection.log"
DEVICELOG="${LOGPATH}/`date +%Y%m%d`.device.log"
SCRIPTLOG="${LOGPATH}/gyrid.log"

# remember when the script started

START=`date +%H:%M:%S`

echo "${START} GYRID Bluetooth scanner started" >> ${SCRIPTLOG}

# create log path if it doesn't exist

if [ ! -d ${LOGPATH} ]
then 
  mkdir ${LOGPATH}
  echo "${START} Log path ${LOGPATH} created" >> ${SCRIPTLOG}
else
  echo "${START} Log path ${LOGPATH} exists" >> ${SCRIPTLOG}
fi

# create log files if they doesn't exist

if [ ! -e ${DETECTIONLOG} ]
then
  touch ${DETECTIONLOG}
  echo -e "[\n]" >> ${DETECTIONLOG}
  echo "${START} Detection log ${DETECTIONLOG} created" >> ${SCRIPTLOG}
else
  echo "${START} Detection log ${DETECTIONLOG} exists" >> ${SCRIPTLOG}
fi

if [ ! -e ${DEVICELOG} ]
then
  touch ${DEVICELOG}
  echo -e "[\n]" >> ${DEVICELOG}
  echo "${START} Device log ${DEVICELOG} created" >> ${SCRIPTLOG}
else
  echo "${START} Device log ${DEVICELOG} exists" >> ${SCRIPTLOG}
fi

if [ ! -e ${SCRIPTLOG} ]
then
  touch ${SCRIPTLOG}
  echo "${START} Script log ${SCRIPTLOG} created" >> ${SCRIPTLOG}
else
  echo "${START} Script log ${SCRIPTLOG} exists" >> ${SCRIPTLOG}
fi

# set up integers

declare -i DETECTIONS
declare -i DEVICES

# scan

while [ 1 ] 
do

  # find out how many detections have been made so far

  DETECTIONS=`wc -l ${DETECTIONLOG} | awk '{print $1}'`
  DETECTIONS=DETECTIONS-2 # do not count opening and closing braces

  DEVICES=`wc -l ${DEVICELOG} | awk '{print $1}'`
  DEVICES=DEVICES-2 # do not count opening and closing braces

  # remember when the scan started

  TIME=`date +%H:%M:%S`

  echo "${TIME} Scan started" >> ${SCRIPTLOG}
  echo "${TIME} ${DEVICES} devices in ${DETECTIONS} detections" >> ${SCRIPTLOG}

  # update the screen

  clear
  echo "                                                                BLUETOOTH SCANNER"
  echo "================================================================================="
  echo -e "Time\t\tMAC\t\t\tDevice name"
  echo "---------------------------------------------------------------------------------"
  cat ${DEVICELOG}
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

      echo "${TIME} Device ${ADDR} detected with name ${NAME}" >> ${SCRIPTLOG}

      # update the detections log by inserting new data before the closing bracket

      sed -i "s/\]$/,{\"time\":\"${TIME}\",\"address\":\"${ADDR}\"}\n\]/" ${DETECTIONLOG}
      sed -i "2s/,{/{/" ${DETECTIONLOG}

      # update the devices log by inserting new data before the closing bracket

      if ! grep -q "${ADDR}" "${DEVICELOG}"
      then 
        sed -i "s/\]$/,{\"address\":\"${TIME}\":\"name\":\"${ADDR}\"}\n\]/" ${DEVICELOG}
        sed -i "s/,{/{/" ${DEVICELOG}
      fi

    fi

  done

done
