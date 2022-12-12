module MOD_S0_TB;
`INIT

MOD_S0 mut(
    A,Y
);

reg [0:31] A;
wire [0:31] Y;

localparam period = 20;  

initial begin
    `SET_MOD("MOD_S0_TB");
    $dumpfile("./build/MOD_S0_TB.vcd");
    $dumpvars(0, MOD_S0_TB);
    $timeformat(-6, 0, " us", 20);



    

    A = 32'b11111111111111111111111111111111; 
    #period
    if (Y != 32'b00011111111111111111111111111111)
        `FAILED("Test 1 failed");
    

    A = 32'b11111111111111110000000000000000; 
    #period
    if (Y != 32'b11011110000000000010000111111111) 
        `FAILED("Test 2 failed");

    A = 32'b11110000111100001111000011110000; 
    #period
    if (Y != 32'b11000011110000111100001111000011) 
        `FAILED("Test 3 failed");

    A = 32'b11001100110011001100110011001100; 
    #period
    if (Y != 32'b10110011001100110011001100110011) 
        `FAILED("Test 4 failed");

    A = 32'b10101010101010101010101010101010; 
    #period
    if (Y != 32'b11101010101010101010101010101010) 
        `FAILED("Test 5 failed");



  


end

endmodule