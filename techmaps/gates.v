
/*
This block only deals with $and gates of width 32. All other widths are handled differently.
*/
module \$and (A,B,Y);

parameter A_SIGNED = 0;
parameter B_SIGNED = 0;

parameter A_WIDTH = 0;
parameter B_WIDTH = 0;
parameter Y_WIDTH = 0;

input [A_WIDTH-1:0] A;
input [B_WIDTH-1:0] B;
output [Y_WIDTH-1:0] Y;

wire _TECHMAP_FAIL_= (A_WIDTH !=32 || B_WIDTH != 32 || Y_WIDTH != 32);

genvar i;

if (A_WIDTH == 32) begin
    generate 
        for (i=0; i < 32; i = i + 4) begin
            // assign Y[i:i+3] = A[i:i+3] & B[i:i+3];        
            AND4 and_i(.A(A[i:i+3]), .B(B[i:i+3]), .Y(Y[i:i+3]));
            
        end
    endgenerate
end



endmodule


/*
This block only deals with $xor gates of width 32. All other widths are handled differently.
*/
module \$xor (A,B,Y);

parameter A_SIGNED = 0;
parameter B_SIGNED = 0;

parameter A_WIDTH = 0;
parameter B_WIDTH = 0;
parameter Y_WIDTH = 0;

input [A_WIDTH-1:0] A;
input [B_WIDTH-1:0] B;
output [Y_WIDTH-1:0] Y;

wire _TECHMAP_FAIL_= (A_WIDTH !=32 || B_WIDTH != 32 || Y_WIDTH != 32);

genvar i;

if (A_WIDTH == 32) begin
    generate 
        for (i=0; i < 32; i = i + 4) begin
            XOR4 xor_i(.A(A[i:i+3]), .B(B[i:i+3]), .Y(Y[i:i+3]));
        end
    endgenerate
end



endmodule


/*
This block only deals with $not gates of width 32. All other widths are handled differently.
*/
module \$not (A,Y);

parameter A_SIGNED = 0;

parameter A_WIDTH = 0;
parameter Y_WIDTH = 0;

input [A_WIDTH-1:0] A;
output [Y_WIDTH-1:0] Y;

wire _TECHMAP_FAIL_= (A_WIDTH !=32 || Y_WIDTH != 32);

genvar i;

if (A_WIDTH == 32) begin
    generate 
        for (i=0; i < 32; i = i + 4) begin
            NOT not_i(.A(A[i:i+3]), .Y(Y[i:i+3]));
        end
    endgenerate
end



endmodule

