#!/bin/bash
self_ip='192.168.88.23'
self_port='1935'
kbits_max=6000
tmpfile="/tmp/rtmpmontcpdumpfilter.tmp"
YEL='\033[1;33m' # Yellow
NC='\033[0m' # No Color

echo -e "***\n***${YEL}  RTMP live stream monitor v.1.0${NC}\n***"

if [[ $# -gt 0  ]]; then
  strtest=${1//[0-9]/}
  [[ -z ${strtest} ]] && kbits_max=$1
else
  echo -e "***  Usage:"
  echo -e "***    rtmpmon bandwidth(kbits)"
  echo -e "***    Bandwidth used for scaling graphics only."
  echo -e "***    Values exceeded bandwidth will be graphically trucuated and marked with '+++'"
  echo -e "***    Default bandwidth ${kbits_max}"
  echo -e "***  \n***  Example:"
  echo -e "***    rtmpmon"
  echo -e "***    rtmpmon 10000"
fi

printf "\n\n${YEL}Looking for rtmp streams. Please wait...${NC}\r"
printf  "dst host ${self_ip} and dst port ${self_port} " > ${tmpfile}
rtmp_avail=`timeout 3 tcpdump -nnn -c 1 -i eth0 -F ${tmpfile} 2>/dev/null | awk {'print $3'}`

if [ -z "${rtmp_avail}" ]; then
  echo "There are no active incoming rtmp streams. Nothing to monitor"
  exit
fi

idx=1
echo -e "Active incoming rtmp streams (source ip/source port):"
while [ -n "${rtmp_avail}" ]
do
  founded_ip=${rtmp_avail%.*}
  founded_port=${rtmp_avail##*.}
  printf "$idx. %16s       %8d                     \n" ${founded_ip} ${founded_port}
  ipaddr[$idx]=${founded_ip}
  tcpport[$idx]=${founded_port}
  idx=$((idx+1))
  printf " and not (src port ${founded_port} and src host ${founded_ip})" >> ${tmpfile}
  printf "${YEL}Lookin for next stream. Please wait...${NC}\r"
  rtmp_avail=`timeout 2 tcpdump -nnn -c 1 -i eth0 -F ${tmpfile} 2>/dev/null | awk '{print $3}'`
done

echo "                                                          "
printf "Please select stream to monitor: "
userchoice=0
while read -N 1 -n 1 -s userchoice ; do
  #if [[ ${userchoice} -gt 0 && ${userchoice} -lt ${idx} ]] ; then
  if [[ -z ${userchoice//[1-9]/} && ${userchoice} -lt ${idx} ]] ; then
     break
  fi
done

echo "$userchoice"
echo -e "\n\nStart to monitor source     ${YEL}${ipaddr[$userchoice]}:${tcpport[$userchoice]}${NC}"
echo "dst host ${self_ip} and dst port ${self_port} and src port ${tcpport[$userchoice]} and src host ${ipaddr[$userchoice]}" > ${tmpfile}

tcpdump -nnn -i eth0 -F ${tmpfile} -w - | pv -fbn 2>&1>/dev/null | $(dirname $(realpath $0))/bps.sh $kbits_max
