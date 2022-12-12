`include "./src/verilog/MOD_XOR32.v"

module MOD_S1(
    input [0:31] A,
    output [0:31] Y
);

    wire [0:31] XOR_1;

    // assign Y = {A[15:31], A[0:14]};
    MOD_XOR32 xor_1({A[15:31], A[0:14]}, {A[13:31], A[0:12]}, XOR_1);
    MOD_XOR32 xor_2(XOR_1, {10'b0000000000, A[0:21]}, Y);
endmodule
