module MOD_MEMMGR_TB;
`INIT

MOD_MEMMGR mut(
    CLK,INIT,INIT_COMPLETE
);



reg CLK;
reg INIT; // When positive, the init sequence of the memory manager will run

localparam period = 20;  


initial begin
    `SET_MOD("MOD_MEMMGR_TB");
    $dumpfile("./build/MOD_MEMMGR_TB.vcd");
    $dumpvars(0, MOD_MEMMGR_TB);
    $timeformat(-6, 0, " us", 20);
    CLK = 0;


    #20000
    $finish();

end


// Setup clock signal
always #period CLK = ~CLK;


// Execute
initial begin
    INIT <= 1;
end

always @(posedge INIT_COMPLETE)
    INIT <= 0;



endmodule
