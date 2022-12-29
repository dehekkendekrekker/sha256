
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

`include "./src/verilog/7400/MOD_74x393.v"
module MOD_W_MEM(CLK, I, D_IN, D_OUT);

input            CLK;
input      [5:0] I ; // W Mem index
input      [31:0] D_IN; // Data bus IN
output reg [31:0] D_OUT; // Data OUT

reg [31:0] w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15;
reg [31:0] s0,s1;

always @(negedge CLK) begin
    // $display("I: %d", I);
    if (I < 16)
        D_OUT = D_IN;
    else begin
        // Do that W magick!
        s0 = {w1[6 :0], w1[31:7]} ^
            {w1[17:0], w1[31:18]} ^
            {3'b000,   w1[31:3]};

        s1 = {w14[16:0],      w14[31:17]} ^
            {w14[18:0],      w14[31:19]} ^
            {10'b0000000000, w14[31:10]};


        D_OUT = w0 + s0 + w9 + s1;
        // $display("========= %d ========", I);
        // $display("w0[W%1d]:  %b", I-16, w0);
        // $display("w1[W%1d]:  %b", I+1-16, w1);
        // $display("w9[W%1d]:  %b", I+9-16, w9);
        // $display("w14[W%1d]: %b", I+14-16, w14);
        // $display("s0:        %b", s0);
        // $display("s1:        %b", s1);
        // $display("D[W%1d]:   %b", I, D_OUT);
    end

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

    // $display("=====================================");
    // $display("w0:  %b", w0);
    // $display("w1:  %b", w1);
    // $display("w2:  %b", w2);
    // $display("w3:  %b", w3);
    // $display("w4:  %b", w4);
    // $display("w5:  %b", w5);
    // $display("w6:  %b", w6);
    // $display("w7:  %b", w7);
    // $display("w8:  %b", w8);
    // $display("w9:  %b", w9);
    // $display("w10: %b", w10);
    // $display("w11: %b", w11);
    // $display("w12: %b", w12);
    // $display("w13: %b", w13);
    // $display("w14: %b", w14);
    // $display("w15: %b", w15);
    // $display("D_OUT: %b", D_OUT);
    
end



endmodule