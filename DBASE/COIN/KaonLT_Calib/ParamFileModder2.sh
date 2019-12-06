#!/bin/bash

### Stephen Kay --- University of Regina --- 15/11/19 ###
### Lazy boy script to go through and modify the parameter files that will be examined ###
### Reads in a list of run numbers from a text file ###
inputFile="$1"

while IFS='' read -r line || [[ -n "$line" ]]; do
    ##Run number#                                                         
    runNum=$line
    sed -i "s/hcal_$runNum.param/hcal_8476.param/" "Offline"$runNum".param"
done < "$inputFile"
