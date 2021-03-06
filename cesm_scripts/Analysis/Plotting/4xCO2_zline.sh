#!/bin/sh
cd ./scripts/
difvars="0"
expdif="0"
figtit="Paper"
dir1="/home/disk/rachel/CESM_outfiles/"
numexps="2"
exps1=("CAM4SOM4_4xCO2" "CAM4SOM4_4xCO2_noMT") #("CAM4SOM4_4xCO2" "CAM4SOM4_4xCO2_noMT") ("CAM4SOM4topo" "CAM4SOM4_noMT") 
titles1=("4xCO2_CTL" "4xCO2_noMT") # ("PD_CTL" "PD_noMT")
start1="11"
end1="40"
timespan="DJF"
reverse="false"
linear="false"
clon="180.0"
slon="140.0"
elon="170.0"
slat="20.0"
elat="70.0"
plottype="ZMline"
plotctl=1
plotERA=0
titleprefix="4xCO2_4x_" #"4xCO2_PD_"

y save command line arguments to environment variable NCL_ARG_#
index=1
export NCL_ARG2_$index=$difvars
((index++))
export NCL_ARG2_$index=$expdif
((index++))
export NCL_ARG2_$index=$figtit
((index++))
export NCL_ARG2_$index=$numexps
((index++))
eval export NCL_ARG2_$index=$dir1
((index++))
# save command line arguments to environment variable NCL_ARG_#
count=0
limit=$((index+numexps-1))
for ((index=$index; index<=$limit; index++))
do
  eval export NCL_ARG2_$index=${exps1[count]}
  ((count++))
done
count=0
limit=$((index+numexps-1))
for ((index=$index; index<=$limit; index++))
do
  eval export NCL_ARG2_$index=${titles1[count]}
  ((count++))
done

eval export NCL_ARG2_$index=$start1
((index++))
eval export NCL_ARG2_$index=$end1
((index++))
eval export NCL_ARG2_$index=$timespan
((index++))
eval export NCL_ARG2_$index=$reverse
((index++))
eval export NCL_ARG2_$index=$linear
((index++))
eval export NCL_ARG2_$index=$clon
((index++))
eval export NCL_ARG2_$index=$slon
((index++))
eval export NCL_ARG2_$index=$elon
((index++))
eval export NCL_ARG2_$index=$slat
((index++))
eval export NCL_ARG2_$index=$elat
((index++))
eval export NCL_ARG2_$index=$plottype
((index++))
eval export NCL_ARG2_$index=$plotctl
((index++))
eval export NCL_ARG2_$index=$plotERA
((index++))
eval export NCL_ARG2_$index=$titleprefix



ncl plot_generic_ZMline_paper_4xCO2.ncl



