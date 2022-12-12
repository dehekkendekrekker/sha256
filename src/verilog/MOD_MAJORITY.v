`include "./src/verilog/MOD_XOR32.v"
`include "./src/verilog/MOD_AND32.v"

module MOD_MAJORITY(
    input [0:31] A,
    input [0:31] B,
    input [0:31] C,
    output [0:31] Y
);

wire [0:31] AND_1;
wire [0:31] AND_2;
wire [0:31] AND_3;
wire [0:31] XOR_1;


MOD_AND32 and_1(A, B, AND_1);
MOD_AND32 and_2(A, C, AND_2);
MOD_AND32 and_3(B, C, AND_3);
MOD_XOR32 xor_1(AND_1, AND_2, XOR_1);
MOD_XOR32 xor_2(XOR_1, AND_3, Y);
    
endmodule
