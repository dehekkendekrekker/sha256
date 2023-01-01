`ifndef MOD_SIGMA0
`define MOD_SIGMA0
module MOD_SIGMA0(
    input [31:0] A,
    output [31:0] Y
);

assign Y =  {A[1:0],  A[31:2]} ^ {A[12:0], A[31:13]} ^ {A[21:0], A[31:22]};

endmodule
`endif