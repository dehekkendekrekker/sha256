module MOD_EEPROM32K_TB;
`INIT

MOD_EEPROM32K mut1(A,IO,CE,OE,WE);

reg [0:12] A;
wire [0:31] IO;
reg CE;
reg OE;
reg WE;

localparam period = 175;  

initial begin
    `SET_MOD("MOD_EEPROM32K_TB");
    $dumpfile("./build/MOD_EEPROM32K_TB.vcd");
    $dumpvars(0, MOD_EEPROM32K_TB);
    $timeformat(-6, 0, " us", 20);

    
    A = 0;
    OE = 0; // Ouput is enabled by default
    WE = 1; // Write enable is disabled
    CE = 1; // Chip is disabled


    #period
    CE = 0; // We active the chip, this should trigger a reas
    #period
    if (IO !== 32'h6a09e667) begin
        `FAILED("RC: IO should have taken the first value of the H constant");
    end

    
    CE = 1;
    A  = 8;
    #period
    CE = 0;
    # period
    if (IO !== 32'h428a2f98) begin
        `FAILED("RC: IO should have taken the first value of the K constant");
    end

    


    



    



end

endmodule