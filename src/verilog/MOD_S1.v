module MOD_S1(
    input [0:31] A,
    output [0:31] Y
);

    assign Y = {A[15:31], A[0:14]} ^  {A[13:31], A[0:12]} ^ {10'b0000000000, A[0:21]};

    
endmodule
