module MOD_S1(
    input [31:0] A,
    output [31:0] Y
);


    assign Y = {A[16:0],      A[31:17]} ^
                {A[18:0],      A[31:19]} ^
                {10'b0000000000, A[31:10]};
    
endmodule
