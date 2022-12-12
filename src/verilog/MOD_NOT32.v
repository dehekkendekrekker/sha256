module MOD_NOT32 (
    input [0:31] A,
    output [0:31] Y
);

genvar i;

generate 
    for (i=0; i < 32; i = i + 4) begin
        assign Y[i:i+3] = ~A[i:i+3];        
    end
endgenerate
endmodule