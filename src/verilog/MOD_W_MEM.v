
/**

Here's how this should work:

There are 16 banks of memory (w) that hold 32 bit values each.
These banks represent a sliding window of W mem, so W[0..15]

There is one extra bank (E) that serves as a buffer from which W memory W is updated and loaded.

There exists a counter C that counts from 0 to 64 (i).
Each tick, E is loaded with W[i]. The value present in E is pushed down to w(16)
w(16) is pushed down to w(15) ... to w(0).

For i > 15, the W magic is performed, as w(0..15) is fully loaded. The result is placed in E.

For the time being, E is placed in W[i] until we figure out how to integrate the compression function

*/

`include "./src/verilog/MOD_S0.v"
`include "./src/verilog/MOD_S1.v"
module MOD_W_MEM(CLK, I, D_IN, D_OUT, RDY);

input            CLK;
input      [5:0] I ; // W Mem index
input      [31:0] D_IN; // Data bus IN
output reg [31:0] D_OUT; // Data OUT
output reg RDY; // Ready indicator

MOD_S0 sigma0 (w1, s0);
MOD_S1 sigma1 (w14, s1);

reg [31:0] w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15;
reg [31:0] s0,s1;

initial begin
    RDY = 0;
end


always @(posedge CLK) begin
    RDY <= 0;
end

always @(negedge CLK) begin
    if (I < 16)
        D_OUT = D_IN;
    else 
        D_OUT = w0 + s0 + w9 + s1;
    
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

    RDY <= 1;
end



endmodule