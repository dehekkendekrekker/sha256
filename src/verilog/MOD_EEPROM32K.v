`include "./src/verilog/MOD_EEPROM8K.v"

(* keep *)
module MOD_EEPROM32K(
	input [0:12] A,
    output reg [0:31] IO,
	input CE,
	input OE,
	input WE
);

MOD_EEPROM8K_1 bank_1(A, IO[0:7], CE, OE, WE);
MOD_EEPROM8K_2 bank_2(A, IO[8:15], CE, OE, WE);
MOD_EEPROM8K_3 bank_3(A, IO[16:23], CE, OE, WE);
MOD_EEPROM8K_4 bank_4(A, IO[24:31], CE, OE, WE);

endmodule

