module MOD_MEM32K_TB;
`INIT

MOD_MEM32K mut(
    A,IO,CS,OE,WE
);

reg [0:14] A;
wire [0:7] IO;
reg [0:7] IO_DRIVE;
wire [0:7] IO_RECV;
reg CS;
reg OE;
reg WE;

localparam period = 20;  
assign IO = IO_DRIVE;
assign IO_RECV = IO;

initial begin
    // `SET_MOD("MOD_MEM32K_TB");
    $dumpfile("./build/MOD_MEM32K_TB.vcd");
    $dumpvars(0, MOD_MEM32K_TB);
    $timeformat(-6, 0, " us", 20);

    // Output enable is always active, since writing does not take this input into account
    OE = 0;

    // Test for WRITE cycle
    IO_DRIVE = 1;
    A = 0;
    CS = 1;
    WE = 1;
    #period
    if (mut.buffer[A] !== 8'bx)
        `FAILED("WC: Buffer should be 0 when CS and WE high");

    CS = 0;
    #period
    if (mut.buffer[A] !== 8'bx)
        `FAILED("WC: Buffer should be 0 after only CS goes low");

    WE = 0;
    #period
    if (mut.buffer[A] !== 1)
        `FAILED("WC: Buffer should be 1 after CS and WE are both low");
    

    // Now memory at position 0 contains 1

    // Test for READ cycle 1
    IO_DRIVE = 8'bZ;
    
    CS = 1;
    WE = 1; // Write enable is disabled
    #period
    if (IO_RECV  !== 8'bZ)
        `FAILED("RC: IO Should not have been set yet");

    CS = 0; // We active the chip, this should trigger a reas
    #period
    if (IO_RECV !== 1) begin
        $display("%b", IO_RECV);
        $display("%b", mut.buffer[A]);
        $display("%b", mut.drive_output);
        `FAILED("RC: IO have taken the value of the buffer");
    end


    



end

endmodule