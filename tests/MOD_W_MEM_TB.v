module MOD_W_MEM_TB;
`INIT

MOD_W_MEM mut(I, D_IN, D_OUT);

reg CLK, COMPLETE;
reg [5:0] I;
reg [31:0] D_IN;
wire [31:0] D_OUT;

localparam period = 20;  


reg [31:0] W [64];
reg [31:0] E [64];


initial begin
    `SET_MOD("MOD_W_MEM_TB");
    $dumpfile("./build/MOD_W_MEM_TB.vcd");
    $dumpvars(0, MOD_W_MEM_TB);
    $timeformat(-6, 0, " us", 20);

    #20000
    $finish();
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


initial begin
    E[0] = 32'b01001000011001010110110001101100;
    E[1] = 32'b01101111001000000111011101101111;
    E[2] = 32'b01110010011011000110010000100001;
    E[3] = 32'b10000000000000000000000000000000;
    E[4] = 32'b00000000000000000000000000000000;
    E[5] = 32'b00000000000000000000000000000000;
    E[6] = 32'b00000000000000000000000000000000;
    E[7] = 32'b00000000000000000000000000000000;
    E[8] = 32'b00000000000000000000000000000000;
    E[9] = 32'b00000000000000000000000000000000;
    E[10] = 32'b00000000000000000000000000000000;
    E[11] = 32'b00000000000000000000000000000000;
    E[12] = 32'b00000000000000000000000000000000;
    E[13] = 32'b00000000000000000000000000000000;
    E[14] = 32'b00000000000000000000000000000000;
    E[15] = 32'b00000000000000000000000001100000;
    E[16] = 32'b00010111010001110000001000110111;
    E[17] = 32'b11000100111111011000000001000110;
    E[18] = 32'b11100100110001010011110010101100;
    E[19] = 32'b11110000000110101000010110000001;
    E[20] = 32'b00111001111110101101111110110101;
    E[21] = 32'b00010010010011001100000010101111;
    E[22] = 32'b00110100001000100100010111010101;
    E[23] = 32'b00001111100011011111101010010110;
    E[24] = 32'b00101111010110101011010001001010;
    E[25] = 32'b00100110110111110110000111110101;
    E[26] = 32'b11111100110000100000101001101100;
    E[27] = 32'b10010110110010000110000000100001;
    E[28] = 32'b01010110100100011001001000101010;
    E[29] = 32'b01110000010100111001000101111010;
    E[30] = 32'b11001010111010111100000010100000;
    E[31] = 32'b10010110001101001100001100000100;
    E[32] = 32'b11001011101001010010010100111011;
    E[33] = 32'b11000110000000001111010001111011;
    E[34] = 32'b01101110000110010010110001111001;
    E[35] = 32'b10000101110100010001001111011111;
    E[36] = 32'b11001010001111010101001010111010;
    E[37] = 32'b11000110100001110000100010011110;
    E[38] = 32'b00100000110110101110001100101010;
    E[39] = 32'b01111101010001111010001001011001;
    E[40] = 32'b01011010001111110010011011011101;
    E[41] = 32'b11111111011011000100100110111010;
    E[42] = 32'b01000100001100111010000101010010;
    E[43] = 32'b01001001110100010011001011101001;
    E[44] = 32'b11100000010111110100101001011000;
    E[45] = 32'b11111001010010110000101101110001;
    E[46] = 32'b10111111101111101011001101011010;
    E[47] = 32'b11111101000010011001011100110011;
    E[48] = 32'b00101101010011100100010101100000;
    E[49] = 32'b10110111011101101010010101011110;
    E[50] = 32'b10001101010010000000000100101001;
    E[51] = 32'b00100100110101110001000110110000;
    E[52] = 32'b10101011100101010110000111011011;
    E[53] = 32'b11011001101111010100000011000010;
    E[54] = 32'b10010000101001001110010010011011;
    E[55] = 32'b00101011001010100000110010001011;
    E[56] = 32'b01111001001011100100111000111001;
    E[57] = 32'b00011000111011010000011110111010;
    E[58] = 32'b11101110111001000110000101101111;
    E[59] = 32'b10010111111100000111100010110110;
    E[60] = 32'b10110100110001011100011111111010;
    E[61] = 32'b11001011101101100101101000000110;
    E[62] = 32'b01100011101011111101101111111010;
    E[63] = 32'b10110001010101001001011000011100;    
end

// Setup clock signal
always #period CLK = ~CLK;


initial begin
    I = 0;
    COMPLETE = 0;
    CLK = 1;
    D_IN = W[I];
end

always @(negedge CLK) begin
    
end

// Counter behaviour
always @(posedge CLK) begin
    I = I + 1;
    D_IN = W[I];
    

    if (I == 0)
        COMPLETE <= 1;
end

always @(D_OUT) begin
    W[I] = D_OUT;
end


always @(posedge COMPLETE) begin
    for (integer i = 0; i < 64; i=i+1) begin
        if(W[i] !== E[i])
            `FAILED_EXP(i, W[i], E[i]);
    end
    $finish();
end







endmodule



