// 74x04 - Hex inverter. Gate 1
module MOD_74x04_1 (A, Y);

parameter A_SIGNED = 0;
parameter A_WIDTH = 0;
parameter Y_WIDTH = 0;

input A;
output Y;

NOT _TECHMAP_REPLACE_(.A(A), .Y(Y));

endmodule



module MOD_74x04_2 (A, Y);

parameter A_SIGNED = 0;
parameter A_WIDTH = 0;
parameter Y_WIDTH = 0;

input [1:0] A;
output [1:0]Y;

NOT _TECHMAP_REPLACE_(.A(A), .Y(Y));

endmodule

module MOD_74x04_2_SPLIT (A, Y);

parameter A_SIGNED = 0;
parameter A_WIDTH = 0;
parameter Y_WIDTH = 0;

input [1:0] A;
output [1:0]Y;

NOT _TECHMAP_REPLACE_(.A(A), .Y(Y));

endmodule
module MOD_74x04_3 (A, Y);

parameter A_SIGNED = 0;
parameter A_WIDTH = 0;
parameter Y_WIDTH = 0;

input [2:0] A;
output [2:0]Y;

NOT _TECHMAP_REPLACE_(.A(A), .Y(Y));

endmodule

module MOD_74x04_3_SPLIT (A, Y);

parameter A_SIGNED = 0;
parameter A_WIDTH = 0;
parameter Y_WIDTH = 0;

input [2:0] A;
output [2:0]Y;

NOT _TECHMAP_REPLACE_(.A(A), .Y(Y));

endmodule


module MOD_74x04_4 (A, Y);

parameter A_SIGNED = 0;
parameter A_WIDTH = 0;
parameter Y_WIDTH = 0;

input [3:0] A;
output [3:0]Y;

NOT _TECHMAP_REPLACE_(.A(A), .Y(Y));

endmodule

module MOD_74x04_4_SPLIT (A, Y);

parameter A_SIGNED = 0;
parameter A_WIDTH = 0;
parameter Y_WIDTH = 0;

input [3:0] A;
output [3:0]Y;

NOT _TECHMAP_REPLACE_(.A(A), .Y(Y));

endmodule
module MOD_74x04_5 (A, Y);

parameter A_SIGNED = 0;
parameter A_WIDTH = 0;
parameter Y_WIDTH = 0;

input [4:0] A;
output [4:0]Y;

NOT _TECHMAP_REPLACE_(.A(A), .Y(Y));

endmodule

module MOD_74x04_5_SPLIT (A, Y);

parameter A_SIGNED = 0;
parameter A_WIDTH = 0;
parameter Y_WIDTH = 0;

input [4:0] A;
output [4:0]Y;

NOT _TECHMAP_REPLACE_(.A(A), .Y(Y));

endmodule
module MOD_74x04_6 (A, Y);

parameter A_SIGNED = 0;
parameter A_WIDTH = 0;
parameter Y_WIDTH = 0;

input [5:0] A;
output [5:0]Y;

NOT _TECHMAP_REPLACE_(.A(A), .Y(Y));

endmodule

module MOD_74x04_6_SPLIT (A, Y);

parameter A_SIGNED = 0;
parameter A_WIDTH = 0;
parameter Y_WIDTH = 0;

input [5:0] A;
output [5:0]Y;

NOT _TECHMAP_REPLACE_(.A(A), .Y(Y));

endmodule

module MOD_74x08_1 (A, B, Y);

parameter A_SIGNED = 0;
parameter B_SIGNED = 0;
parameter A_WIDTH = 0;
parameter B_WIDTH = 0;
parameter Y_WIDTH = 0;

input A;
input B;
output Y;

AND _TECHMAP_REPLACE_(.A(A), .B(B), .Y(Y));

endmodule
module MOD_74x08_2 (A, B, Y);

parameter A_SIGNED = 0;
parameter B_SIGNED = 0;
parameter A_WIDTH = 0;
parameter B_WIDTH = 0;
parameter Y_WIDTH = 0;

