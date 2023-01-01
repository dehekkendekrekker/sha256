`include "./src/verilog/MOD_W_MEM.v"
`include "./src/verilog/MOD_SIGMA0.v"
`include "./src/verilog/MOD_SIGMA1.v"
`include "./src/verilog/MOD_CHOICE.v"
`include "./src/verilog/MOD_MAJORITY.v"

`ifndef MOD_COMPRESSOR
`define MOD_COMPRESSOR
module MOD_COMPRESSOR(CLK, RESET, I, W_IN, K, 
H0_IN,H1_IN,H2_IN,H3_IN,H4_IN,H5_IN,H6_IN,H7_IN,
a,b,c,d,e,f,g,h
);

input CLK, RESET;
input [5:0] I;
input [31:0] K, W_IN;
input [31:0] H0_IN,H1_IN,H2_IN,H3_IN,H4_IN,H5_IN,H6_IN,H7_IN;
output reg [31:0] a,b,c,d,e,f,g,h;

MOD_W_MEM w_mem(CLK, I, W_IN, W_OUT, RDY);
MOD_SIGMA0 SIGMA0(a, s0);
MOD_SIGMA1 SIGMA1(e, s1);
MOD_CHOICE choice(e,f,g,ch);
MOD_MAJORITY majority(a,b,c,maj);

reg [31:0] W_OUT;

reg [31:0] t1,t2;
reg [31:0] s0, s1, ch, maj;
reg RDY;

// Assignment of temp regs
assign t1 = h + s1 + ch + K + W_OUT;
assign t2 = s0 + maj;

// Continuous assignment blocks
always @(negedge CLK) begin
    if (RESET) begin
        a = H0_IN;
        b = H1_IN;
        c = H2_IN;
        d = H3_IN;
        e = H4_IN;
        f = H5_IN;
        g = H6_IN;
        h = H7_IN;
    end
end

// Shift registers
always @(posedge RDY) begin
    h <= g;
    g <= f;
    f <= e;
    e <= d + t1;
    d <= c;
    c <= b;
    b <= a;
    a <= t1 + t2;
end





endmodule
`endif