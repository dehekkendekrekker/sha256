`include "./src/verilog/MOD_XOR32.v"

module MOD_SIGMA1(
    input [0:31] A,
    output [0:31] Y
);

    wire [0:31] XOR_1;

    MOD_XOR32 xor_1({A[26:31], A[0:25]}, {A[21:31], A[0:20]}, XOR_1);
    MOD_XOR32 xor_2(XOR_1, {A[7:31], A[0:6]}, Y);
endmodule
