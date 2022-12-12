module MOD_S1_TB;
`INIT

MOD_S1 mut(
    A,Y
);

reg [0:31] A;
wire [0:31] Y;

localparam period = 20;  

initial begin
    `SET_MOD("MOD_S1_TB");
    $dumpfile("./build/MOD_S1_TB.vcd");
    $dumpvars(0, MOD_S1_TB);
    $timeformat(-6, 0, " us", 20);



    

    A = 32'b11111111111111111111111111111111; 
    #period
    if (Y != 32'b00000000001111111111111111111111)
        `FAILED("Test 1 failed");
    

    A = 32'b11111111111111110000000000000000; 
    #period
    if (Y != 32'b01100000001111111001111111000000) 
        `FAILED("Test 2 failed");

    A = 32'b11110000111100001111000011110000; 
    #period
    if (Y != 32'b01100110010110100101101001011010) 
        `FAILED("Test 3 failed");

    A = 32'b11001100110011001100110011001100; 
    #period
    if (Y != 32'b11111111110011001100110011001100) 
        `FAILED("Test 4 failed");

    A = 32'b10101010101010101010101010101010; 
    #period
    if (Y != 32'b00000000001010101010101010101010) 
        `FAILED("Test 5 failed");



  


end

endmodule