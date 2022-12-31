(* keep *)
(* blackbox *)
module MOD_EEPROM8K_1(
	input [0:12] A,
    output reg [0:7] IO,
	input CE,
	input OE,
	input WE
);

reg [0:7] buffer [0:8191];

initial begin
	// H constants
	buffer[0] = 8'h6a;
	buffer[1] = 8'hbb;
	buffer[2] = 8'h3c;
	buffer[3] = 8'ha5;
	buffer[4] = 8'h51;
	buffer[5] = 8'h9b;
	buffer[6] = 8'h1f;
	buffer[7] = 8'h5b;

	// K constants
	buffer[8] = 8'h42;
	buffer[9] = 8'h71;
	buffer[10] = 8'hb5;
	buffer[11] = 8'he9;
	buffer[12] = 8'h39;
	buffer[13] = 8'h59;
	buffer[14] = 8'h92;
	buffer[15] = 8'hab;
	buffer[16] = 8'hd8;
	buffer[17] = 8'h12;
	buffer[18] = 8'h24;
	buffer[19] = 8'h55;
	buffer[20] = 8'h72;
	buffer[21] = 8'h80;
	buffer[22] = 8'h9b;
	buffer[23] = 8'hc1;
	buffer[24] = 8'he4;
	buffer[25] = 8'hef;
	buffer[26] = 8'h0f;
	buffer[27] = 8'h24;
	buffer[28] = 8'h2d;
	buffer[29] = 8'h4a;
	buffer[30] = 8'h5c;
	buffer[31] = 8'h76;
	buffer[32] = 8'h98;
	buffer[33] = 8'ha8;
	buffer[34] = 8'hb0;
	buffer[35] = 8'hbf;
	buffer[36] = 8'hc6;
	buffer[37] = 8'hd5;
	buffer[38] = 8'h06;
	buffer[39] = 8'h14;
	buffer[40] = 8'h27;
	buffer[41] = 8'h2e;
	buffer[42] = 8'h4d;
	buffer[43] = 8'h53;
	buffer[44] = 8'h65;
	buffer[45] = 8'h76;
	buffer[46] = 8'h81;
	buffer[47] = 8'h92;
	buffer[48] = 8'ha2;
	buffer[49] = 8'ha8;
	buffer[50] = 8'hc2;
	buffer[51] = 8'hc7;
	buffer[52] = 8'hd1;
	buffer[53] = 8'hd6;
	buffer[54] = 8'hf4;
	buffer[55] = 8'h10;
	buffer[56] = 8'h19;
	buffer[57] = 8'h1e;
	buffer[58] = 8'h27;
	buffer[59] = 8'h34;
	buffer[60] = 8'h39;
	buffer[61] = 8'h4e;
	buffer[62] = 8'h5b;
	buffer[63] = 8'h68;
	buffer[64] = 8'h74;
	buffer[65] = 8'h78;
	buffer[66] = 8'h84;
	buffer[67] = 8'h8c;
	buffer[68] = 8'h90;
	buffer[69] = 8'ha4;
	buffer[70] = 8'hbe;
	buffer[71] = 8'hc6;
end

always @* begin
	if (!CE && !OE && WE) begin
		#150 IO <= buffer[A];
	end
end

endmodule

(* keep *)
(* blackbox *)
module MOD_EEPROM8K_2(
	input [0:12] A,
    output reg [0:7] IO,
	input CE,
	input OE,
	input WE
);

reg [0:7] buffer [0:8191];

