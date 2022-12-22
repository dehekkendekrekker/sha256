module MOD_S0(
    input [0:31] A,
    output [0:31] Y
);

assign Y = {A[25:31], A[0:24]} ^ {A[14:31], A[0:13]} ^ {3'b000, A[0:28]};

endmodule
