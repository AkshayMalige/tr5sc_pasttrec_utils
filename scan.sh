#!/bin/bash

#. ../profile.sh

#trbids="0x6440 0x6441 0x6442 0x6443 0x6444 0x6445 0x6450 0x6451 0x6452 0x6453 0x6454 0x6455 0x6460 0x6461 0x6462 0x6463 0x6464:1,2 0x6465:1,2 0x6470 0x6471 0x6472 0x6473"
trbids="0x6500:1,2"

md=$(date "+%Y%m%d_%H%M%S")

mkdir -p $md

# scan each card separately
# set all thresholds to max
asic_threshold.py ${trbids} -Vth 127 || exit
for addr in ${trbids}; do
    baseline_scan.py $addr -o ${md}/scan_${addr}.json -s multi -Vth 0 -K 0 -Tp 2 -TC1C 3 -TC1R 6 -TC2C 2 -TC2R 5 -t 0.1 --defaults || exit
    # reset threshold to max
    asic_threshold.py $addr -Vth 127 || exit
    baseline_calc.py ${md}/scan_${addr}.json -blo 0 -Vth 10 -g 3 -D ${md}/config_${addr}.dat
   # --exec
done

#cat ${md}/config_*.dat > config_sts_${md}.dat

