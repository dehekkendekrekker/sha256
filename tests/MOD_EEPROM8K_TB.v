module MOD_EEPROM8K_TB;
`INIT

MOD_EEPROM8K_1 mut1(A,IO_1,CE,OE,WE);
MOD_EEPROM8K_2 mut2(A,IO_2,CE,OE,WE);
MOD_EEPROM8K_3 mut3(A,IO_3,CE,OE,WE);
MOD_EEPROM8K_4 mut4(A,IO_4,CE,OE,WE);

reg [0:12] A;
wire [0:7] IO_1;
wire [0:7] IO_2;
wire [0:7] IO_3;
wire [0:7] IO_4;
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
    if (IO_1 !== 8'h6a) begin
        `FAILED("RC: IO_1 should have taken the first value of the H constant");
    end

    if (IO_2 !== 8'h09) begin
        `FAILED("RC: IO_2 should have taken the first value of the H constant");
    end

    if (IO_3 !== 8'he6) begin
        `FAILED("RC: IO_3 should have taken the first value of the H constant");
    end

    if (IO_4 !== 8'h67) begin
        `FAILED("RC: IO_4 should have taken the first value of the H constant");
    end

    CE = 1;
    A  = 8;
    #period
    CE = 0;
    # period
    if (IO_1 !== 8'h42) begin
        `FAILED("RC: IO_1 should have taken the first value of the K constant");
    end

    # period
    if (IO_2 !== 8'h8a) begin
        `FAILED("RC: IO_2 should have taken the first value of the K constant");
    end

    # period
    if (IO_3 !== 8'h2f) begin
        `FAILED("RC: IO_3 should have taken the first value of the K constant");
    end

    # period
    if (IO_4 !== 8'h98) begin
        `FAILED("RC: IO_4 should have taken the first value of the K constant");
    end


    



    



end

endmodule