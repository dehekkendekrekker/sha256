#!/bin/bash 
mkdir -p ./build/

function synth () {
	# Synthesize with yosys
	yosys -s ./scripts/yosys/$1.ys 

	# Convert to netlist
	# cd ./build	&& mknl --input ./$@.json --output ./$@ --chipset ../lib/chipset.json
}

if [ -n "$1" ]
then
    synth $1
else
    files=$(find ./src/verilog/ -maxdepth 1 -name *.v)
    for file in $files 
    do
        base=$(basename $file .v)
        synth $base
    done
fi
