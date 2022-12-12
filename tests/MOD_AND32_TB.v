module MOD_AND32_TB;
`INIT

MOD_AND32 mut(
    A,B,Y
);

reg [0:31] A;
reg [0:31] B;
wire [0:31] Y;

localparam period = 20;  

initial begin
    `SET_MOD("MOD_AND32_TB");
    $dumpfile("./build/MOD_AND32_TB.vcd");
    $dumpvars(0, MOD_AND32_TB);
    $timeformat(-6, 0, " us", 20);



    

    A = 32'b11111111111111111111111111111111; 
    B = 32'b11111111111111111111111111111111; 
    #period
    if (Y != 32'b11111111111111111111111111111111)
        `FAILED("Test 1 failed");
    

    A = 32'b11111111111111111111111111111111; 
    B = 32'b00000000000000000000000000000000;
    #period
    if (Y != 32'b00000000000000000000000000000000) 
        `FAILED("Test 2 failed");

    A = 32'b00000000000000000000000000000000;
    B = 32'b11111111111111111111111111111111; 
    #period
    if (Y != 32'b00000000000000000000000000000000) 
        `FAILED("Test 3 failed");

    A = 32'b00000000000000000000000000000000; 
    B = 32'b00000000000000000000000000000000;
    #period
    if (Y != 32'b00000000000000000000000000000000) 
        `FAILED("Test 4 failed");

    



  


end

endmodule