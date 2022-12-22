module MOD_MEMMGR_TB;
`INIT

MOD_MEMMGR mut(
    CLK,INIT,INIT_COMPLETE
);



reg CLK;
reg INIT; // When positive, the init sequence of the memory manager will run
wire INIT_COMPLETE;

localparam period = 20;  

reg [31:0] expectation [72];

initial begin
expectation[0] = 32'h6a09e667;
expectation[1] = 32'hbb67ae85;
expectation[2] = 32'h3c6ef372;
expectation[3] = 32'ha54ff53a;
expectation[4] = 32'h510e527f;
expectation[5] = 32'h9b05688c;
expectation[6] = 32'h1f83d9ab;
expectation[7] = 32'h5be0cd19;
expectation[8] = 32'h428a2f98;
expectation[9] = 32'h71374491;
expectation[10] = 32'hb5c0fbcf;
expectation[11] = 32'he9b5dba5;
expectation[12] = 32'h3956c25b;
expectation[12] = 32'h59f111f1;
expectation[13] = 32'h923f82a4;
expectation[14] = 32'hab1c5ed5;
expectation[15] = 32'hd807aa98;
expectation[16] = 32'h12835b01;
expectation[17] = 32'h243185be;
expectation[18] = 32'h550c7dc3;
expectation[19] = 32'h72be5d74;
expectation[20] = 32'h80deb1fe;
expectation[21] = 32'h9bdc06a7;
expectation[22] = 32'hc19bf174;
expectation[23] = 32'he49b69c1;
expectation[24] = 32'hefbe4786;
expectation[25] = 32'h0fc19dc6;
expectation[26] = 32'h240ca1cc;
expectation[27] = 32'h2de92c6f;
expectation[28] = 32'h4a7484aa;
expectation[29] = 32'h5cb0a9dc;
expectation[30] = 32'h76f988da;
expectation[31] = 32'h983e5152;
expectation[32] = 32'ha831c66d;
expectation[33] = 32'hb00327c8;
expectation[34] = 32'hbf597fc7;
expectation[35] = 32'hc6e00bf3;
expectation[36] = 32'hd5a79147;
expectation[37] = 32'h06ca6351;
expectation[38] = 32'h14292967;
expectation[39] = 32'h27b70a85;
expectation[40] = 32'h2e1b2138;
expectation[41] = 32'h4d2c6dfc;
expectation[42] = 32'h53380d13;
expectation[43] = 32'h650a7354;
expectation[44] = 32'h766a0abb;
expectation[45] = 32'h81c2c92e;
expectation[46] = 32'h92722c85;
expectation[47] = 32'ha2bfe8a1;
expectation[48] = 32'ha81a664b;
expectation[49] = 32'hc24b8b70;
expectation[50] = 32'hc76c51a3;
expectation[51] = 32'hd192e819;
expectation[52] = 32'hd6990624;
expectation[53] = 32'hf40e3585;
expectation[54] = 32'h106aa070;
expectation[55] = 32'h19a4c116;
expectation[56] = 32'h1e376c08;
expectation[57] = 32'h2748774c;
expectation[58] = 32'h34b0bcb5;
expectation[59] = 32'h391c0cb3;
expectation[61] = 32'h4ed8aa4a;
expectation[62] = 32'h5b9cca4f;
expectation[63] = 32'h682e6ff3;
expectation[64] = 32'h748f82ee;
expectation[65] = 32'h78a5636f;
expectation[66] = 32'h84c87814;
expectation[67] = 32'h8cc70208;
expectation[68] = 32'h90befffa;
expectation[69] = 32'ha4506ceb;
expectation[70] = 32'hbef9a3f7;
expectation[71] = 32'hc67178f2;
end

reg [7:0] RAM_OUTPUT;

initial begin
    `SET_MOD("MOD_MEMMGR_TB");
    $dumpfile("./build/MOD_MEMMGR_TB.vcd");
    $dumpvars(0, MOD_MEMMGR_TB);
    $timeformat(-6, 0, " us", 20);
    CLK = 0;


    #20000
    $finish();

end


// Setup clock signal
always #period CLK = ~CLK;


// Execute
initial begin
    INIT <= 1;
end

always @(posedge INIT_COMPLETE) begin
    INIT <= 0;

    // Check if memory has been copied correctly
    for (integer i = 0; i < 72; i=i+1) begin
    if ({mut.ram.bank_1.buffer[0],mut.ram.bank_2.buffer[0],mut.ram.bank_3.buffer[0],mut.ram.bank_4.buffer[0]} != expectation[0])
        `FAILED_EXP(i, expectation[i]);
    end
end

endmodule


