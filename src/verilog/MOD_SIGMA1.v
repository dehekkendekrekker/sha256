module MOD_SIGMA1(
    input [0:31] A,
    output [0:31] Y
);

assign Y = {A[26:31], A[0:25]} ^ {A[21:31], A[0:20]} ^ {A[7:31], A[0:6]};

endmodule
