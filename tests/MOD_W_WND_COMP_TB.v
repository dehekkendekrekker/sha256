module MOD_W_WND_COMP_TB;
`INIT

MOD_W_WND_COMP mut(CLK, CMD, MKA, MD_IN, MD_OUT, KD, HA, HD_IN, HD_OUT, RES, RDY);

reg CLK;
reg [7:0] CMD;
wire [7:0] MKA, HA;
reg [31:0] MD_IN, KD, HD_IN;
wire [31:0] HD_OUT, MD_OUT;
wire [255:0] RES;
wire RDY;


reg [31:0] K [64];
reg [31:0] H [24];
reg [31:0] E_REG1 [8];
reg [31:0] E_REG2 [8];
reg [31:0] E_REG3 [8];
reg [31:0] EH1 [8];
reg [31:0] EM1 [8];


localparam period = 20;  

initial begin
    `SET_MOD("MOD_W_WND_COMP_TB");
    $dumpfile("./build/MOD_W_WND_COMP_TB.vcd");
    $dumpvars(0, MOD_W_WND_COMP_TB);
    $timeformat(-6, 0, " us", 20);

    #24000
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



// Setup message block

// Block header:
// 0100000000000000000000000000000000000000000000000000000000000000000000003ba3edfd7a7b12b27ac72c3e67768f617fc81bc3888a51323a9fb8aa4b1e5e4a29ab5f49ffff001d1dac2b7c

// 0100000000000000000000000000000000000000000000000000000000000000000000003ba3edfd7a7b12b27ac72c3e67768f617fc81bc3888a51323a9fb8aa4b1e5e4a29ab5f49ffff001d1eac2b7c
//                                                                                                                                 4b1e5e4a29ab5f49ffff001d1eac2b7c
reg [31:0] M [48]; // 1024 bit message block
initial begin
    // Static block
    M[0] = 32'b00000001000000000000000000000000;
    M[1] = 32'b00000000000000000000000000000000;
    M[2] = 32'b00000000000000000000000000000000;
    M[3] = 32'b00000000000000000000000000000000;
    M[4] = 32'b00000000000000000000000000000000;
    M[5] = 32'b00000000000000000000000000000000;
    M[6] = 32'b00000000000000000000000000000000;
    M[7] = 32'b00000000000000000000000000000000;
    M[8] = 32'b00000000000000000000000000000000;
    M[9] = 32'b00111011101000111110110111111101;
    M[10] = 32'b01111010011110110001001010110010;
    M[11] = 32'b01111010110001110010110000111110;
    M[12] = 32'b01100111011101101000111101100001;
    M[13] = 32'b01111111110010000001101111000011;
    M[14] = 32'b10001000100010100101000100110010;
    M[15] = 32'b00111010100111111011100010101010;

    // Dynamic block
    M[16] = 32'b01001011000111100101111001001010;
    M[17] = 32'b00101001101010110101111101001001;
    M[18] = 32'b11111111111111110000000000011101;
    M[19] = 32'b00011101101011000010101101111100;
               
    M[20] = 32'b10000000000000000000000000000000;
    M[21] = 32'b00000000000000000000000000000000;
    M[22] = 32'b00000000000000000000000000000000;
    M[23] = 32'b00000000000000000000000000000000;
    M[24] = 32'b00000000000000000000000000000000;
    M[25] = 32'b00000000000000000000000000000000;
    M[26] = 32'b00000000000000000000000000000000;
    M[27] = 32'b00000000000000000000000000000000;
    M[28] = 32'b00000000000000000000000000000000;
    M[29] = 32'b00000000000000000000000000000000;
    M[30] = 32'b00000000000000000000000000000000;
    M[31] = 32'b00000000000000000000001010000000;

    // Hash block. The results of the first round of SHA256 will be put here
    M[32] = 32'b00000000000000000000000000000000;
    M[33] = 32'b00000000000000000000000000000000;
    M[34] = 32'b00000000000000000000000000000000;
    M[35] = 32'b00000000000000000000000000000000;
    M[36] = 32'b00000000000000000000000000000000;
    M[37] = 32'b00000000000000000000000000000000;
    M[38] = 32'b00000000000000000000000000000000;
    M[39] = 32'b00000000000000000000000000000000;
    M[40] = 32'b10000000000000000000000000000000; // Terminator bit
    M[41] = 32'b00000000000000000000000000000000;
    M[42] = 32'b00000000000000000000000000000000;
    M[43] = 32'b00000000000000000000000000000000;
    M[44] = 32'b00000000000000000000000000000000;
    M[45] = 32'b00000000000000000000000000000000;
    M[46] = 32'b00000000000000000000000000000000;
    M[47] = 32'b00000000000000000000000100000000; // 256 bits
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

