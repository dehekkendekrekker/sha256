`ifndef MOD_SIGMA1
`define MOD_SIGMA1
module MOD_SIGMA1(
    input [31:0] A,
    output [31:0] Y
);

assign Y =  {A[5:0], A[31:6]} ^ {A[10:0], A[31:11]} ^ {A[24:0], A[31:25]};

endmodule
`endif