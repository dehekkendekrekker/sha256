module MOD_SIGMA0(
    input [0:31] A,
    output [0:31] Y
);

assign Y = {A[30:31], A[0:29]} ^ {A[19:31], A[0:18]} ^ {A[10:31], A[0:9]};

endmodule
