#!/bin/bash

YEL='\033[1;33m' # Yellow
NC='\033[0m' # No Color
declare -x rows cols koef piece_max kbits_max

update_size(){
  rows=$(tput lines) # get actual lines of term
  cols=$(tput cols)  # get actual columns of term
  piece_max=$(( (cols-44)*2 ))
  koef=$((kbits_max/piece_max))
  [[ ${koef} -eq 0  ]] && koef=1
  pbidx=$((kbits_max/koef))
  foobarlen=$((pbidx/2))
  foobar=${pb:0:$foobarlen}
  printf "\n\n                            ${YEL}%s %d kbps${NC}\n" ${foobar} $kbits_max
}

trap update_size WINCH


# Alt+9608
# Alt+9612
pb='████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████'
lf='▌'
#\u2580 Alt+9600
#\u2584 Alt+9604
# ▄▀▀

kbits_max=$1
update_size

prev=0
curr=0

while [ 1 -gt 0 ]; do
  read curr
  [[ -z ${ddd} ]] &&  printf "\033\1H\033[1A                                                                                                 \r"
  ddd=` date +"%H:%M:%S"`
  bpsv=$(( 8*(curr-prev)/1024 ))
  kbits_limited=$(( bpsv > kbits_max ? kbits_max : bpsv ))
  pbidx=$((kbits_limited/koef))
  foobarlen=$((pbidx/2))
  foobar=${pb:0:$foobarlen}
  if [ $((pbidx%2)) -eq 1 ]; then
    foobar=$foobar'▌'
  fi
  if [ $((kbits_limited - kbits_max)) -eq 0 ]; then
    foobar=$foobar'+++'
  fi
  printf "%s  %6d kbit/sec   %s\n" $ddd $bpsv ${foobar}
  prev=$curr
done
