%: ./src/verilog/%.v ./tests/%_TB.v ./scripts/yosys/%.ys
	

	# Compile with verilog
	iverilog -g2012 ./src/verilog/$@.v -o ./build/$@.vpp

	# Synthesize with yosys
	yosys -s ./scripts/yosys/$@.ys 

	# Convert to netlist
	# cd ./build	&& mknl --input ./$@.json --output ./$@

	# Run unit test
	@mkdir -p ./build/
	@iverilog -g2012 ./src/verilog/$@.v ./lib/macros.v ./tests/$@_TB.v -o ./build/$@.vpp
	@./build/$@.vpp


test: $(wildcard ./src/verilog/*.v)
	@for f in $(notdir $(basename $^)); do make --no-print-directory $$f; done
	



clean:
	@rm -rf ./build/