// Expectations for the registers (a,b,..) after hashing the first block
E_REG1[0] = 32'h5286b3cc;
E_REG1[1] = 32'ha7f1116b;
E_REG1[2] = 32'h545db90b;
E_REG1[3] = 32'h7909d56e;
E_REG1[4] = 32'h72ba866a;
E_REG1[5] = 32'hb3fb9b3c;
E_REG1[6] = 32'h772dad8b;
E_REG1[7] = 32'heb392c02;
end

initial begin

// Expectations for the registers (a,b,..) after hashing the second block
E_REG2[0] = 32'hf2b168eb;
E_REG2[1] = 32'h1d0734a3;
E_REG2[2] = 32'h0fa69565;
E_REG2[3] = 32'hd8f62ad9;
E_REG2[4] = 32'h860951d0;
E_REG2[5] = 32'h6b18f24b;
E_REG2[6] = 32'had314136;
E_REG2[7] = 32'h2aabdd52;

end

initial begin
// Expectations for the registers (a,b,..) after hashing the second round of SHA256 (hashing the hash)

E_REG3[0] = 32'h5d8a5a3;
E_REG3[1] = 32'hfb8a04ed;
E_REG3[2] = 32'h8537aed4;
E_REG3[3] = 32'h09140215;
E_REG3[4] = 32'h421030e6;
E_REG3[5] = 32'h4654a010;
E_REG3[6] = 32'h49523f55;
E_REG3[7] = 32'ha41f32e7;
end

// Expectations for the hash values after hashing the first block
initial begin
EH1[0] = 32'hbc909a33;
EH1[1] = 32'h6358bff0;
EH1[2] = 32'h90ccac7d;
EH1[3] = 32'h1e59caa8;
EH1[4] = 32'hc3c8d8e9;
EH1[5] = 32'h4f0103c8;
EH1[6] = 32'h96b18736;
EH1[7] = 32'h4719f91b;
end

// Expectations for the hash values after hashing the first SHA256 round
initial begin
EM1[0] = 32'haf42031e;
EM1[1] = 32'h805ff493;
EM1[2] = 32'ha07341e2;
EM1[3] = 32'hf74ff581;
EM1[4] = 32'h49d22ab9;
EM1[5] = 32'hba19f613;
EM1[6] = 32'h43e2c86c;
EM1[7] = 32'h71c5d66d;
end

// Expectations for the hash after the second SHA256 round
reg [255:0] ERES [2];
initial begin
    ERES[0] = 256'h6fe28c0ab6f1b372c1a6a246ae63f74f931e8365e15a089c68d6190000000000;
    ERES[1] = 256'h1c1ba4714930063bebadce0a323e51d097775dbc444187e6ba0caa5d4a7a229b;
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

assign HD_IN = (test_state == ST1_LOAD_STATIC_BLOCK_HASH_FROM_H) ? H[HA+8] :
               (test_state == ST2_LOAD_STATIC_BLOCK_HASH_FROM_H) ? H[HA+8] :
               (test_state == ST1_STORE_ROUND1_HASH_IN_M)        ? H[HA+8] : 
               (test_state == ST2_STORE_ROUND1_HASH_IN_M)        ? H[HA+8] : H[HA];         

assign MD_IN = (test_state == ST1_HASH_DYN_BLOCK) ? M[(MKA % 16) + 16] : 
               (test_state == ST2_HASH_DYN_BLOCK) ? M[(MKA % 16) + 16] :
               (test_state == ST1_HASH_ROUND1_HASH) ? M[(MKA % 16) + 32] :
               (test_state == ST2_HASH_ROUND1_HASH) ? M[(MKA % 16) + 32] : M[MKA % 16];


