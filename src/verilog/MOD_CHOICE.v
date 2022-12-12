`include "./src/verilog/MOD_XOR32.v"
`include "./src/verilog/MOD_AND32.v"
`include "./src/verilog/MOD_NOT32.v"

module MOD_CHOICE(
    input [0:31] E,
    input [0:31] F,
    input [0:31] G,
    output [0:31] Y
);

wire [0:31] AND_1;
wire [0:31] AND_2;
wire [0:31] NOT_E;
MOD_AND32 and_1(E,F,AND_1);
MOD_NOT32 not_e(E, NOT_E);
MOD_AND32 and_2(NOT_E, G, AND_2);
MOD_XOR32 xor_1(AND_1, AND_2, Y);



    
endmodule
