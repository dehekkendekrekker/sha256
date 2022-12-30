module MOD_S0(
    input [31:0] A,
    output [31:0] Y
);

assign Y  = {A[6:0], A[31:7]} ^{A[17:0], A[31:18]} ^ {3'b000,   A[31:3]};

endmodule