assign KD = K[MKA];


// test state
reg [7:0] test_state;
localparam ST_IDLE = 0;

// First SHA256 round
localparam ST1_LOAD_DEFAULT_H_R1 = 1;
localparam ST1_HASH_STATIC_BLOCK = 2;
localparam ST1_STORE_STATIC_BLOCK_HASH_IN_H = 3;
localparam ST1_LOAD_STATIC_BLOCK_HASH_FROM_H = 4;
localparam ST1_HASH_DYN_BLOCK = 5;
localparam ST1_STORE_ROUND1_HASH_IN_M = 6;

// Second SHA256 round
localparam ST1_LOAD_DEFAULT_H_R2 = 7;
localparam ST1_HASH_ROUND1_HASH = 8;
localparam ST1_GET_DIGEST = 9;
// sha256d round 1 complete

localparam ST_INC_NONCE = 10;

localparam ST2_LOAD_STATIC_BLOCK_HASH_FROM_H = 20;
localparam ST2_HASH_DYN_BLOCK = 30;
localparam ST2_STORE_ROUND1_HASH_IN_M = 40;

// Second SHA256 round
localparam ST2_LOAD_DEFAULT_H_R2 = 50;
localparam ST2_HASH_ROUND1_HASH = 60;
localparam ST2_GET_DIGEST = 70;

// sha256d round 2 complete




localparam ST_FINISH = 200;
initial test_state = ST_IDLE;

 
// Counter behaviour
always @(negedge CLK) begin
    case (test_state)
    ST_IDLE: test_state <= ST1_LOAD_DEFAULT_H_R1;

    ST1_LOAD_DEFAULT_H_R1:             CMD <= mut.CMD_LOAD_H;
    ST1_HASH_STATIC_BLOCK:             CMD <= mut.CMD_HASH;
    ST1_STORE_STATIC_BLOCK_HASH_IN_H:  CMD <= mut.CMD_SUM_STORE_H;
    ST1_LOAD_STATIC_BLOCK_HASH_FROM_H: CMD <= mut.CMD_LOAD_H;
    ST1_HASH_DYN_BLOCK:                CMD <= mut.CMD_HASH;
    ST1_STORE_ROUND1_HASH_IN_M:        CMD <= mut.CMD_SUM_STORE_M;
    ST1_LOAD_DEFAULT_H_R2:             CMD <= mut.CMD_LOAD_H;
    ST1_HASH_ROUND1_HASH:              CMD <= mut.CMD_HASH;
    ST1_GET_DIGEST:                    CMD <= mut.CMD_GET_DIGEST;

    // Now try for another round

    ST_INC_NONCE: begin
        M[19] = 32'b00011110101011000010101101111100;
        test_state <= ST2_LOAD_STATIC_BLOCK_HASH_FROM_H;
    end

    ST2_LOAD_STATIC_BLOCK_HASH_FROM_H: CMD <= mut.CMD_LOAD_H;
    ST2_HASH_DYN_BLOCK:                CMD <= mut.CMD_HASH;
    ST2_STORE_ROUND1_HASH_IN_M:        CMD <= mut.CMD_SUM_STORE_M;
    ST2_LOAD_DEFAULT_H_R2:             CMD <= mut.CMD_LOAD_H;
    ST2_HASH_ROUND1_HASH:              CMD <= mut.CMD_HASH;
    ST2_GET_DIGEST:                    CMD <= mut.CMD_GET_DIGEST;


    



    ST_FINISH: begin
        $display("CLK count: %1d", clk_count);
        $finish();
    end
    

    endcase


end

