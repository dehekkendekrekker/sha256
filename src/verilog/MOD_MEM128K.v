module MOD_MEM128K(
	input [0:14] A,
    inout [0:31] IO,
	input CS,
	input OE,
	input WE
);


MOD_MEM32K bank_1(A,IO[0:7],CS,OE,WE);
MOD_MEM32K bank_2(A,IO[8:15],CS,OE,WE);
MOD_MEM32K bank_3(A,IO[16:23],CS,OE,WE);
MOD_MEM32K bank_4(A,IO[24:31],CS,OE,WE);

endmodule
