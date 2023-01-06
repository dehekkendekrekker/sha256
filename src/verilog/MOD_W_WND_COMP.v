`include "./src/verilog/MOD_SIGMA0.v"
`include "./src/verilog/MOD_SIGMA1.v"
`include "./src/verilog/MOD_CHOICE.v"
`include "./src/verilog/MOD_MAJORITY.v"
`include "./src/verilog/MOD_S0.v"
`include "./src/verilog/MOD_S1.v"

`ifndef MOD_W_WND_COMP
`define MOD_W_WND_COMP
module MOD_W_WND_COMP(CLK, RESET, EN, I, D_IN, K, 
H0_IN,H1_IN,H2_IN,H3_IN,H4_IN,H5_IN,H6_IN,H7_IN,
a,b,c,d,e,f,g,h
);

input CLK, RESET, EN;
input      [5:0] I ; // W Mem index
input      [31:0] D_IN; // Data bus IN
input      [31:0] K; // Data bus IN
reg [31:0] D_OUT; // Data OUT
input [31:0] H0_IN,H1_IN,H2_IN,H3_IN,H4_IN,H5_IN,H6_IN,H7_IN;
output reg [31:0] a,b,c,d,e,f,g,h;

// Window related
MOD_S0 sigma0 (w1, s0);
MOD_S1 sigma1 (w14, s1);

// Compressor related
MOD_SIGMA0 SIGMA0(a, S0);
MOD_SIGMA1 SIGMA1(e, S1);
MOD_CHOICE choice(e,f,g,ch);
MOD_MAJORITY majority(a,b,c,maj);

reg [31:0] w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15;

reg [31:0] t1,t2;
reg [31:0] S0, S1;
reg [31:0] s0, s1, ch, maj;

// Assignment of temp regs
assign t1 = h + S1 + ch + K + D_OUT;
assign t2 = S0 + maj;

always @(posedge RESET) begin
    a <= H0_IN;
    b <= H1_IN;
    c <= H2_IN;
    d <= H3_IN;
    e <= H4_IN;
    f <= H5_IN;
    g <= H6_IN;
    h <= H7_IN;
end


always @(I) begin
    if (I < 16)
        D_OUT = D_IN;
    else 
        D_OUT = w0 + s0 + w9 + s1;

    // Move window down the message schedule
    w15 <= D_OUT;
    w14 <= w15;
    w13 <= w14;
    w12 <= w13;
    w11 <= w12;
    w10 <= w11;
    w9 <= w10;
    w8 <= w9;
    w7 <= w8;
    w6 <= w7;
    w5 <= w6;
    w4 <= w5;
    w3 <= w4;
    w2 <= w3;
    w1 <= w2;
    w0 <= w1;

    // Shift registers (compress)
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