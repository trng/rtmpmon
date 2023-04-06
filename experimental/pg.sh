#!/bin/bash

res=`echo "6000 464" | awk '{printf "%.7f \n", $1/$2}'`
echo "${res} 12" | awk '{printf "%.7f \n", $1/$2}'