always @(posedge RDY) begin
    case(test_state)
    ST1_LOAD_DEFAULT_H_R1: begin
        CMD <= mut.CMD_IDLE;
        test_state <= ST1_HASH_STATIC_BLOCK;

        `INFO("=== Verifying register values after loading H values (block 1)===");
        if (mut.a !== H[0]) `FAILED_EXP(0, mut.a, H[0]);
        if (mut.b !== H[1]) `FAILED_EXP(1, mut.b, H[1]);
        if (mut.c !== H[2]) `FAILED_EXP(2, mut.c, H[2]);
        if (mut.d !== H[3]) `FAILED_EXP(3, mut.d, H[3]);
        if (mut.e !== H[4]) `FAILED_EXP(4, mut.e, H[4]);
        if (mut.f !== H[5]) `FAILED_EXP(5, mut.f, H[5]);
        if (mut.g !== H[6]) `FAILED_EXP(6, mut.g, H[6]);
        if (mut.h !== H[7]) `FAILED_EXP(7, mut.h, H[7]);
    end

    ST1_HASH_STATIC_BLOCK: begin
        CMD <= mut.CMD_IDLE;
        test_state <= ST1_STORE_STATIC_BLOCK_HASH_IN_H;

        `INFO("=== Verifying register values after hash operation ===");
        if (mut.a !== E_REG1[0]) `FAILED_EXP(0, mut.a, E_REG1[0]);
        if (mut.b !== E_REG1[1]) `FAILED_EXP(1, mut.b, E_REG1[1]);
        if (mut.c !== E_REG1[2]) `FAILED_EXP(2, mut.c, E_REG1[2]);
        if (mut.d !== E_REG1[3]) `FAILED_EXP(3, mut.d, E_REG1[3]);
        if (mut.e !== E_REG1[4]) `FAILED_EXP(4, mut.e, E_REG1[4]);
        if (mut.f !== E_REG1[5]) `FAILED_EXP(5, mut.f, E_REG1[5]);
        if (mut.g !== E_REG1[6]) `FAILED_EXP(6, mut.g, E_REG1[6]);
        if (mut.h !== E_REG1[7]) `FAILED_EXP(7, mut.h, E_REG1[7]);
    end

    ST1_STORE_STATIC_BLOCK_HASH_IN_H: begin
        CMD <= mut.CMD_IDLE;
        test_state <= ST1_LOAD_STATIC_BLOCK_HASH_FROM_H;

        `INFO("=== Verifying H values after summing and storing (Block 1)===");
        for (integer i=0; i<8;i++)
            if (H[i+8] !== EH1[i])
                `FAILED_EXP(i, H[i+8], EH1[i]);
        

    end

    ST1_LOAD_STATIC_BLOCK_HASH_FROM_H: begin
        CMD <= mut.CMD_IDLE;
        test_state <= ST1_HASH_DYN_BLOCK;
        `INFO("=== Verifying register values after loading H values (block 2)===");
        if (mut.a !== H[8]) `FAILED_EXP(0, mut.a, H[8]);
        if (mut.b !== H[9]) `FAILED_EXP(1, mut.b, H[9]);
        if (mut.c !== H[10]) `FAILED_EXP(2, mut.c, H[10]);
        if (mut.d !== H[11]) `FAILED_EXP(3, mut.d, H[11]);
        if (mut.e !== H[12]) `FAILED_EXP(4, mut.e, H[12]);
        if (mut.f !== H[13]) `FAILED_EXP(5, mut.f, H[13]);
        if (mut.g !== H[14]) `FAILED_EXP(6, mut.g, H[14]);
        if (mut.h !== H[15]) `FAILED_EXP(7, mut.h, H[15]);
    end

    ST1_HASH_DYN_BLOCK: begin
        CMD <= mut.CMD_IDLE;
        test_state <= ST1_STORE_ROUND1_HASH_IN_M;

        `INFO("=== Verifying register values after hash operation (block 2)===");
        if (mut.a !== E_REG2[0]) `FAILED_EXP(0, mut.a, E_REG2[0]);
        if (mut.b !== E_REG2[1]) `FAILED_EXP(1, mut.b, E_REG2[1]);
        if (mut.c !== E_REG2[2]) `FAILED_EXP(2, mut.c, E_REG2[2]);
        if (mut.d !== E_REG2[3]) `FAILED_EXP(3, mut.d, E_REG2[3]);
        if (mut.e !== E_REG2[4]) `FAILED_EXP(4, mut.e, E_REG2[4]);
        if (mut.f !== E_REG2[5]) `FAILED_EXP(5, mut.f, E_REG2[5]);
        if (mut.g !== E_REG2[6]) `FAILED_EXP(6, mut.g, E_REG2[6]);
        if (mut.h !== E_REG2[7]) `FAILED_EXP(7, mut.h, E_REG2[7]);
    end

    ST1_STORE_ROUND1_HASH_IN_M: begin
        CMD <= mut.CMD_IDLE;
        test_state <= ST1_LOAD_DEFAULT_H_R2;

        `INFO("=== Verifying H values after summing and storing (Block 2)===");
        for (integer i=0; i<8;i++)
            if (M[i+32] !== EM1[i])
                `FAILED_EXP(i, M[i+32], EM1[i]);
    end

    ST1_LOAD_DEFAULT_H_R2: begin
        CMD <= mut.CMD_IDLE;
        test_state <= ST1_HASH_ROUND1_HASH;

         `INFO("=== Verifying register values after loading H values (block 3)===");
        if (mut.a !== H[0]) `FAILED_EXP(0, mut.a, H[0]);
        if (mut.b !== H[1]) `FAILED_EXP(1, mut.b, H[1]);
        if (mut.c !== H[2]) `FAILED_EXP(2, mut.c, H[2]);
        if (mut.d !== H[3]) `FAILED_EXP(3, mut.d, H[3]);
        if (mut.e !== H[4]) `FAILED_EXP(4, mut.e, H[4]);
        if (mut.f !== H[5]) `FAILED_EXP(5, mut.f, H[5]);
        if (mut.g !== H[6]) `FAILED_EXP(6, mut.g, H[6]);
        if (mut.h !== H[7]) `FAILED_EXP(7, mut.h, H[7]);
    end

    ST1_HASH_ROUND1_HASH: begin
        CMD <= mut.CMD_IDLE;
        test_state <= ST1_GET_DIGEST;

        `INFO("=== Verifying register values after hash operation (block 3) ===");
        if (mut.a !== E_REG3[0]) `FAILED_EXP(0, mut.a, E_REG3[0]);
        if (mut.b !== E_REG3[1]) `FAILED_EXP(1, mut.b, E_REG3[1]);
        if (mut.c !== E_REG3[2]) `FAILED_EXP(2, mut.c, E_REG3[2]);
        if (mut.d !== E_REG3[3]) `FAILED_EXP(3, mut.d, E_REG3[3]);
        if (mut.e !== E_REG3[4]) `FAILED_EXP(4, mut.e, E_REG3[4]);
        if (mut.f !== E_REG3[5]) `FAILED_EXP(5, mut.f, E_REG3[5]);
        if (mut.g !== E_REG3[6]) `FAILED_EXP(6, mut.g, E_REG3[6]);
        if (mut.h !== E_REG3[7]) `FAILED_EXP(7, mut.h, E_REG3[7]);
    end

    ST1_GET_DIGEST: begin
        CMD <= mut.CMD_IDLE;
        test_state <= ST_INC_NONCE;

        `INFO("=== Verifying digest 1st SHA256D round ===");
        if (RES != ERES[0])
            `FAILED_EXP(0, RES, ERES[0]);
    end

    ST2_LOAD_STATIC_BLOCK_HASH_FROM_H: test_state <= ST2_HASH_DYN_BLOCK;
    ST2_HASH_DYN_BLOCK:                test_state <= ST2_STORE_ROUND1_HASH_IN_M;
    ST2_STORE_ROUND1_HASH_IN_M:        test_state <= ST2_LOAD_DEFAULT_H_R2;
    ST2_LOAD_DEFAULT_H_R2:             test_state <= ST2_HASH_ROUND1_HASH;
    ST2_HASH_ROUND1_HASH:              test_state <= ST2_GET_DIGEST;
    ST2_GET_DIGEST: begin
        `INFO("=== Verifying digest 2nd SHA256D round ===");
        if (RES != ERES[1])
            `FAILED_EXP(0, RES, ERES[1]);
        test_state <= ST_FINISH;
    end


    endcase
    

end


always @(negedge CLK) begin
    case(test_state) 
    // Simulates storing the hash
    ST1_STORE_STATIC_BLOCK_HASH_IN_H: begin
        H[HA+8] = HD_OUT;
    end
    ST1_STORE_ROUND1_HASH_IN_M: begin
        M[HA+32] = MD_OUT;
    end
    ST2_STORE_ROUND1_HASH_IN_M: begin
        M[HA+32] = MD_OUT;
    end
    endcase
end




endmodule



