`ifndef MOD_MAJORITY
`define MOD_MAJORITY
module MOD_MAJORITY(
    input [0:31] A,
    input [0:31] B,
    input [0:31] C,
    output [0:31] Y
);

assign Y = (A & B) ^ (A & C) ^ (B & C);
    
endmodule
`endif