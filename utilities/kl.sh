#!/bin/bash
# Connect to test-kitchen docker
# This script is not mine. I find it somewhere and just adapted.

if [ ! -d ".kitchen" ]; then
  echo "There is no .kitchen dir in this directory. Wrong path?"
  exit 1
fi

NUM=`kitchen list | grep $1 | wc -l`

if [ $NUM -ne '1' ]; then
  echo "The machine name does not resolve to only 1 image. Please specify more."
  exit 1
fi

expect -c "spawn kitchen login $1; expect \"ssword: \"; send -- \"kitchen\r\"; interact"
