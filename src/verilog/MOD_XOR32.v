module MOD_XOR32 (
    input [0:31] A,
    input [0:31] B,
    output [0:31] Y
);

genvar i;

generate 
    for (i=0; i < 32; i = i + 4) begin
        assign Y[i:i+3] = A[i:i+3] ^ B[i:i+3];        
    end
endgenerate
endmodule