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

endmodule