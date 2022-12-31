module MOD_COUNTER_TB;
`INIT

MOD_COUNTER mut(CLK, RST, D);

reg CLK, RST;
wire [7:0] D;

reg [7:0] E;

initial begin
    `SET_MOD("MOD_COUNTER_TB");
    $dumpfile("./build/MOD_COUNTER_TB.vcd");
    $dumpvars(0, MOD_COUNTER_TB);
    $timeformat(-6, 0, " us", 20);

    // Pull clear lines high. This device requires to start like this
    RST = 1;
    CLK = 1;


    #2000
    $finish();
end


localparam period = 20;

// Define clock
always #period CLK = ~CLK;

initial begin
    E = 0;
end

/**
This test checks if every negative clock edge will cause the counter to increase Bank 1 of the IC
*/
always @(negedge CLK) begin
    RST = 0;
    #period
    E = (E + 1) % 256;
    if (D !== E)
        `FAILED_EXP(E, D, E);
end


endmodule