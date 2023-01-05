// This module ties everything together
`include "./src/verilog/MOD_COMPRESSOR.v"
`include "./src/verilog/MOD_MEM128K.v"
`include "./src/verilog/MOD_COUNTER.v"
`include "./src/verilog/MOD_HK_MEM.v"

`ifndef MOD_SHA256
`define MOD_SHA256


/* This module should do 3 things:
1) Hash the static part of the bitcoin block header. In practice, this boils down to the first round of SHA1
2) Hash the variable part of the bitcoin block header. This means the  second round.
3) Calculate another round of SHA256 over the output of 1 + 2
*/



module MOD_SHA256(CLK, OPERATION, HA, HD, MA, MD, RDY);
input CLK;
input [7:0] OPERATION;
output reg [7:0] HA;  // Address to H-value
input [31:0] HD;  // H-value corresponding to HA
input [7:0] MA; // Address into message block M
output [31:0] MD; // M-block value corresponding to MA
output reg RDY; //  Set high when operation ready

reg [31:0] H [8];

// H counter
MOD_COUNTER h_ctr(CLK, RST_H, HA);
reg RST_H;
initial RST_H = 1;

// Counter that loops over message block
MOD_COUNTER m_ctr(CLK, RST_M, MA);
reg RST_M;
initial RST_M = 1;



localparam OP_IDLE = 0;
localparam OP_RESET_H = 10;
localparam OP_HASH_1 = 20;

// Internal state
reg [7:0] state;
localparam ST_IDLE = 0;

// States that describe the H-value resetting process
localparam ST_PRE_RESETTING_H = 10;
localparam ST_RESETTING_H = 20;

// States that describe the 1st round hashing of the "static" message block
localparam ST_PRE_HASH_1 = 40;
localparam ST_HASH_1 = 50;


always @(posedge CLK, negedge CLK) begin
    case (OPERATION)
    OP_IDLE: state <= ST_IDLE;
    OP_RESET_H: state <= ST_PRE_RESETTING_H;
    OP_HASH_1: state <= ST_PRE_HASH_1;
    
    endcase

    case(state)

    ST_IDLE: begin
        RDY <= 0;
    end

    // This block deals with the resetting of H-values into their appropriate registers
    ST_PRE_RESETTING_H: begin
        RST_H <= 0;
        state <= ST_RESETTING_H;
    end
    ST_RESETTING_H: begin
        H[HA] = HD;
        if (HA === 7) begin
            state <= ST_IDLE;
            RDY <= 1;
            RST_H <= 1;
        end
    end

    // This block deals with the first round hashing of the first "static" block
    ST_PRE_HASH_1: begin
        RST_M <= 0;
        state <= ST_HASH_1;
    end
    ST_HASH_1: begin
        $display(MD[MA]);
    end
    

    endcase

end







endmodule
`endif












