#!/bin/sh
cd /home/disk/eos4/rachel/NCL/cesm_scripts/Analysis/Plotting/scripts/

plotvar="divVbpfTbpf"
ilev="250"
min1="-12.0"
max1="12.0"
diffs1="2.0"
min2="-2.0"
max2="2.0"
diffs2="0.4"
units="mKS:-1:N:"
plottype="map"


# save command line arguments to environment variable NCL_ARG_#
index=1
eval export NCL_ARG_$index=$plotvar
((index++))
eval export NCL_ARG_$index=$ilev
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
eval export NCL_ARG_$index=$plottype



ncl plot_generic.ncl
echo 'finished'

