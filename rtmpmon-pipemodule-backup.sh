#!/bin/bash

YEL='\033[1;33m' # Yellow
NC='\033[0m' # No Color
declare -x rows cols koef piece_max kbits_max

update_size(){
  rows=$(tput lines) # get actual lines of term
  cols=$(tput cols)  # get actual columns of term
  onepage=$rows
  piece_max=$(( (cols-44)*2 ))
  [[ ${piece_max} -le 0 ]] && piece_max=1

  #koef=$((kbits_max/piece_max))
  koef=`echo "${kbits_max} ${piece_max}" | awk '{printf "%.7f \n", $1/$2}'`

  koef_tmp=`printf "%.0f" ${koef}`
  [[ ${koef_tmp} -eq 0 ]] && koef=1000

  #pbidx=$((kbits_max/koef))
  pbidx=`echo "${kbits_max} ${koef}" | awk '{printf "%.0f \n", $1/$2}'`



  foobarlen=$((pbidx/2))
  foobar=${pb:0:$foobarlen}
  printf "\n\n${YEL}--TIME--    --BANDWIDTH--   %s %d kbps${NC}\n" ${foobar} $kbits_max
  echo "cols $cols      piece_max $piece_max       koef $koef       pbidx $pbidx      foobarlen $foobarlen"
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
  if (( onepage <= 1 )); then
    update_size
  fi
  onepage=$((onepage-1))
  read curr
  [[ -z ${ddd} ]] &&  printf "\033\1H\033[1A                                                                                                 \r"
  ddd=` date +"%H:%M:%S"`

  bpsv=$(( 8*(curr-prev)/1024 ))
  #bpsv=`echo "${kbits_max}" | awk '{printf "%.7f \n", $1/$2}'`

  kbits_limited=$(( bpsv > kbits_max ? kbits_max : bpsv ))

  #pbidx=$((kbits_limited/koef))
  pbidx=`echo "${kbits_limited} ${koef}" | awk '{printf "%.0f \n", $1/$2}'`

  foobarlen=$((pbidx/2))
  foobar=${pb:0:$foobarlen}
  if [ $((pbidx%2)) -eq 1 ]; then
    foobar=$foobar'▌'
  fi
  if [ $((kbits_limited - kbits_max)) -eq 0 ]; then
    foobar=$foobar'+++'
  fi
  printf "%s %2d %4d kbit/sec   %s\n" $ddd $onepage $bpsv ${foobar}
  prev=$curr
done
