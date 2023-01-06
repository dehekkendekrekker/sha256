// 74x393 Dual 4-bit ripple counter
(* blackbox *)
`ifndef MOD_74x393
`define MOD_74x393
module MOD_74x393 (
    input CLK1,
    input CLR1,
    input CLK2,
    input CLR2,
    output reg [3:0] Q1,
    output reg [3:0] Q2
);

initial begin
  Q1 = 0;
  Q2 = 0;
end

always @(posedge CLR1) begin
    Q1 = 0;
end

always @(posedge CLR2) begin
    Q1 = 0;
end

always @(negedge CLK1) begin
    if (CLR1)
        Q1 <= 0;
    else 
        Q1 <= Q1 + 1;
end

always @(negedge CLK2) begin
    if (CLR2)
        Q2 <= 0;
    else 
        Q2 <= Q2 + 1;
end

endmodule
`endif