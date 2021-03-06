#!/bin/sh
cd /home/disk/eos4/rachel/NCL/cesm_scripts/Analysis/Plotting/scripts/
export NCLnumvars="2"
export NCLdifexps="0"
export NCLexpdif="0"
export NCLfigtit="RvsT"
export NCLdir1="/home/disk/rachel/CESM_outfiles/"
export NCLnumexps="2"
export NCLlinear="false"
export NCLclon="0.0"
export NCLslon="-180.0"
export NCLelon="0."
export NCLslat="0.0"
export NCLelat="90.0"
export NCLplottype="map"
export NCLplotctl="1"
export NCLplotERA1="0"
export NCLplotERA2="0"
export NCLtitleprefix="Rockies_"

exps1=("CESMtopof19" "CESMnoRf19" "CESMnoRT2f19")
titles1=("R_CTL" "R_noRockies" "R_noRockiesTibet")
CTLS=("100" "0" "0" "0" "0" "0" "2" "2")
starts=("2" "2" "2" "2" "2" "11" "11" "11")
nyears=("40" "40" "40" "40")
timespan=("DJF" "DJF" "DJF" "DJF" "DJF" "DJF" "DJF" "DJF")
reverse=("true" "false" "false" "false" "false" "false" "true" "true")

export NCLallblue=0
export NCLplottitles=1
export NCLblock=0

#export NCLplotvar_1="Topo"
#export NCLilev_1="0"
#export NCLvartitle_1="Topo"
#export NCLmin1_1="0"
#export NCLmax1_1="2000"
#export NCLdiffs1_1="200"
#export NCLmin2_1="-5.5"
#export NCLmax2_1="5.5"
#export NCLdiffs2_1="1.0"
#export NCLunits_1="m"
#
export NCLplotvar_1="TS"
export NCLilev_1="0"
export NCLvartitle_1="Surface\ Temp"
export NCLmin1_1="250"
export NCLmax1_1="305"
export NCLdiffs1_1="5"
export NCLmin2_1="-2.5"
export NCLmax2_1="2.5"
export NCLdiffs2_1="0.5"
export NCLunits_1="K"

export NCLplotvar_2="PREC"
export NCLilev_2="0"
export NCLvartitle_2="DJF Precip"
export NCLmin1_2="0"
export NCLmax1_2="8.0"
export NCLdiffs1_2="1.0"
export NCLmin2_2="-2."
export NCLmax2_2="2."
export NCLdiffs2_2="0.4"
export NCLunits_2="mm/day"



#export NCLplotvar_2="PV"
#export NCLilev_2="300"
#export NCLvartitle_2="~F10~PV~F21~"
#export NCLmin1_2="0.0"
#export NCLmax1_2="3.6e-6"
#export NCLdiffs1_2="0.4e-6"
#export NCLmin2_2="-0.9e-6"
#export NCLmax2_2="0.9e-6"
#export NCLdiffs2_2="0.2e-6"
#export NCLunits_2="PVU"

#export NCLplotvar_1="SFZA"
#export NCLilev_1="850"
#export NCLvartitle_1="~F8~y'~F21~"
#export NCLmin1_1="-0.9e7"
#export NCLmax1_1="0.9e7"
#export NCLdiffs1_1="2.0e6"
#export NCLmin2_1="-0.675e7"
#export NCLmax2_1="0.675e7"
#export NCLdiffs2_1="1.5e6"
#export NCLunits_1="m~S~2~N~s~S~-1~N~"
#
#export NCLplotvar_2="TH"
#export NCLilev_2="850.0"
#export NCLvartitle_2="~F8~q~F21~"
#export NCLmin1_2="265.0"
#export NCLmax1_2="310.0"
#export NCLdiffs1_2="5.0"
#export NCLmin2_2="-3.6"
#export NCLmax2_2="3.6"
#export NCLdiffs2_2="0.8"
#export NCLunits_2="K"

#export NCLplotvar_1="U"
#export NCLilev_1="250"
#export NCLvartitle_1="~F10~u~F21~"
#export NCLmin1_1="-12.0"
#export NCLmax1_1="60.0"
#export NCLdiffs1_1="8.0"
#export NCLmin2_1="-13.5"
#export NCLmax2_1="13.5"
#export NCLdiffs2_1="3.0"
#export NCLunits_1="m~S~-1~N~"
#
#export NCLplotvar_2="Zvar"
#export NCLilev_2="850.0"
#export NCLvartitle_2="~F10~Z~F21~'~S~2~N~~F21~"
#export NCLmin1_2="250"
#export NCLmax1_2="2500"
#export NCLdiffs1_2="250"
#export NCLmin2_2="-450"
#export NCLmax2_2="450"
#export NCLdiffs2_2="100"
#export NCLunits_2="m~S~2~N~"

#export NCLplotvar_1="PREC"
#export NCLilev_1="0"
#export NCLvartitle_1="DJF Precip"
#export NCLmin1_1="0"
#export NCLmax1_1="13.5"
#export NCLdiffs1_1="1.5"
#export NCLmin2_1="-0.9"
#export NCLmax2_1="0.9"
#export NCLdiffs2_1="0.2"
#export NCLunits_1="mm/day"
#
#export NCLplotvar_2="TdiaSRF"
#export NCLilev_2="0"
#export NCLvartitle_2="DJF LH + SH + LW + SW"
#export NCLmin1_2="-200"
#export NCLmax1_2="200"
#export NCLdiffs1_2="40"
#export NCLmin2_2="-90"
#export NCLmax2_2="90"
#export NCLdiffs2_2="20"
#export NCLunits_2="W/m~S~2~N~"



# save command line arguments to environment variable NCL_ARG_#
count=0
for ((index=1; index<=$NCLnumexps; index++))
do
	eval export NCLexps1_$index=${exps1[count]}
	eval export NCLtitles1_$index=${titles1[count]}
	eval export NCLCTLs1_$index=${CTLS[count]}
	eval export NCLstarts1_$index=${starts[count]}
	eval export NCLnyears1_$index=${nyears[count]}
  	eval export NCLtimespans1_$index=${timespan[count]}
  	eval export NCLreverses1_$index=${reverse[count]}

 	((count++))
done




ncl scripts/plot_generic2.ncl