input [1:0] A;
input [1:0] B;
output [1:0] Y;

AND _TECHMAP_REPLACE_(.A(A), .B(B), .Y(Y));

endmodule

module MOD_74x08_2_SPLIT (A, B, Y);

parameter A_SIGNED = 0;
parameter B_SIGNED = 0;
parameter A_WIDTH = 0;
parameter B_WIDTH = 0;
parameter Y_WIDTH = 0;

input [1:0] A;
input [1:0] B;
output [1:0] Y;


AND _TECHMAP_REPLACE_(.A(A), .B(B), .Y(Y));

endmodule
module MOD_74x08_3 (A, B, Y);

parameter A_SIGNED = 0;
parameter B_SIGNED = 0;
parameter A_WIDTH = 0;
parameter B_WIDTH = 0;
parameter Y_WIDTH = 0;

input [2:0] A;
input [2:0] B;
output [2:0] Y;

AND _TECHMAP_REPLACE_(.A(A), .B(B), .Y(Y));

endmodule

module MOD_74x08_3_SPLIT (A, B, Y);

parameter A_SIGNED = 0;
parameter B_SIGNED = 0;
parameter A_WIDTH = 0;
parameter B_WIDTH = 0;
parameter Y_WIDTH = 0;

input [2:0] A;
input [2:0] B;
output [2:0] Y;


AND _TECHMAP_REPLACE_(.A(A), .B(B), .Y(Y));

endmodule
module MOD_74x08_4 (A, B, Y);

parameter A_SIGNED = 0;
parameter B_SIGNED = 0;
parameter A_WIDTH = 0;
parameter B_WIDTH = 0;
parameter Y_WIDTH = 0;

input [3:0] A;
input [3:0] B;
output [3:0] Y;

AND _TECHMAP_REPLACE_(.A(A), .B(B), .Y(Y));

endmodule

module MOD_74x08_4_SPLIT (A, B, Y);

parameter A_SIGNED = 0;
parameter B_SIGNED = 0;
parameter A_WIDTH = 0;
parameter B_WIDTH = 0;
parameter Y_WIDTH = 0;

input [3:0] A;
input [3:0] B;
output [3:0] Y;


AND _TECHMAP_REPLACE_(.A(A), .B(B), .Y(Y));

endmodule
module MOD_74x32_1 (A, B, Y);

parameter A_SIGNED = 0;
parameter B_SIGNED = 0;
parameter A_WIDTH = 0;
parameter B_WIDTH = 0;
parameter Y_WIDTH = 0;

input A;
input B;
output Y;

OR _TECHMAP_REPLACE_(.A(A), .B(B), .Y(Y));

endmodule
module MOD_74x32_2 (A, B, Y);

parameter A_SIGNED = 0;
parameter B_SIGNED = 0;
parameter A_WIDTH = 0;
parameter B_WIDTH = 0;
parameter Y_WIDTH = 0;

input [1:0] A;
input [1:0] B;
output [1:0] Y;

OR _TECHMAP_REPLACE_(.A(A), .B(B), .Y(Y));

endmodule

module MOD_74x32_2_SPLIT (A, B, Y);

parameter A_SIGNED = 0;
parameter B_SIGNED = 0;
parameter A_WIDTH = 0;
parameter B_WIDTH = 0;
parameter Y_WIDTH = 0;

input [1:0] A;
input [1:0] B;
output [1:0] Y;


OR _TECHMAP_REPLACE_(.A(A), .B(B), .Y(Y));

endmodule
module MOD_74x32_3 (A, B, Y);

parameter A_SIGNED = 0;
parameter B_SIGNED = 0;
parameter A_WIDTH = 0;
parameter B_WIDTH = 0;
parameter Y_WIDTH = 0;

input [2:0] A;
input [2:0] B;
output [2:0] Y;

OR _TECHMAP_REPLACE_(.A(A), .B(B), .Y(Y));

endmodule

module MOD_74x32_3_SPLIT (A, B, Y);

