`include "./src/verilog/7400/MOD_74x393.v"
module MOD_COUNTER(CLK, RST, D);

input CLK;
input RST;
output reg [7:0] D;

MOD_74x393 ctr(CLK,RST, D[3],RST, D[3:0], D[7:4]);

endmodule