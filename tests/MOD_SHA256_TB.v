module MOD_SHA256_TB;
`INIT

MOD_SHA256 mut(CLK, OPERATION, HA, HD, MA, MD, RDY);
wire [7:0] HA, MA;
output reg [31:0] HD, MD;
wire RDY;

assign HD = H[HA];



localparam period = 20;  

initial begin
    `SET_MOD("MOD_SHA256_TB");
    $dumpfile("./build/MOD_SHA256_TB.vcd");
    $dumpvars(0, MOD_SHA256_TB);
    $timeformat(-6, 0, " us", 20);

    #20000
    `FAILED("TIMEOUT");


    $finish();
end

// Setup clock signal
reg [15:0] clk_count;
reg CLK;
initial begin 
    CLK = 0;
    clk_count = 0;
end
always begin 
    #period CLK = ~CLK;
    if (CLK) clk_count++;
end




// Setup H-values
reg [31:0] H [8];
initial begin
H[0] = 32'h6a09e667;
H[1] = 32'hbb67ae85;
H[2] = 32'h3c6ef372;
H[3] = 32'ha54ff53a;
H[4] = 32'h510e527f;
H[5] = 32'h9b05688c;
H[6] = 32'h1f83d9ab;
H[7] = 32'h5be0cd19;
end


// Setup K-constants
reg [31:0] K [64];
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


// Setup message block

// Block header:
// 0100000000000000000000000000000000000000000000000000000000000000000000003ba3edfd7a7b12b27ac72c3e67768f617fc81bc3888a51323a9fb8aa4b1e5e4a29ab5f49ffff001d1dac2b7c
reg [31:0] M [32]; // 1024 bit message block
initial begin

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
 M[31] = 32'b00000000000000000000000000000000;
 M[32] = 32'b00000000000000000000001010000000;
end




// MUT state
output reg [7:0] OPERATION;
localparam OP_IDLE = 0;
localparam OP_RESET_H = 10;
initial OPERATION = OP_IDLE;

// Test State 
reg [7:0] test_state;

localparam ST_TEST_IDLE = 0;
localparam ST_TEST_RESET_H = 10;
localparam ST_TEST_VERIFY_RESET_H = 20;
localparam ST_FINISHED = 100;
initial test_state = ST_TEST_IDLE;


always @(posedge CLK, negedge CLK) begin
    case(test_state)
    ST_TEST_IDLE: begin
        test_state = ST_TEST_RESET_H;

    end
    ST_TEST_RESET_H: begin
        OPERATION = ST_TEST_RESET_H;
        if (RDY) test_state <= ST_TEST_VERIFY_RESET_H;
    end
    ST_TEST_VERIFY_RESET_H: begin
        for (integer i = 0; i <8; i++) begin
            if (mut.H[i] !== H[i])
                `FAILED_EXP(i, mut.H[i], H[i]);
        end
        test_state <= ST_FINISHED;
    end
    ST_FINISHED: begin
        `SUCCESS("Done");
        $finish();
    end
    endcase

end



// always @(mut.state) begin
//     if (mut.state == mut.MEM_INIT_DONE) begin
//         reg [31:0] value;
//         // Verify if the H-values are loaded correctly
//         $display("Verifying H values");
//         for (integer i =0; i<8;i++) begin
//             value = {mut.hk_mem.RAM.bank_1.buffer[i],
//                      mut.hk_mem.RAM.bank_2.buffer[i],
//                      mut.hk_mem.RAM.bank_3.buffer[i],
//                      mut.hk_mem.RAM.bank_4.buffer[i]};
//             if (value !== H[i])
//                 `FAILED_EXP(i, value, H[i]);
//         end
//     end
// end

endmodule