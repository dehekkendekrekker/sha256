module MOD_SHA256_TB;
`INIT

MOD_SHA256 mut(CLK, W);


reg CLK;
wire [31:0] W;

localparam period = 20;  

initial begin
    `SET_MOD("MOD_SHA256_TB");
    $dumpfile("./build/MOD_SHA256_TB.vcd");
    $dumpvars(0, MOD_SHA256_TB);
    $timeformat(-6, 0, " us", 20);

    CLK = 0;

    #20000

    // Check K constants
    `INFO("Checking W");
    for (integer i = 0; i < 64; i=i+1) begin
        $display("%d: %b", i, mut.W[i]);
    end


    $finish();
end

// Setup clock signal
always #period CLK = ~CLK;

endmodule