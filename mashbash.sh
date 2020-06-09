#!/bin/bash

help="still under construction" 

if [ $# -eq 0 ]; then
  echo $help
fi

command -v $1 >/dev/null 2>&1 || { echo >&2 -e "$red[-]$norm $1 not found. Aborting."; exit 1; }
$1