initial begin
	// H constants
	buffer[0] = 8'h09;
	buffer[1] = 8'h67;
	buffer[2] = 8'h6e;
	buffer[3] = 8'h4f;
	buffer[4] = 8'h0e;
	buffer[5] = 8'h05;
	buffer[6] = 8'h83;
	buffer[7] = 8'he0;

	// K constants
	buffer[8] = 8'h8a;
	buffer[9] = 8'h37;
	buffer[10] = 8'hc0;
	buffer[11] = 8'hb5;
	buffer[12] = 8'h56;
	buffer[13] = 8'hf1;
	buffer[14] = 8'h3f;
	buffer[15] = 8'h1c;
	buffer[16] = 8'h07;
	buffer[17] = 8'h83;
	buffer[18] = 8'h31;
	buffer[19] = 8'h0c;
	buffer[20] = 8'hbe;
	buffer[21] = 8'hde;
	buffer[22] = 8'hdc;
	buffer[23] = 8'h9b;
	buffer[24] = 8'h9b;
	buffer[25] = 8'hbe;
	buffer[26] = 8'hc1;
	buffer[27] = 8'h0c;
	buffer[28] = 8'he9;
	buffer[29] = 8'h74;
	buffer[30] = 8'hb0;
	buffer[31] = 8'hf9;
	buffer[32] = 8'h3e;
	buffer[33] = 8'h31;
	buffer[34] = 8'h03;
	buffer[35] = 8'h59;
	buffer[36] = 8'he0;
	buffer[37] = 8'ha7;
	buffer[38] = 8'hca;
	buffer[39] = 8'h29;
	buffer[40] = 8'hb7;
	buffer[41] = 8'h1b;
	buffer[42] = 8'h2c;
	buffer[43] = 8'h38;
	buffer[44] = 8'h0a;
	buffer[45] = 8'h6a;
	buffer[46] = 8'hc2;
	buffer[47] = 8'h72;
	buffer[48] = 8'hbf;
	buffer[49] = 8'h1a;
	buffer[50] = 8'h4b;
	buffer[51] = 8'h6c;
	buffer[52] = 8'h92;
	buffer[53] = 8'h99;
	buffer[54] = 8'h0e;
	buffer[55] = 8'h6a;
	buffer[56] = 8'ha4;
	buffer[57] = 8'h37;
	buffer[58] = 8'h48;
	buffer[59] = 8'hb0;
	buffer[60] = 8'h1c;
	buffer[61] = 8'hd8;
	buffer[62] = 8'h9c;
	buffer[63] = 8'h2e;
	buffer[64] = 8'h8f;
	buffer[65] = 8'ha5;
	buffer[66] = 8'hc8;
	buffer[67] = 8'hc7;
	buffer[68] = 8'hbe;
	buffer[69] = 8'h50;
	buffer[70] = 8'hf9;
	buffer[71] = 8'h71;
end

always @* begin
	if (!CE && !OE && WE) begin
		#150 IO <= buffer[A];
	end
end

endmodule

(* keep *)
(* blackbox *)
module MOD_EEPROM8K_3(
	input [0:12] A,
    output reg [0:7] IO,
	input CE,
	input OE,
	input WE
);

reg [0:7] buffer [0:8191];

initial begin
	// H constants
	buffer[0] = 8'he6;
	buffer[1] = 8'hae;
	buffer[2] = 8'hf3;
	buffer[3] = 8'hf5;
	buffer[4] = 8'h52;
	buffer[5] = 8'h68;
	buffer[6] = 8'hd9;
	buffer[7] = 8'hcd;

	// K constants
	buffer[8] = 8'h2f;
	buffer[9] = 8'h44;
	buffer[10] = 8'hfb;
	buffer[11] = 8'hdb;
	buffer[12] = 8'hc2;
	buffer[13] = 8'h11;
	buffer[14] = 8'h82;
	buffer[15] = 8'h5e;
	buffer[16] = 8'haa;
	buffer[17] = 8'h5b;
	buffer[18] = 8'h85;
	buffer[19] = 8'h7d;
	buffer[20] = 8'h5d;
	buffer[21] = 8'hb1;
	buffer[22] = 8'h06;
	buffer[23] = 8'hf1;
	buffer[24] = 8'h69;
	buffer[25] = 8'h47;
	buffer[26] = 8'h9d;
	buffer[27] = 8'ha1;
	buffer[28] = 8'h2c;
	buffer[29] = 8'h84;
	buffer[30] = 8'ha9;
	buffer[31] = 8'h88;
	buffer[32] = 8'h51;
	buffer[33] = 8'hc6;
	buffer[34] = 8'h27;
	buffer[35] = 8'h7f;
	buffer[36] = 8'h0b;
	buffer[37] = 8'h91;
	buffer[38] = 8'h63;
	buffer[39] = 8'h29;
	buffer[40] = 8'h0a;
	buffer[41] = 8'h21;
	buffer[42] = 8'h6d;
	buffer[43] = 8'h0d;
	buffer[44] = 8'h73;
	buffer[45] = 8'h0a;
	buffer[46] = 8'hc9;
	buffer[47] = 8'h2c;
	buffer[48] = 8'he8;
	buffer[49] = 8'h66;
	buffer[50] = 8'h8b;
	buffer[51] = 8'h51;
	buffer[52] = 8'he8;
	buffer[53] = 8'h06;
	buffer[54] = 8'h35;
	buffer[55] = 8'ha0;
	buffer[56] = 8'hc1;
	buffer[57] = 8'h6c;
	buffer[58] = 8'h77;
	buffer[59] = 8'hbc;
	buffer[60] = 8'h0c;
	buffer[61] = 8'haa;
	buffer[62] = 8'hca;
	buffer[63] = 8'h6f;
	buffer[64] = 8'h82;
	buffer[65] = 8'h63;
	buffer[66] = 8'h78;
	buffer[67] = 8'h02;
	buffer[68] = 8'hff;
	buffer[69] = 8'h6c;
	buffer[70] = 8'ha3;
	buffer[71] = 8'h78;
