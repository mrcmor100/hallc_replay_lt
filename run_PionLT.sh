#! /bin/bash

# Stephen JD Kay - University of Regina - 27/08/21
# Arguments should be run number, type of run and target type
# Anything but the valid options should be ignored and bounced back to the user as a prompt
# Stephen JD Kay - University of Regina 25/02/22
# I've edited this script to remove the requirement to run on a cdaq machine, it should work OK as anyone

REPLAYPATH="/group/c-pionlt/USERS/${USER}/hallc_replay_lt" # Edit as needed!
echo ""
echo "Running in ${REPLAYPATH}"
echo ""
UTILPATH="${REPLAYPATH}/UTIL_PION"
cd $REPLAYPATH
echo ""
echo "Starting physics analysis of PionLT data"
echo "Required arguments are run number, run type and target"
echo ""
echo "Run number must be a positive integer value"
echo "Run type must be one of - Prod - Lumi - HeePSing - HeePCoin - fADC - Optics - Case sensitive!"
echo "Target must be one of - LH2 - LD2 - Dummy10cm - Carbon0p5 - AuFoil - Optics1 - Optics2 - CarbonHole - Case sensitive!"
RUNNUMBER=$1
RUNTYPE=$2
TARGET=$3
# Need to change these a little, should check whether arguments are good or not REGARDLESS of whether they're blank
if [[ -z "$1" || ! "$RUNNUMBER" =~ ^-?[0-9]+$ ]]; then # Check an argument was provided and that it is a positive integer, if not, prompt for one
    echo ""
    echo "I need a valid run number - MUST be a positive integer"
    while true; do
	echo ""
	read -p "Please type in a run number (positive integer) as input or press ctrl-c to exit : " RUNNUMBER
	case $RUNNUMBER in
	    '' | *[!0-9]*);; # If the input is NOT a positive integer (or it's just an empty string), don't break the loop
	    *) break;;
	esac
    done
fi
if [[ -z "$2" || ! "$RUNTYPE" =~ Prod|Lumi|HeePSing|HeePCoin|fADC|Optics ]]; then # Check the 2nd argument was provided and that it's one of the valid options
    echo ""
    echo "I need a valid run type"
    while true; do
	echo ""
	read -p "Please type in a run type from - Prod - Lumi - HeePSing - HeePCoin - fADC - Optics - Case sensitive! - or press ctrl-c to exit : " RUNTYPE
	case $RUNTYPE in
	    '');; # If blank, prompt again
	    'Prod'|'Lumi'|'HeePSing'|'HeePCoin'|'Optics'|'fADC') break;; # If a valid option, break the loop and continue
	esac
    done
fi
if [[ -z "$3" || ! "$TARGET" =~ LH2|LD2|Dummy10cm|Carbon0p5|AuFoil|Optics1|Optics2|CarbonHole ]]; then # Check the 3rd argument was provided and that it's one of the valid options
    echo ""
    echo "I need a valid target"
    while true; do	
	echo ""
	read -p "Please type in a target from - LH2 - LD2 - Dummy10cm - Carbon0p5 - AuFoil - Optics1 - Optics2 - CarbonHole - Case sensitive! - or press ctrl-c to exit : " TARGET
	case $TARGET in
	    '');; # If blank, prompt again
	    'LH2'|'LD2'|'Dummy10cm'|'Carbon0p5'|'AuFoil'|'Optics1'|'Optics2'|'CarbonHole') break;; # If a valid option, break the loop and continue
	esac
    done
fi

if [[ $RUNTYPE == "Prod" ]]; then
    echo "Running production analysis script - ${UTILPATH}/scripts/online_physics/PionLT/pion_prod_replay_analysis_sw.sh"
    eval '"${UTILPATH}/scripts/online_physics/PionLT/pion_prod_replay_analysis_sw.sh" ${RUNNUMBER} ${TARGET}' # NH 19/01/22 - Target now an optional argument for production analysis, sets MM range
elif [[ $RUNTYPE == "Lumi" ]]; then
    echo "Running luminosity analysis script - ${UTILPATH}/scripts/luminosity/replay_lumi.sh"
    eval '"${UTILPATH}/scripts/luminosity/replay_lumi.sh" ${RUNNUMBER}'
elif [[ $RUNTYPE == "HeePSing" ]]; then
    echo "Running HeeP Singles analysis script - ${UTILPATH}/scripts/heep/sing_heepYield.sh"
    eval '"${UTILPATH}/scripts/heep/sing_heepYield.sh" hms ${RUNNUMBER}'
    eval '"${UTILPATH}/scripts/heep/sing_heepYield.sh" shms ${RUNNUMBER}'
elif [[ $RUNTYPE == "HeePCoin" ]]; then
    echo "Running HeeP Coin analysis script - ${UTILPATH}/scripts/heep/coin_heepYield.sh"
    eval '"${UTILPATH}/scripts/heep/coin_heepYield.sh" ${RUNNUMBER}'
elif [[ $RUNTYPE == "fADC" ]]; then
    echo "Running fADC Coin analysis script - ${UTILPATH}/scripts/fADC_SIDIS/fADC_Analysis.sh"
    eval '"${UTILPATH}/scripts/fADC_SIDIS/fADC_Analysis.sh" ${RUNNUMBER}'
elif [[ $RUNTYPE == "Optics" ]]; then
    echo "Running optics analysis script - "
    eval '"${UTILPATH}/scripts/optics/run_optics.sh" ${RUNNUMBER}'
fi
if [[ $RUNTYPE != "Optics" ]]; then
    eval '"${UTILPATH}/scripts/runlist/fill_runList.sh" ${RUNNUMBER} ${RUNTYPE} ${TARGET}'
else echo "Full replay for HMS and SHMS completed, check output rootfiles for plots"
fi
