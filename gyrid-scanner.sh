#!/bin/bash

START=`date +%H:%M:%S`

while [ 1 ] 
do

  LOG="logs/`date +%Y%m%d`.log"
  TIME=`date +%H:%M:%S`
  DETECTIONS=`wc -l ${LOG} | awk '{print $1}'`

  clear
  echo "                                                                BLUETOOTH SCANNER"
  echo "================================================================================="
  echo -e "Time\t\tMAC\t\t\tDevice name"
  echo "---------------------------------------------------------------------------------"
  cat ${LOG}
  echo "================================================================================="
  echo "${DETECTIONS} detections recorded in ${LOG}"
  echo "Scanning every 10s since ${START}, last scan at ${TIME}"
  echo "                                                          Ctrl+C to stop scanning"

  hcitool scan | while read DEVICE
  do

    if [ "${DEVICE}" != "Scanning ..." ]
    then
      ADDR=$(echo "${DEVICE}" | awk '{print $1}')
      NAME=$(echo "${DEVICE}" | sed "s/^.*${ADDR}\t//")
      echo -e "${TIME}\t${ADDR}\t${NAME}" >> ${LOG}
    fi

  done

done
