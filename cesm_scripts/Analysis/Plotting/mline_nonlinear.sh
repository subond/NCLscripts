#!/bin/sh
cd ./scripts/
difvars="0"
expdif="0"
figtit="Paper"
dir1="/home/disk/rachel/CESM_outfiles/"
numexps="7"
exps1=("CESMnotopof19" "CESM_IG39_HMer" "CESM_onlyIT2" "CESM_IG39_HZon" "CESM_onlyITSh" "CESM_IG39_West" "CESM_onlyITVS")
titles1=("I_CTL" "I_48N_MerHalf" "I_48N_4km" "I_48N_ZonHalf" "I_48N_2km" "I_48N_West" "I_48N_1km")
start1="2"
end1="31"
start2="2"
end2="31"
timespan="DJF"
reverse="true"
linear="false"
clon="180.0"
slon="30.0"
elon="360.0"
slat=("50.0" "50.0" "50.0" "50.0" "50.0" "50.0" "50.0")
elat=("55.0" "55.0" "55.0" "55.0" "55.0" "55.0" "55.0")
plottype="MMline"
plotctl=0
plotERA=0
titleprefix="LatAvg2"


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

eval export NCL_ARG2_$index=$dir1
((index++))
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
count=0
limit=$((index+numexps-1))
for ((index=$index; index<=$limit; index++))
do
  eval export NCL_ARG2_$index=${slat[count]}
  ((count++))
done
count=0
limit=$((index+numexps-1))
for ((index=$index; index<=$limit; index++))
do
  eval export NCL_ARG2_$index=${elat[count]}
  ((count++))
done
eval export NCL_ARG2_$index=$plottype
((index++))
eval export NCL_ARG2_$index=$plotctl
((index++))
eval export NCL_ARG2_$index=$plotERA
((index++))
eval export NCL_ARG2_$index=$titleprefix


ncl plot_generic_MMline_paper.ncl



