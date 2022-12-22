#!/bin/bash 
mkdir -p ./build/

function test () {
	# Run unit test
	iverilog -g2012 ./src/verilog/$1.v ./lib/macros.v ./tests/"$1"_TB.v -o ./build/$1.vpp
	./build/$1.vpp
}

if [ -n "$1" ]
then
    test $1
else
    files=$(find ./src/verilog/ -maxdepth 1 -name *.v)
    for file in $files 
    do
        base=$(basename $file .v)
        test $base
    done
fi
  
