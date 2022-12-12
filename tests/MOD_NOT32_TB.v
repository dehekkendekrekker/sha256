module MOD_NOT32_TB;
`INIT

MOD_NOT32 mut(
    A,Y
);

reg [0:31] A;
wire [0:31] Y;

localparam period = 20;  

initial begin
    `SET_MOD("MOD_NOT32_TB");
    $dumpfile("./build/MOD_NOT32_TB.vcd");
    $dumpvars(0, MOD_NOT32_TB);
    $timeformat(-6, 0, " us", 20);



    

    A = 32'b11111111111111111111111111111111; 
    #period
    if (Y != 32'b00000000000000000000000000000000)
        `FAILED("Test 1 failed");
    

    A = 32'b00000000000000000000000000000000;
    #period
    if (Y != 32'b11111111111111111111111111111111) 
        `FAILED("Test 2 failed");

  

    



  


end

endmodule