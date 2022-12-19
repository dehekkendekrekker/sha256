module MOD_EEPROM8K_TB;
`INIT

MOD_EEPROM8K mut(
    A,IO,CE,OE,WE
);

reg [0:12] A;
wire [0:7] IO;
reg CE;
reg OE;
reg WE;

localparam period = 20;  

initial begin
    `SET_MOD("MOD_EEPROM8K_TB");
    $dumpfile("./build/MOD_EEPROM8K_TB.vcd");
    $dumpvars(0, MOD_EEPROM8K_TB);
    $timeformat(-6, 0, " us", 20);

    
    A = 0;
    OE = 0; // Ouput is enabled by default
    WE = 1; // Write enable is disabled
    CE = 1; // Chip is disabled


    #period
    CE = 0; // We active the chip, this should trigger a reas
    #period
    if (IO !== 8'h6a) begin
        `FAILED("RC: IO should have taken the first value of the H constant");
    end

    CE = 1;
    A  = 32;
    #period
    CE = 0;
    # period
    if (IO !== 8'h42) begin
        `FAILED("RC: IO should have taken the first value of the K constant");
    end


    



    



end

endmodule