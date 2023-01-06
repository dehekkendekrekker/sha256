module MOD_W_WND_COMP_TB;
`INIT

MOD_W_WND_COMP mut(CLK, CMD, MKA, MD, KD, HA, HD_IN, HD_OUT, RDY);

reg CLK;
reg [7:0] CMD;
wire [7:0] MKA, HA;
reg [31:0] MD, KD, HD_IN;
wire [31:0] HD_OUT;
wire RDY;


reg [31:0] K [64];
reg [31:0] W [64];
reg [31:0] H [24];
reg [31:0] E_REG [8];
reg [31:0] EH [8];


localparam period = 20;  

initial begin
    `SET_MOD("MOD_W_WND_COMP_TB");
    $dumpfile("./build/MOD_W_WND_COMP_TB.vcd");
    $dumpvars(0, MOD_W_WND_COMP_TB);
    $timeformat(-6, 0, " us", 20);

    #10000
    `FAILED("TIMEOUT");
    $finish();
end

// Setup H-bins
initial begin
    // The are pre-defined values that are always present.
    H[0] = 32'h6a09e667;
    H[1] = 32'hbb67ae85;
    H[2] = 32'h3c6ef372;
    H[3] = 32'ha54ff53a;
    H[4] = 32'h510e527f;
    H[5] = 32'h9b05688c;
    H[6] = 32'h1f83d9ab;
    H[7] = 32'h5be0cd19;
    // This is where the SHA256 hash of the first round is stored.
    // This will be used to reload and setup the second round.
    H[8] = 0;
    H[9] = 0;
    H[10] = 0;
    H[11] = 0;
    H[12] = 0;
    H[13] = 0;
    H[14] = 0;
    H[15] = 0;
    // This is where the SHA256 of a complete operation is stored, ie the final SHA256 hash
    H[16] = 0;
    H[17] = 0;
    H[18] = 0;
    H[19] = 0;
    H[20] = 0;
    H[21] = 0;
    H[22] = 0;
    H[23] = 0;
end

// Setup W-memory
// Based on "Hello world!"
initial begin
    W[0] = 32'b01001000011001010110110001101100;
    W[1] = 32'b01101111001000000111011101101111;
    W[2] = 32'b01110010011011000110010000100001;
    W[3] = 32'b10000000000000000000000000000000;
    W[4] = 32'b00000000000000000000000000000000;
    W[5] = 32'b00000000000000000000000000000000;
    W[6] = 32'b00000000000000000000000000000000;
    W[7] = 32'b00000000000000000000000000000000;
    W[8] = 32'b00000000000000000000000000000000;
    W[9] = 32'b00000000000000000000000000000000;
    W[10] = 32'b00000000000000000000000000000000;
    W[11] = 32'b00000000000000000000000000000000;
    W[12] = 32'b00000000000000000000000000000000;
    W[13] = 32'b00000000000000000000000000000000;
    W[14] = 32'b00000000000000000000000000000000;
    W[15] = 32'b00000000000000000000000001100000;


    W[16] = 32'b00000000000000000000000000000000;
    W[17] = 32'b00000000000000000000000000000000;
    W[18] = 32'b00000000000000000000000000000000;
    W[19] = 32'b00000000000000000000000000000000;
    W[20] = 32'b00000000000000000000000000000000;
    W[21] = 32'b00000000000000000000000000000000;
    W[22] = 32'b00000000000000000000000000000000;
    W[23] = 32'b00000000000000000000000000000000;
    W[24] = 32'b00000000000000000000000000000000;
    W[25] = 32'b00000000000000000000000000000000;
    W[26] = 32'b00000000000000000000000000000000;
    W[27] = 32'b00000000000000000000000000000000;
    W[28] = 32'b00000000000000000000000000000000;
    W[29] = 32'b00000000000000000000000000000000;
    W[30] = 32'b00000000000000000000000000000000;
    W[31] = 32'b00000000000000000000000000000000;

    W[32] = 32'b00000000000000000000000000000000;
    W[33] = 32'b00000000000000000000000000000000;
    W[34] = 32'b00000000000000000000000000000000;
    W[35] = 32'b00000000000000000000000000000000;
    W[36] = 32'b00000000000000000000000000000000;
    W[37] = 32'b00000000000000000000000000000000;
    W[38] = 32'b00000000000000000000000000000000;
    W[39] = 32'b00000000000000000000000000000000;
    W[40] = 32'b00000000000000000000000000000000;
    W[41] = 32'b00000000000000000000000000000000;
    W[42] = 32'b00000000000000000000000000000000;
    W[43] = 32'b00000000000000000000000000000000;
    W[44] = 32'b00000000000000000000000000000000;
    W[45] = 32'b00000000000000000000000000000000;
    W[46] = 32'b00000000000000000000000000000000;
    W[47] = 32'b00000000000000000000000000000000;

    W[48] = 32'b00000000000000000000000000000000;
    W[49] = 32'b00000000000000000000000000000000;
    W[50] = 32'b00000000000000000000000000000000;
    W[51] = 32'b00000000000000000000000000000000;
    W[52] = 32'b00000000000000000000000000000000;
    W[53] = 32'b00000000000000000000000000000000;
    W[54] = 32'b00000000000000000000000000000000;
    W[55] = 32'b00000000000000000000000000000000;
    W[56] = 32'b00000000000000000000000000000000;
    W[57] = 32'b00000000000000000000000000000000;
    W[58] = 32'b00000000000000000000000000000000;
    W[59] = 32'b00000000000000000000000000000000;
    W[60] = 32'b00000000000000000000000000000000;
    W[61] = 32'b00000000000000000000000000000000;
    W[62] = 32'b00000000000000000000000000000000;
    W[63] = 32'b00000000000000000000000000000000;
end

// Setup K-constants
initial begin
K[0]  = 32'h428a2f98;
K[1]  = 32'h71374491;
K[2]  = 32'hb5c0fbcf;
K[3]  = 32'he9b5dba5;
K[4]  = 32'h3956c25b;
K[5]  = 32'h59f111f1;
K[6]  = 32'h923f82a4;
K[7]  = 32'hab1c5ed5;
K[8]  = 32'hd807aa98;
K[9]  = 32'h12835b01;
K[10] = 32'h243185be;
K[11] = 32'h550c7dc3;
K[12] = 32'h72be5d74;
K[13] = 32'h80deb1fe;
K[14] = 32'h9bdc06a7;
K[15] = 32'hc19bf174;
K[16] = 32'he49b69c1;
K[17] = 32'hefbe4786;
K[18] = 32'h0fc19dc6;
K[19] = 32'h240ca1cc;
K[20] = 32'h2de92c6f;
K[21] = 32'h4a7484aa;
K[22] = 32'h5cb0a9dc;
K[23] = 32'h76f988da;
K[24] = 32'h983e5152;
K[25] = 32'ha831c66d;
K[26] = 32'hb00327c8;
K[27] = 32'hbf597fc7;
K[28] = 32'hc6e00bf3;
K[29] = 32'hd5a79147;
K[30] = 32'h06ca6351;
K[31] = 32'h14292967;
K[32] = 32'h27b70a85;
K[33] = 32'h2e1b2138;
K[34] = 32'h4d2c6dfc;
K[35] = 32'h53380d13;
K[36] = 32'h650a7354;
K[37] = 32'h766a0abb;
K[38] = 32'h81c2c92e;
K[39] = 32'h92722c85;
K[40] = 32'ha2bfe8a1;
K[41] = 32'ha81a664b;
K[42] = 32'hc24b8b70;
K[43] = 32'hc76c51a3;
K[44] = 32'hd192e819;
K[45] = 32'hd6990624;
K[46] = 32'hf40e3585;
K[47] = 32'h106aa070;
K[48] = 32'h19a4c116;
K[49] = 32'h1e376c08;
K[50] = 32'h2748774c;
K[51] = 32'h34b0bcb5;
K[52] = 32'h391c0cb3;
K[53] = 32'h4ed8aa4a;
K[54] = 32'h5b9cca4f;
K[55] = 32'h682e6ff3;
K[56] = 32'h748f82ee;
K[57] = 32'h78a5636f;
K[58] = 32'h84c87814;
K[59] = 32'h8cc70208;
K[60] = 32'h90befffa;
K[61] = 32'ha4506ceb;
K[62] = 32'hbef9a3f7;
K[63] = 32'hc67178f2;
end


// Setup expectations
initial begin
E_REG[0] = 32'b00100111010011111111000101111000;
E_REG[1] = 32'b01010110101110100001111110010011;
E_REG[2] = 32'b10011110000111000000001101001111;
E_REG[3] = 32'b01011101111010111011100111110011;
E_REG[4] = 32'b00010011101110101111011001000011;
E_REG[5] = 32'b11011101001101111010010001001000;
E_REG[6] = 32'b10111110111110010001100000000001;
E_REG[7] = 32'b00110011110000101100010101110001;
end


// Setup clock signal
reg [15:0] clk_count;
initial clk_count = 0;
always begin 
    #period CLK = ~CLK;
    if (CLK) clk_count++;
end

// Initial conditions
initial begin
    CLK = 0;
    CMD = mut.CMD_IDLE;
end

// Assignments
assign HD_IN = H[HA];
assign MD = W[MKA];
assign KD = K[MKA];


// test state
reg [7:0] test_state;
localparam ST_IDLE = 0;
localparam ST_LOAD_H = 10;
localparam ST_VERIFY_LOAD_H = 20;
localparam ST_HASH = 30;
localparam ST_VERIFY_HASH = 40;
localparam ST_SUM_STORE = 50;
localparam ST_SUM_STORE_VERIFY = 60;
localparam ST_FINISH = 100;
initial test_state = ST_IDLE;

 
// Counter behaviour
always @(negedge CLK) begin
    case (test_state)
    ST_IDLE: test_state <= ST_LOAD_H;
    ST_LOAD_H: begin
        test_state <= ST_VERIFY_LOAD_H;
        CMD <= mut.CMD_LOAD_H;
    end
    
    ST_HASH: begin
        CMD <= mut.CMD_HASH;
        test_state <= ST_VERIFY_HASH;
    end

    ST_SUM_STORE: begin
        CMD <= mut.CMD_SUM_STORE;
        test_state <= ST_SUM_STORE_VERIFY;
    end

    

    ST_FINISH: begin
        $display("CLK count: %1d", clk_count);
        $finish();
    end
    

    endcase


end

always @(posedge RDY) begin
    case(test_state)
    ST_VERIFY_LOAD_H: begin
        CMD <= mut.CMD_IDLE;
        test_state <= ST_HASH;

        `INFO("=== Verifying register values after loading H values ===");
        if (mut.a !== H[0]) `FAILED_EXP(0, mut.a, H[0]);
        if (mut.b !== H[1]) `FAILED_EXP(1, mut.b, H[1]);
        if (mut.c !== H[2]) `FAILED_EXP(2, mut.c, H[2]);
        if (mut.d !== H[3]) `FAILED_EXP(3, mut.d, H[3]);
        if (mut.e !== H[4]) `FAILED_EXP(4, mut.e, H[4]);
        if (mut.f !== H[5]) `FAILED_EXP(5, mut.f, H[5]);
        if (mut.g !== H[6]) `FAILED_EXP(6, mut.g, H[6]);
        if (mut.h !== H[7]) `FAILED_EXP(7, mut.h, H[7]);
    end

    ST_VERIFY_HASH: begin
        CMD <= mut.CMD_IDLE;
        test_state <= ST_SUM_STORE;

        `INFO("=== Verifying register values after hash operation ===");
        if (mut.a !== E_REG[0]) `FAILED_EXP(0, mut.a, E_REG[0]);
        if (mut.b !== E_REG[1]) `FAILED_EXP(1, mut.b, E_REG[1]);
        if (mut.c !== E_REG[2]) `FAILED_EXP(2, mut.c, E_REG[2]);
        if (mut.d !== E_REG[3]) `FAILED_EXP(3, mut.d, E_REG[3]);
        if (mut.e !== E_REG[4]) `FAILED_EXP(4, mut.e, E_REG[4]);
        if (mut.f !== E_REG[5]) `FAILED_EXP(5, mut.f, E_REG[5]);
        if (mut.g !== E_REG[6]) `FAILED_EXP(6, mut.g, E_REG[6]);
        if (mut.h !== E_REG[7]) `FAILED_EXP(7, mut.h, E_REG[7]);
    end

    ST_SUM_STORE_VERIFY: begin
        CMD <= mut.CMD_IDLE;
        test_state <= ST_FINISH;

        `INFO("=== Verifying H values after summing and storing ===");
        for (integer i=0; i<8;i++)
            if (H[i+8] != EH[i])
                `FAILED_EXP(i, H[i+8], EH[i]);
        

    end


    endcase

    

end


always @(negedge CLK) begin
    case(test_state) 
    // Simulates storing the hash
    ST_SUM_STORE_VERIFY: begin
        H[HA+8] = HD_OUT;
    end
    endcase
end




endmodule



