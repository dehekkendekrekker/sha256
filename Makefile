
memmgr: ./src/verilog/MOD_MEMMGR.v ./scripts/yosys/memmgr.ys ./lib/7400.v
	# Compile with verilog
	iverilog -g2012 ./src/verilog/MOD_MEMMGR.v -o ./build/MOD_MEMMGR.vpp

	# Synthesize with yosys
	yosys -s ./scripts/yosys/memmgr.ys 

	# Convert to netlist
	# cd ./build	&& mknl --input ./$@.json --output ./$@


%: ./src/verilog/%.v ./tests/%_TB.v
	@mkdir -p ./build/
	@iverilog -g2012 ./src/verilog/$@.v ./lib/macros.v ./tests/$@_TB.v -o ./build/$@.vpp
	@./build/$@.vpp

test: $(wildcard ./src/verilog/*.v)
	@for f in $(notdir $(basename $^)); do make --no-print-directory $$f; done
	



clean:
	@rm -rf ./build/