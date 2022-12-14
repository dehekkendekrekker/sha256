`include "./src/verilog/MOD_SIGMA0.v"
`include "./src/verilog/MOD_SIGMA1.v"
`include "./src/verilog/MOD_CHOICE.v"
`include "./src/verilog/MOD_MAJORITY.v"
`include "./src/verilog/MOD_S0.v"
`include "./src/verilog/MOD_S1.v"
`include "./src/verilog/MOD_COUNTER.v"

`ifndef MOD_W_WND_COMP
`define MOD_W_WND_COMP
module MOD_W_WND_COMP(CLK, CMD, MKA, MD_IN, MD_OUT, KD, HA, HD_IN, HD_OUT, RES, RDY);

input             CLK;
input      [7:0]  CMD; // The command given to the module

output reg [7:0]  MKA; // Message block & K-constants address bus
output reg [7:0]  HA; // H-values address bus

input      [31:0] MD_IN; // Message block data bus (IN)
output reg [31:0] MD_OUT; // Message block data bus (OUT)

input      [31:0] KD; // K-consts data bus
input      [31:0] HD_IN; // H-values data bus

output reg [31:0] HD_OUT; // Hash values that are sent out to be stored

output reg [255:0] RES; // The final hash value

output reg        RDY; // Pulled low when ready



// Window related
reg [31:0] W; // Message schedule (W) OUT
reg [31:0] w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15;
reg [31:0] s0, s1;

MOD_S0 sigma0 (w1, s0);
MOD_S1 sigma1 (w14, s1);



// Compressor related
reg [31:0] a,b,c,d,e,f,g,h;
reg [31:0] t1,t2;
reg [31:0] S0, S1;
reg [31:0] ch, maj;

MOD_SIGMA0 SIGMA0(a, S0);
MOD_SIGMA1 SIGMA1(e, S1);
MOD_CHOICE choice(e,f,g,ch);
MOD_MAJORITY majority(a,b,c,maj);

// H-value counter for addressing
MOD_COUNTER h_ctr(CLK, H_CTR_RST, HA);
reg H_CTR_RST;

// M-block counter for addressing
MOD_COUNTER m_ctr(CLK, M_CTR_RST, MKA);
reg M_CTR_RST;

// Assignment of temp regs
assign t1 = h + S1 + ch + KD + W;
assign t2 = S0 + maj;

// Commands
localparam CMD_IDLE = 0;
localparam CMD_LOAD_H = 10;
localparam CMD_HASH = 20;
localparam CMD_SUM_STORE_H = 30;
localparam CMD_SUM_STORE_M = 40;
localparam CMD_GET_DIGEST = 50;

// FSM setup
reg [7:0] state;
localparam ST_IDLE = 0;
localparam ST_LOAD_H = 10;
localparam ST_HASH = 20;
localparam ST_SUM_STORE_H = 30;
localparam ST_SUM_STORE_M = 40;
localparam ST_GET_DIGEST = 50;

initial state = ST_IDLE;

// Initial setup
initial begin
    H_CTR_RST = 1;
    M_CTR_RST = 1;
    RDY = 0;
end

always @(CMD) begin
    case(CMD)
    CMD_IDLE: state <= ST_IDLE;

    // Loads the H values on the H_IN bus into the registers
    CMD_LOAD_H: begin
        H_CTR_RST <= 0; 
        state <= ST_LOAD_H;
    end

    // Calculates one round of SHA256 of one block M.
    CMD_HASH: begin
        M_CTR_RST <= 0;
        state <= ST_HASH;
    end

    // Calculates the SUM of the registers a..h + H_IN. 
    // Then the output is put on H_OUT.
    // This is used after hashing the first block, such that 
    // the calculated Hash can be retrieved and used as intial values
    // when calculating the second block when the nonce changes
    CMD_SUM_STORE_H: begin
        H_CTR_RST <= 0; // Activate H-counter
        state <= ST_SUM_STORE_H;
    end

    // Performed on second block. Result it put on M_OUT, so it can 
    // be stored into the message block buffer
    CMD_SUM_STORE_M: begin
        H_CTR_RST <= 0;
        state <= ST_SUM_STORE_M;
    end

    CMD_GET_DIGEST: begin
        H_CTR_RST <= 0;
        state <= ST_GET_DIGEST;
    end

    endcase
end


always @(negedge CLK) begin
    case(state)
    ST_IDLE: begin
        RDY <= 0;
    end

    // Handles the loading of H-values
    ST_LOAD_H: begin
        case (HA)
        0: a <= HD_IN;
        1: b <= HD_IN;
        2: c <= HD_IN;
        3: d <= HD_IN;
        4: e <= HD_IN;
        5: f <= HD_IN;
        6: g <= HD_IN;
        7: h <= HD_IN;
        8: begin
            H_CTR_RST <= 1;
            state <= ST_IDLE;
            RDY <= 1;
        end
        endcase
    end

    ST_HASH: begin
        if (MKA < 16)
            W = MD_IN;
        else 
            W = w0 + s0 + w9 + s1;

        // Move window down the message schedule
        w15 <= W;
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

        // Check for end condition
        if (MKA == 63) begin
            M_CTR_RST <= 1;
            state <= ST_IDLE;
            RDY <= 1;
        end
    end

    

    endcase
end


always @(posedge CLK) begin
    case(state)
    ST_SUM_STORE_H: begin
        case (HA)
        0: HD_OUT <= HD_IN + a;
        1: HD_OUT <= HD_IN + b;
        2: HD_OUT <= HD_IN + c;
        3: HD_OUT <= HD_IN + d;
        4: HD_OUT <= HD_IN + e;
        5: HD_OUT <= HD_IN + f;
        6: HD_OUT <= HD_IN + g;
        7: HD_OUT <= HD_IN + h;
        8: begin
            H_CTR_RST <= 1;
            state <= ST_IDLE;
            RDY <= 1;
        end
        endcase
    end


    ST_SUM_STORE_M: begin
        case (HA)
        0: MD_OUT <= HD_IN + a;
        1: MD_OUT <= HD_IN + b;
        2: MD_OUT <= HD_IN + c;
        3: MD_OUT <= HD_IN + d;
        4: MD_OUT <= HD_IN + e;
        5: MD_OUT <= HD_IN + f;
        6: MD_OUT <= HD_IN + g;
        7: MD_OUT <= HD_IN + h;
        8: begin
            H_CTR_RST <= 1;
            state <= ST_IDLE;
            RDY <= 1;
        end
        endcase
    end
    

    ST_GET_DIGEST: begin
        case (HA)
        0: RES[255:224] <= HD_IN + a;
        1: RES[223:192] <= HD_IN + b;
        2: RES[191:160] <= HD_IN + c;
        3: RES[159:128] <= HD_IN + d;
        4: RES[127:96]  <= HD_IN + e;
        5: RES[95:64]   <= HD_IN + f;
        6: RES[63:32]   <= HD_IN + g;
        7: RES[31:0]    <= HD_IN + h;
        8: begin
            H_CTR_RST <= 1;
            state <= ST_IDLE;
            RDY <= 1;
        end
        endcase
    end

    endcase



end



endmodule
`endif