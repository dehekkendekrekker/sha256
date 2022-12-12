`include "./src/verilog/MOD_XOR32.v"

module MOD_S0(
    input [0:31] A,
    output [0:31] Y
);

    wire [0:31] XOR_1;

    MOD_XOR32 xor_1({A[25:31], A[0:24]}, {A[14:31], A[0:13]}, XOR_1);
    MOD_XOR32 xor_2(XOR_1, {3'b000, A[0:28]}, Y);
endmodule
