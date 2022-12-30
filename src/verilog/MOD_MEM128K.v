`include "./src/verilog/MOD_MEM32K.v"

module MOD_MEM128K(
	input [14:0] A,
    output [31:0] D_READ,
	input [31:0] D_WRITE,
	input CS,
	input OE,
	input WE
);


wire [31:0] IO;

assign IO = (~WE) ? D_WRITE : 32'bZ;
assign D_READ = IO;




MOD_MEM32K bank_1(A,IO[31:24],CS,OE,WE);
MOD_MEM32K bank_2(A,IO[23:16],CS,OE,WE);
MOD_MEM32K bank_3(A,IO[15:8],CS,OE,WE);
MOD_MEM32K bank_4(A,IO[7:0],CS,OE,WE);

endmodule
