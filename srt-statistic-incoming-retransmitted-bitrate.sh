#!/bin/bash

################################################
#
# User-defined parameters
# (SRT port can be specified in command line)
#
################################################

SELF_IP='95.67.110.165'
SRT_PORT=10002

################################################



YEL='\033[1;33m' # Yellow
NC='\033[0m'     # No Color

if [ -z "$1" ]; then
  echo -e "\n${YEL}No SRT port number is given in command line. Use default: $SRT_PORT ${NC}\n\n"
else
  re='^[0-9]+$'
  if ! [[ $1 =~ $re ]] ; then
    echo -e "\n${YEL}Wrong SRT port number in command line: Not a number ($1) ${NC}\n" >&2; exit 1
  fi
  SRT_PORT=$1
  echo -e "\n${YEL}SRT port number is given in command line. Use it: $SRT_PORT ${NC}\n\n"
fi

tcpdump -nnn -i eno2 udp and dst ${SELF_IP} and port ${SRT_PORT} and 'udp[12] & 0x04 = 0x04' | pv -bert > /dev/null
