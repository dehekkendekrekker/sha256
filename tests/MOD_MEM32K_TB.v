module MOD_MEM32K_TB;
`INIT

MOD_MEM32K mut(
    A,IO,CS,OE,WE
);

reg [14:0] A;
wire [7:0] IO;
reg [7:0] IO_DRIVE;
wire [7:0] IO_RECV;
reg CS;
reg OE;
reg WE;


reg CLK;

localparam period = 20;  
assign IO = IO_DRIVE;
// assign IO_RECV = IO;

initial begin
    `SET_MOD("MOD_MEM32K_TB");
    $dumpfile("./build/MOD_MEM32K_TB.vcd");
    $dumpvars(0, MOD_MEM32K_TB);
    $timeformat(-6, 0, " us", 20);

    #1000
    $finish;
end


initial begin
    CLK = 0;
end

always #period CLK = ~CLK;


reg [7:0] state;

localparam NOOP = 0;

localparam PRE_READ_CYLCE_NR1 = 1;
localparam READ_CYLCE_NR1 = 10;

localparam PRE_READ_CYLCE_NR1_OE = 20;
localparam READ_CYLCE_NR1_OE = 25;

localparam PRE_READ_CYLCE_NR1_CS = 27;
localparam READ_CYLCE_NR1_CS = 30;

localparam PRE_READ_CYLCE_NR2 = 35;
localparam READ_CYLCE_NR2 = 40;

localparam PRE_WRITE_CYLCE_NR1 = 45;
localparam WRITE_CYLCE_NR1 = 50;

localparam PRE_WRITE_CYLCE_NR2 = 55;
localparam WRITE_CYLCE_NR2 = 60;




initial begin
    mut.buffer[0] = 8'h00;
    mut.buffer[1] = 8'h01;
    mut.buffer[2] = 8'h02;
    mut.buffer[3] = 8'h03;
    mut.buffer[4] = 8'h04;
    mut.buffer[5] = 8'h05;
    mut.buffer[6] = 8'h06;
    mut.buffer[7] = 8'h07;
end

initial begin
    state = NOOP;
end

// Use this to draw useful timing diagrams
always @(negedge CLK) begin
    case(state)
    PRE_READ_CYLCE_NR1: begin
        A = 0;
        OE = 1;
        CS = 1;        
        state = READ_CYLCE_NR1;
    end
    READ_CYLCE_NR1: begin
        CS = 0;
        OE = ~OE;
    end
    PRE_READ_CYLCE_NR1_CS: begin
        A = 0;
        OE = 1;
        CS = 1;    
        state = READ_CYLCE_NR1_CS;    
    end
    
    READ_CYLCE_NR1_CS: begin
        OE = 0;
        CS = ~CS;
    end

    PRE_READ_CYLCE_NR2: begin
        WE = 1;
        CS = 0;
        OE = 0;
        A = 0;
        state = READ_CYLCE_NR2;
    end
    READ_CYLCE_NR2: begin
        A = A + 1;
    end

    // Write cycle 1

    PRE_WRITE_CYLCE_NR1: begin
        A = 0;
        CS = 0;
        WE = 1;
        OE = 1;
        IO_DRIVE = 8'hFF;
        state = WRITE_CYLCE_NR1;
    end
    WRITE_CYLCE_NR1: begin
        WE = ~WE;
    end

    PRE_WRITE_CYLCE_NR2: begin
        A = 0;
        CS = 1;
        WE = 0;
        OE = 1;
        IO_DRIVE = 8'hEF;
        state = WRITE_CYLCE_NR2;
    end

    WRITE_CYLCE_NR2: begin
        CS = ~CS;
    end
   

    endcase
end




initial begin
    // Setup
    mut.buffer[8] = 8'hFF;
    IO_DRIVE = 8'bZ;
    A = 8;
    WE = 1; // Read
    CS = 1;  
    OE = 1;

    #period;
    // First test read, drop OE -> CS
    OE = 0;
    #period;
    CS = 0;
    #period;

    if (IO !== 8'hFF) `FAILED("1. Read failed");

    #period; 
    // Reset
    CS = 1;  
    OE = 1;

    #period;
    // First test read, drop CS -> OE
    OE = 0;
    #period;
    CS = 0;
    #period;

    if (IO !== 8'hFF) `FAILED("2. Read failed");

    // Read by changing address
    mut.buffer[9] = 8'hAA;
    A = 9;
    #period;
    if (IO !== 8'hAA) `FAILED("3. Read failed");

    // Write tests
    // WE controlled
    IO_DRIVE = 8'hBB;
    CS = 0;
    OE = 1; // Must be 1 for WE controlled writes
    WE = 1;
    A = 10;

    #period;
    WE = 0;
    #period;
    if (mut.buffer[10] !== 8'hBB) `FAILED("4. write failed");

    // CS controlled
    CS = 1;
    OE = 1'bx; // Does not matter
    WE = 1;
    IO_DRIVE = 8'hCC;

    #period;
    WE = 0;
    #period;
    CS = 0;
    #period;
    if (mut.buffer[10] !== 8'hCC) `FAILED("5. write failed");



    





end
  
endmodule



    // // Output enable is always active, since writing does not take this input into account
    // OE = 0;

    // // Test for WRITE cycle
    // IO_DRIVE = 1;
    // A = 0;
    // CS = 1;
    // WE = 1;
    // #period
    // if (mut.buffer[A] !== 8'bx)
    //     `FAILED("WC: Buffer should be 0 when CS and WE high");

    // CS = 0;
    // #period
    // if (mut.buffer[A] !== 8'bx)
    //     `FAILED("WC: Buffer should be 0 after only CS goes low");

    // WE = 0;
    // #period
    // if (mut.buffer[A] !== 1)
    //     `FAILED("WC: Buffer should be 1 after CS and WE are both low");
    

    // // Now memory at position 0 contains 1

    // // Test for READ cycle 1
    // IO_DRIVE = 8'bZ;
    
    // CS = 1;
    // WE = 1; // Write enable is disabled
    // #period
    // if (IO_RECV  !== 8'bZ)
    //     `FAILED("RC: IO Should not have been set yet");

    // CS = 0; // We active the chip, this should trigger a reas
    // #period
    // if (IO_RECV !== 1) begin
    //     `FAILED("RC: IO have taken the value of the buffer");
    // end


    


