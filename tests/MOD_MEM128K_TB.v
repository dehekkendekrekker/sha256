module MOD_MEM128K_TB;
`INIT

MOD_MEM128K mut(
    A,IO,CS,OE,WE
);

reg [0:14] A;
wire [0:31] IO;
reg [0:31] IO_DRIVE;
wire [0:31] IO_RECV;
reg CS;
reg OE;
reg WE;

localparam period = 20;  
assign IO = IO_DRIVE;
assign IO_RECV = IO;

initial begin
    `SET_MOD("MOD_MEM128K_TB");
    $dumpfile("./build/MOD_MEM128K_TB.vcd");
    $dumpvars(0, MOD_MEM128K_TB);
    $timeformat(-6, 0, " us", 20);

    // Output enable is always active, since writing does not take this input into account
    OE = 0;

    // Test for WRITE cycle
    IO_DRIVE = 1;
    A = 0;
    CS = 1;
    WE = 1;
    #period
    if ({mut.bank_1.buffer[A],mut.bank_2.buffer[A],mut.bank_3.buffer[A],mut.bank_4.buffer[A]} !== 32'bx)
        `FAILED("WC: Buffer should be 0 when CS and WE high");

    CS = 0;
    #period
    if ({mut.bank_1.buffer[A],mut.bank_2.buffer[A],mut.bank_3.buffer[A],mut.bank_4.buffer[A]} !== 32'bx)
        `FAILED("WC: Buffer should be 0 after only CS goes low");

    WE = 0;
    #period
    if ({mut.bank_1.buffer[A],mut.bank_2.buffer[A],mut.bank_3.buffer[A],mut.bank_4.buffer[A]} !== 1)
        `FAILED("WC: Buffer should be 1 after CS and WE are both low");
    

    // Now memory at position 0 contains 1

    // Test for READ cycle 1
    IO_DRIVE = 32'bZ;
    
    CS = 1;
    WE = 1; // Write enable is disabled
    #period
    if (IO_RECV  !== 32'bZ)
        `FAILED("RC: IO Should not have been set yet");

    CS = 0; // We active the chip, this should trigger a reas
    #period
    if (IO_RECV !== 1) begin
        `FAILED("RC: IO have taken the value of the buffer");
    end


    



end

endmodule