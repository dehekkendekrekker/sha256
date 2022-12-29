`include "./src/verilog/MOD_W_MEM.v"
module MOD_COMPRESSOR(HI, WI, H_IN, K_IN, H_OUT);

input [2:0] HI;
input [5:0] WI;
input [31:0] H_IN, K_IN;
output reg [31:0] H_OUT;


MOD_W_MEM w_mem(WI, D_IN, D_OUT);

reg [31:0] D_IN;
wire [31:0] D_OUT;

reg [31:0] a,b,c,d,e,f,g,h;
reg [31:0] H [8];


always @(HI) begin
    H[HI] <= H_IN;
    case(HI)
        0: a <= H_IN;
        1: b <= H_IN;
        2: c <= H_IN;
        3: d <= H_IN;
        4: e <= H_IN;
        5: f <= H_IN;
        6: g <= H_IN;
        7: h <= H_IN;
    endcase 
end

always @(WI) begin
    $display(WI);
end



endmodule