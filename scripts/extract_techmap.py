#!/usr/bin/python3

# Python 3.6 required minimum

from argparse import ArgumentParser
from pathlib import Path, PurePath
import re
from typing import final
from loguru import logger # pip install loguru

parser = ArgumentParser(description="Converts verilog file in input directory to one single output file that can be used by yosys")
parser.add_argument("-i", type=str, dest="input", required=True)
parser.add_argument("-o", type=str, dest="output", required=True)
args = parser.parse_args()

input_path = Path(args.input)
if not input_path.exists() or not input_path.is_dir():
    logger.error("Input path {} does not exist or is not a directory", input_path)
    quit()

output_path = Path(args.output)

try:
    output_file = output_path.open('w')
except PermissionError:
    logger.error("Output path {} is not writable", output_path)
    quit()

# Create list of all .v files
x : PurePath
verilog_files = [x for x in input_path.iterdir() if x.suffix == ".v"] 
verilog_files = sorted(verilog_files)

for file in verilog_files:
    logger.info("Processing {}", file)
    with file.open("r") as module_file:
        module = module_file.read() + "\n"
        output_file.write(module)