parameter A_SIGNED = 0;
parameter B_SIGNED = 0;
parameter A_WIDTH = 0;
parameter B_WIDTH = 0;
parameter Y_WIDTH = 0;

input [2:0] A;
input [2:0] B;
output [2:0] Y;


OR _TECHMAP_REPLACE_(.A(A), .B(B), .Y(Y));

endmodule
module MOD_74x32_4 (A, B, Y);

parameter A_SIGNED = 0;
parameter B_SIGNED = 0;
parameter A_WIDTH = 0;
parameter B_WIDTH = 0;
parameter Y_WIDTH = 0;

input [3:0] A;
input [3:0] B;
output [3:0] Y;

OR _TECHMAP_REPLACE_(.A(A), .B(B), .Y(Y));

endmodule

module MOD_74x32_4_SPLIT (A, B, Y);

parameter A_SIGNED = 0;
parameter B_SIGNED = 0;
parameter A_WIDTH = 0;
parameter B_WIDTH = 0;
parameter Y_WIDTH = 0;

input [3:0] A;
input [3:0] B;
output [3:0] Y;


OR _TECHMAP_REPLACE_(.A(A), .B(B), .Y(Y));

endmodule
module MOD_74x86_1 (A, B, Y);

parameter A_SIGNED = 0;
parameter B_SIGNED = 0;
parameter A_WIDTH = 0;
parameter B_WIDTH = 0;
parameter Y_WIDTH = 0;

input A;
input B;
output Y;

XOR _TECHMAP_REPLACE_(.A(A), .B(B), .Y(Y));

endmodule
module MOD_74x86_2 (A, B, Y);

parameter A_SIGNED = 0;
parameter B_SIGNED = 0;
parameter A_WIDTH = 0;
parameter B_WIDTH = 0;
parameter Y_WIDTH = 0;

input [1:0] A;
input [1:0] B;
output [1:0] Y;

XOR _TECHMAP_REPLACE_(.A(A), .B(B), .Y(Y));

endmodule

module MOD_74x86_2_SPLIT (A, B, Y);

parameter A_SIGNED = 0;
parameter B_SIGNED = 0;
parameter A_WIDTH = 0;
parameter B_WIDTH = 0;
parameter Y_WIDTH = 0;

input [1:0] A;
input [1:0] B;
output [1:0] Y;


XOR _TECHMAP_REPLACE_(.A(A), .B(B), .Y(Y));

endmodule
module MOD_74x86_3 (A, B, Y);

parameter A_SIGNED = 0;
parameter B_SIGNED = 0;
parameter A_WIDTH = 0;
parameter B_WIDTH = 0;
parameter Y_WIDTH = 0;

input [2:0] A;
input [2:0] B;
output [2:0] Y;

XOR _TECHMAP_REPLACE_(.A(A), .B(B), .Y(Y));

endmodule

module MOD_74x86_3_SPLIT (A, B, Y);

parameter A_SIGNED = 0;
parameter B_SIGNED = 0;
parameter A_WIDTH = 0;
parameter B_WIDTH = 0;
parameter Y_WIDTH = 0;

input [2:0] A;
input [2:0] B;
output [2:0] Y;


XOR _TECHMAP_REPLACE_(.A(A), .B(B), .Y(Y));

endmodule
module MOD_74x86_4 (A, B, Y);

parameter A_SIGNED = 0;
parameter B_SIGNED = 0;
parameter A_WIDTH = 0;
parameter B_WIDTH = 0;
parameter Y_WIDTH = 0;

input [3:0] A;
input [3:0] B;
output [3:0] Y;

XOR _TECHMAP_REPLACE_(.A(A), .B(B), .Y(Y));

endmodule

module MOD_74x86_4_SPLIT (A, B, Y);

parameter A_SIGNED = 0;
parameter B_SIGNED = 0;
parameter A_WIDTH = 0;
parameter B_WIDTH = 0;
parameter Y_WIDTH = 0;

input [3:0] A;
input [3:0] B;
output [3:0] Y;


XOR _TECHMAP_REPLACE_(.A(A), .B(B), .Y(Y));

endmodule
