#!/bin/sh

_term() { 
  kill -TERM "$child" 2>/dev/null
  exit 3
}

_run() {
  $@ &
  child=$!
  wait "$child"
}

trap _term SIGTERM

ARGS=$@
if [ -n "${IPERF_SERVER}" ]
then
  ARGS="-s ${ARGS}"
elif [ -n "${IPERF_HOST}" ]
then
  ARGS="-c ${IPERF_HOST} ${ARGS}"
else
  ARGS="-c iperf-server ${ARGS}"
fi

while :
do
  _run iperf3 ${ARGS}
  RET=$?
  if [ "${RET}" != "0" ]
  then
    echo "iperf3 error - exiting"
    exit 1
  fi
  if [ -n "${IPERF_ONCE}" ]
  then
    echo "Set to once mode - exiting"
    exit 0
  fi
  _run sleep 60
done
