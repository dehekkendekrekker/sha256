#!/usr/bin/python3

# Python 3.6 required minimum

from argparse import ArgumentParser
from pathlib import Path, PurePath
import re
from typing import final
from loguru import logger # pip install loguru

mapping = {
    "MOD_74x08_4" : {"extract_order": 1},
    "MOD_74x08_3" : {"extract_order": 2},
    "MOD_74x08_2" : {"extract_order": 3},
    "MOD_74x08_1" : {"extract_order": 4},
    "MOD_74x32_4" : {"extract_order": 1},
    "MOD_74x32_3" : {"extract_order": 2},
    "MOD_74x32_2" : {"extract_order": 3},
    "MOD_74x32_1" : {"extract_order": 4},
    "MOD_74x86_4" : {"extract_order": 1},
    "MOD_74x86_3" : {"extract_order": 2},
    "MOD_74x86_2" : {"extract_order": 3},
    "MOD_74x86_1" : {"extract_order": 4},
}

main_template = "[EXT_ORDER]\n[MODULE]\n\n"
ext_ord_template = "(* extract_order = %s *)"
re_mod_matcher = r"module (.*) "

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
        module = module_file.read()
        appendix = main_template
        matches = re.findall(re_mod_matcher, module, re.M)
        if not matches:
            logger.error("Could not extract module name. Check either regexp or module")
            quit()
        module_name = matches[0]

        # Assign extract_order to module if necessary
        if module_name in mapping:
            extract_order = mapping[module_name]["extract_order"]
            logger.info("- Assigning extract order {} to {}", extract_order, module_name)
            appendix = appendix.replace("[EXT_ORDER]", ext_ord_template % extract_order)
        else:
            appendix = appendix.replace("[EXT_ORDER]", "")

        # Add module to appendix
        appendix = appendix.replace("[MODULE]", module)

        output_file.write(appendix)
            

        # quit()