end

always @* begin
	if (!CE && !OE && WE) begin
		#150 IO <= buffer[A];
	end
end

endmodule

(* keep *)
(* blackbox *)
module MOD_EEPROM8K_4(
	input [0:12] A,
    output reg [0:7] IO,
	input CE,
	input OE,
	input WE
);

reg [0:7] buffer [0:8191];

initial begin
	// H constants
	buffer[0] = 8'h67;
	buffer[1] = 8'h85;
	buffer[2] = 8'h72;
	buffer[3] = 8'h3a;
	buffer[4] = 8'h7f;
	buffer[5] = 8'h8c;
	buffer[6] = 8'hab;
	buffer[7] = 8'h19;

	// K constants
	buffer[8] = 8'h98;
	buffer[9] = 8'h91;
	buffer[10] = 8'hcf;
	buffer[11] = 8'ha5;
	buffer[12] = 8'h5b;
	buffer[13] = 8'hf1;
	buffer[14] = 8'ha4;
	buffer[15] = 8'hd5;
	buffer[16] = 8'h98;
	buffer[17] = 8'h01;
	buffer[18] = 8'hbe;
	buffer[19] = 8'hc3;
	buffer[20] = 8'h74;
	buffer[21] = 8'hfe;
	buffer[22] = 8'ha7;
	buffer[23] = 8'h74;
	buffer[24] = 8'hc1;
	buffer[25] = 8'h86;
	buffer[26] = 8'hc6;
	buffer[27] = 8'hcc;
	buffer[28] = 8'h6f;
	buffer[29] = 8'haa;
	buffer[30] = 8'hdc;
	buffer[31] = 8'hda;
	buffer[32] = 8'h52;
	buffer[33] = 8'h6d;
	buffer[34] = 8'hc8;
	buffer[35] = 8'hc7;
	buffer[36] = 8'hf3;
	buffer[37] = 8'h47;
	buffer[38] = 8'h51;
	buffer[39] = 8'h67;
	buffer[40] = 8'h85;
	buffer[41] = 8'h38;
	buffer[42] = 8'hfc;
	buffer[43] = 8'h13;
	buffer[44] = 8'h54;
	buffer[45] = 8'hbb;
	buffer[46] = 8'h2e;
	buffer[47] = 8'h85;
	buffer[48] = 8'ha1;
	buffer[49] = 8'h4b;
	buffer[50] = 8'h70;
	buffer[51] = 8'ha3;
	buffer[52] = 8'h19;
	buffer[53] = 8'h24;
	buffer[54] = 8'h85;
	buffer[55] = 8'h70;
	buffer[56] = 8'h16;
	buffer[57] = 8'h08;
	buffer[58] = 8'h4c;
	buffer[59] = 8'hb5;
	buffer[60] = 8'hb3;
	buffer[61] = 8'h4a;
	buffer[62] = 8'h4f;
	buffer[63] = 8'hf3;
	buffer[64] = 8'hee;
	buffer[65] = 8'h6f;
	buffer[66] = 8'h14;
	buffer[67] = 8'h08;
	buffer[68] = 8'hfa;
	buffer[69] = 8'heb;
	buffer[70] = 8'hf7;
	buffer[71] = 8'hf2;
end

always @* begin
	if (!CE && !OE && WE) begin
		#150 IO <= buffer[A];
	end
end

endmodule

