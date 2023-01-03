module MOD_SHA256_TB;
`INIT

MOD_SHA256 mut(CLK);


reg CLK;

localparam period = 20;  

initial begin
    `SET_MOD("MOD_SHA256_TB");
    $dumpfile("./build/MOD_SHA256_TB.vcd");
    $dumpvars(0, MOD_SHA256_TB);
    $timeformat(-6, 0, " us", 20);

    CLK = 0;

    #50000
    `FAILED("TIMEOUT");


    $finish();
end

// Setup clock signal
always #period CLK = ~CLK;


reg [31:0] HE [8];

initial begin
HE[0] = 32'h6a09e667;
HE[1] = 32'hbb67ae85;
HE[2] = 32'h3c6ef372;
HE[3] = 32'ha54ff53a;
HE[4] = 32'h510e527f;
HE[5] = 32'h9b05688c;
HE[6] = 32'h1f83d9ab;
HE[7] = 32'h5be0cd19;
end

always @(mut.state) begin
    if (mut.state == mut.MEM_INIT_DONE) begin
        reg [31:0] value;
        // Verify if the H-values are loaded correctly
        for (integer i =0; i<8;i++) begin
            value = {mut.hk_mem.RAM.bank_1.buffer[i],
                     mut.hk_mem.RAM.bank_2.buffer[i],
                     mut.hk_mem.RAM.bank_3.buffer[i],
                     mut.hk_mem.RAM.bank_4.buffer[i]};
            if (value !== HE[i])
                `FAILED_EXP(i, value, HE[i]);
        end
    end
end

endmodule