`include "./src/verilog/MOD_XOR32.v"

module MOD_SIGMA0(
    input [0:31] A,
    output [0:31] Y
);

    wire [0:31] XOR_1;

    MOD_XOR32 xor_1({A[30:31], A[0:29]}, {A[19:31], A[0:18]}, XOR_1);
    MOD_XOR32 xor_2(XOR_1, {A[10:31], A[0:9]}, Y);
endmodule
