%: ./src/verilog/%.v ./tests/%_TB.v
	@mkdir -p ./build/
	@iverilog -g2012 ./src/verilog/$@.v ./lib/macros.v ./tests/$@_TB.v -o ./build/$@.vpp
	@./build/$@.vpp

all: $(wildcard ./src/verilog/*.v)
	@for f in $(notdir $(basename $^)); do make --no-print-directory $$f; done
	



clean:
	@rm -rf ./build/