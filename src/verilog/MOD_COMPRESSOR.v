`include "./src/verilog/MOD_W_MEM.v"
module MOD_COMPRESSOR(CLK, RESET, I, W_IN, K, 
H0_IN,H1_IN,H2_IN,H3_IN,H4_IN,H5_IN,H6_IN,H7_IN,
A,B,C,D,E,F,G,H
);

input CLK, RESET;
input [5:0] I;
input [31:0] K, W_IN, W_OUT;
input [31:0] H0_IN,H1_IN,H2_IN,H3_IN,H4_IN,H5_IN,H6_IN,H7_IN;
output reg [31:0] A,B,C,D,E,F,G,H;

MOD_W_MEM w_mem(CLK, I, W_IN, W_OUT, RDY);

reg INIT;
reg RDY;
reg [31:0] a,b,c,d,e,f,g,h,t1,t2;
reg [31:0] s0, s1, ch, maj;

// Continuous assignment blocks
always @(negedge CLK) begin
    if (RESET) begin
        a = H0_IN;
        b <= H1_IN;
        c <= H2_IN;
        d <= H3_IN;
        e <= H4_IN;
        f <= H5_IN;
        g <= H6_IN;
        h <= H7_IN;
    end
end

always @* begin
    s1 = {e[5:0], e[31:6]} ^ {e[10:0], e[31:11]} ^ {e[24:0], e[31:25]};
    ch = (e & f) ^ ((~e) & g);
    t1 = h + s1 + ch + K + W_OUT;
end

always @* begin
    s0 = {a[1:0], a[31:2]} ^ {a[12:0], a[31:13]} ^ {a[21:0], a[31:22]};
    maj = (a & b) ^ (a & c) ^ (b & c);
    t2 = s0 + maj;
end


// Shift registers
always @(posedge RDY) begin
    // $display("=== %d ===", I);
    // $display("a: %b",a);
    // $display("b: %b",b);
    // $display("c: %b",c);
    // $display("d: %b",d);
    // $display("e: %b",e);
    // $display("f: %b",f);
    // $display("g: %b",g);
    // $display("h: %b",h);
    // $display("=======");
    // $display("w: %b",W_OUT);
    // $display("k: %b",K);
    // $display("s1: %b",s1);
    // $display("ch: %b",ch);
    // $display("t1: %b",t1);
    // $display("t2: %b",t2);
    

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

