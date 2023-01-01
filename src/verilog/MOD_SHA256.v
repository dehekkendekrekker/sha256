// This module ties everything together
`include "./src/verilog/MOD_COMPRESSOR.v"
`include "./src/verilog/MOD_MEM128K.v"
`include "./src/verilog/MOD_COUNTER.v"
`include "./src/verilog/MOD_HK_MEM.v"

`ifndef MOD_SHA256
`define MOD_SHA256
module MOD_SHA256(CLK);

input CLK;

MOD_COMPRESSOR compressor(CLK, RST_COMP, I, W, K, 
H[0],H[1],H[2],H[3],H[4],H[5],H[6],H[7],
R[0],R[1],R[2],R[3],R[4],R[5],R[6],R[7]);




/*
============================
Setup HK memory
============================
*/
MOD_HK_MEM hk_mem(HK_CLK, HK_RST, HK_SELECTOR, H_ADDR, K_ADDR, HK_DATA, HK_RDY);

reg HK_CLK, HK_RST, HK_SELECTOR;
reg [2:0] H_ADDR;
reg [5:0] K_ADDR;
reg [31:0] HK_DATA;
wire HK_RDY;


assign HK_CLK = CLK;

initial begin
    HK_RST = 0;
end




// This module holds the message block
// MOD_MEM128K msg_blk();

// This counter runs for 256 cycles to give the circuit the chance 
// to power up.
MOD_COUNTER boot_ctr(CLK, RST_BOOT_CTR, D_BOOT_CTR);
reg RST_BOOT_CTR;
wire [7:0] D_BOOT_CTR;



 

// We should be some logic that copies the H values into the latches
// Latches should be implemented here

reg [31:0] H [8];
reg [31:0] R [8];

reg RST_COMP;
reg [5:0] I;
reg [31:0] W, K;


reg [7:0] state;

localparam DEV_START = 0;
localparam DEV_BOOTING = 5;
localparam PRE_MEM_INIT =7;
localparam MEM_INIT = 10;
localparam LOAD_MSG = 15;
localparam RST_COMP_H = 20;
localparam PROC = 30;
localparam SAVE_HASH = 40;


// We're dealing with a couple of situations:

// The device needs to initialize. This means that ROM memory should be copied

// Data needs to be loaded from the comms port into memory
// This data will then be processed:
// - H registers are loaded from RAM (reset)
// - The hash action will take place
// The output registers are added to H[x] registers
// This will still need to figure out


// Receiving messages and sending hashes should be done parallely

initial begin
    state = DEV_START;
    RST_BOOT_CTR = 1;
    RST_COMP = 0;
end


always @(negedge CLK) begin
    case(state)
    DEV_START: begin
        RST_BOOT_CTR <= 0;
        state <= DEV_BOOTING;
    end
    DEV_BOOTING: begin
        if (D_BOOT_CTR == 255) 
        state <= PRE_MEM_INIT;
    end
    PRE_MEM_INIT: begin
        HK_RST <= 1;
        state <= MEM_INIT;
    end
    MEM_INIT: begin
        if (HK_RDY) begin
            $display("END");
            $finish;
        end
    end
    endcase
end






endmodule
`endif






















// // Letter registers
// reg [31:0] a;
// reg [31:0] b;
// reg [31:0] c;
// reg [31:0] d;
// reg [31:0] e;
// reg [31:0] f;
// reg [31:0] g;
// reg [31:0] h;
// reg [31:0] Temp1;
// reg [31:0] Temp2;


// reg [31:0] H [8];
// reg [31:0] W [128];





// initial begin
//     state = ST_IDLE;
//     ctr_clr = 1;


//     H[0] = 32'h6a09e667;
//     H[1] = 32'hbb67ae85;
//     H[2] = 32'h3c6ef372;
//     H[3] = 32'h54ff53a;
//     H[4] = 32'h10e527f;
//     H[5] = 32'h9b05688c;
//     H[6] = 32'h1f83d9ab;
//     H[7] = 32'h5be0cd19;

//     W[0] = 32'b01001000011001010110110001101100;
//     W[1] = 32'b01101111001000000111011101101111;
//     W[2] = 32'b01110010011011000110010000100001;
//     W[3] = 32'b10000000000000000000000000000000;
//     W[4] = 32'b00000000000000000000000000000000;
//     W[5] = 32'b00000000000000000000000000000000;
//     W[6] = 32'b00000000000000000000000000000000;
//     W[7] = 32'b00000000000000000000000000000000;
//     W[8] = 32'b00000000000000000000000000000000;
//     W[9] = 32'b00000000000000000000000000000000;
//     W[10] = 32'b00000000000000000000000000000000;
//     W[11] = 32'b00000000000000000000000000000000;
//     W[12] = 32'b00000000000000000000000000000000;
//     W[13] = 32'b00000000000000000000000000000000;
//     W[14] = 32'b00000000000000000000000000000000;
//     W[15] = 32'b00000000000000000000000001100000;

//     // TODO: Fill this with representative data
//     W[16] = 32'b00000000000000000000000000000000;
//     W[17] = 32'b00000000000000000000000000000000;
//     W[18] = 32'b00000000000000000000000000000000;
//     W[19] = 32'b00000000000000000000000000000000;
//     W[20] = 32'b00000000000000000000000000000000;
//     W[21] = 32'b00000000000000000000000000000000;
//     W[22] = 32'b00000000000000000000000000000000;
//     W[23] = 32'b00000000000000000000000000000000;
//     W[24] = 32'b00000000000000000000000000000000;
//     W[25] = 32'b00000000000000000000000000000000;
//     W[26] = 32'b00000000000000000000000000000000;
//     W[27] = 32'b00000000000000000000000000000000;
//     W[28] = 32'b00000000000000000000000000000000;
//     W[29] = 32'b00000000000000000000000000000000;
//     W[30] = 32'b00000000000000000000000000000000;
//     W[31] = 32'b00000000000000000000000000000000;

// end





// endmodule