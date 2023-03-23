#!/bin/bash

# Alt+9608
# Alt+9612
pb[0]=''
pb[1]='▌'
pb[2]='█'
pb[3]='█▌'
pb[4]='██'
pb[5]='██▌'
pb[6]='███'
pb[7]='███▌'
pb[8]='████'
pb[9]='████▌'
pb[10]='█████'
pb[11]='█████▌'
pb[12]='██████'
pb[13]='██████▌'
pb[14]='███████'
pb[15]='███████▌'
pb[16]='████████'
pb[17]='████████▌'
pb[18]='█████████'
pb[19]='█████████▌'
pb[20]='██████████'
pb[21]='██████████▌'
pb[22]='███████████'
pb[23]='███████████▌'
pb[24]='████████████'
pb[25]='████████████▌'
pb[26]='█████████████'
pb[27]='█████████████▌'
pb[28]='██████████████'
pb[29]='██████████████▌'
pb[30]='███████████████'
pb[31]='███████████████▌'
pb[32]='████████████████'
pb[33]='████████████████▌'
pb[34]='█████████████████'
pb[35]='█████████████████▌'
pb[36]='██████████████████'
pb[37]='██████████████████▌'
pb[38]='███████████████████'
pb[39]='███████████████████▌'
pb[40]='████████████████████'
pb[41]='████████████████████▌'
pb[42]='█████████████████████'
pb[43]='█████████████████████▌'
pb[44]='██████████████████████'
pb[45]='██████████████████████▌'
pb[46]='███████████████████████'
pb[47]='███████████████████████▌'
pb[48]='████████████████████████'
pb[49]='████████████████████████▌'
pb[50]='█████████████████████████'
pb[51]='█████████████████████████▌'
pb[52]='██████████████████████████'
pb[53]='██████████████████████████▌'
pb[54]='███████████████████████████'
pb[55]='███████████████████████████▌'
pb[56]='████████████████████████████'
pb[57]='████████████████████████████▌'
pb[58]='█████████████████████████████'
pb[59]='█████████████████████████████▌'
pb[60]='██████████████████████████████'
pb[61]='██████████████████████████████▌'
pb[62]='███████████████████████████████'
pb[63]='███████████████████████████████▌'
pb[64]='████████████████████████████████'
pb[65]='████████████████████████████████▌'
pb[66]='█████████████████████████████████'
pb[67]='█████████████████████████████████▌'
pb[68]='██████████████████████████████████'
pb[69]='██████████████████████████████████▌'
pb[70]='███████████████████████████████████'
pb[71]='███████████████████████████████████▌'
pb[72]='████████████████████████████████████'
pb[73]='████████████████████████████████████▌'
pb[74]='█████████████████████████████████████'
pb[75]='█████████████████████████████████████▌'
pb[76]='██████████████████████████████████████'
pb[77]='██████████████████████████████████████▌'
pb[78]='███████████████████████████████████████'
pb[79]='███████████████████████████████████████▌'
pb[80]='████████████████████████████████████████'
pb[81]='████████████████████████████████████████▌'
pb[82]='█████████████████████████████████████████'
pb[83]='█████████████████████████████████████████▌'
pb[84]='██████████████████████████████████████████'
pb[85]='██████████████████████████████████████████▌'
pb[86]='███████████████████████████████████████████'
pb[87]='███████████████████████████████████████████▌'
pb[88]='████████████████████████████████████████████'
pb[89]='████████████████████████████████████████████▌'
pb[90]='█████████████████████████████████████████████'
pb[91]='█████████████████████████████████████████████▌'
pb[92]='██████████████████████████████████████████████'
pb[93]='██████████████████████████████████████████████▌'
pb[94]='███████████████████████████████████████████████'
pb[95]='███████████████████████████████████████████████▌'
pb[96]='████████████████████████████████████████████████'
pb[97]='████████████████████████████████████████████████▌'
pb[98]='█████████████████████████████████████████████████'
pb[99]='█████████████████████████████████████████████████▌'
pb[100]='█████████████████████████████████████████████████▌!!!'

#for percentbar in {0..999..10}
#do
#  echo -e "${pb[$((percentbar/10))]}"
#done

prev=0
curr=0
while [ 1 -gt 0 ]; do

  read curr
  ddd=` date +"%H:%M:%S"`
  # echo "$ddd  $(( 8*(curr-prev)/1024 )) kbits per second"
  bpsv=$(( 8*(curr-prev)/1024 ))
  pbi=$((bpsv/30))
  pbi=$(( pbi > 99 ? 100 : pbi ))
  printf "%s  %6d kbits per second  %4d  %s\n" $ddd $bpsv $pbi ${pb[pbi]}
  prev=$curr

done
