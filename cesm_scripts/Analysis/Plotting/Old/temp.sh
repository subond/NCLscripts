#!/bin/sh
cd /home/disk/eos4/rachel/NCL/cesm_scripts/Analysis/Plotting/scripts/
difvars="1"
expdif="0"
figtit="Paper"
numexps="6"
dir1="/home/disk/rachel/CESM_outfiles/"
exps1=("CESMnotopof19" "CESM_IG54" "CESM_IG49" "CESM_IG44" "CESM_IG34" "CESM_IG29")
titles1=("I\_CTL" "I\_63N\_2km" "I\_58N\_2km" "I\_53N\_2km" "I\_43N\_2km" "I\_38N\_2km")
CTLS=("-1" "0" "0" "0" "0" "0" "0" "2")
starts=("2" "2" "2" "2" "2" "2" "2" "11")
nyears=("30" "30" "30" "30" "30" "30" "30" "30")
timespan=("DJF" "DJF" "DJF" "DJF" "DJF" "DJF" "DJF" "DJF")
reverse=("true" "true" "true" "true" "true" "true" "true" "true")
linear="false"
clon="180.0"
slon="30.0"
elon="300."
slat="-30.0"
elat="90.0"
plottype="map"
plotctl=0
plotERA=0
titleprefix="I3_"


# save command line arguments to environment variable NCL_ARG_#
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

count=0
limit=$((index+numexps-1))
for ((index=$index; index<=$limit; index++))
do
  eval export NCL_ARG2_$index=${CTLS[count]}
  ((count++))
done
count=0
limit=$((index+numexps-1))
for ((index=$index; index<=$limit; index++))
do
  eval export NCL_ARG2_$index=${starts[count]}
  ((count++))
done
count=0
limit=$((index+numexps-1))
for ((index=$index; index<=$limit; index++))
do
  eval export NCL_ARG2_$index=${nyears[count]}
  ((count++))
done
count=0
limit=$((index+numexps-1))
for ((index=$index; index<=$limit; index++))
do
  eval export NCL_ARG2_$index=${timespan[count]}
  ((count++))
done
count=0
limit=$((index+numexps-1))
for ((index=$index; index<=$limit; index++))
do
  eval export NCL_ARG2_$index=${reverse[count]}
  ((count++))
done
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

plotvar="U"
ilev="850"
vartitle="~F10~U~F21~"
min1="-12.0"
max1="60.0"
diffs1="8.0"
min2="-4.5"
max2="4.5"
diffs2="1.0"
units="ms~S~-1~N~"

index=1
eval export NCL_ARG_$index=$plotvar
((index++))
eval export NCL_ARG_$index=$ilev
((index++))
eval export NCL_ARG_$index=$vartitle
((index++))
eval export NCL_ARG_$index=$min1
((index++))
eval export NCL_ARG_$index=$max1
((index++))
eval export NCL_ARG_$index=$diffs1
((index++))
eval export NCL_ARG_$index=$min2
((index++))
eval export NCL_ARG_$index=$max2
((index++))
eval export NCL_ARG_$index=$diffs2
((index++))
eval export NCL_ARG_$index=$units
((index++))
plotvar="Zvar"
vartitle="~F10~Z~F21~\'~S~2~N~~F21~"
ilev="850"
min1="250.0"
max1="2500.0"
diffs1="250.0"
min2="-675.0"
max2="675.0"
diffs2="150.0"
units="m~S~2~N~"

# save command line arguments to environment variable NCL_ARG_#
eval export NCL_ARG_$index=$plotvar
((index++))
eval export NCL_ARG_$index=$ilev
((index++))
eval export NCL_ARG_$index=$vartitle
((index++))
eval export NCL_ARG_$index=$min1
((index++))
eval export NCL_ARG_$index=$max1
((index++))
eval export NCL_ARG_$index=$diffs1
((index++))
eval export NCL_ARG_$index=$min2
((index++))
eval export NCL_ARG_$index=$max2
((index++))
eval export NCL_ARG_$index=$diffs2
((index++))
eval export NCL_ARG_$index=$units


ncl plot_generic.ncl


