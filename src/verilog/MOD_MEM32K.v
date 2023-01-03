`ifndef MOD_MEM32K
`define MOD_MEM32K

// When writing (WE == 0), OE must be 1
(* keep *)
module MOD_MEM32K(
	input [14:0] A,
    inout [7:0] IO,
	input CS,
	input OE,
	input WE
);

reg [0:7] buffer [0:32767];
reg [0:7] tmp;


reg [0:7] peekaboo;

assign peekaboo = buffer[A];

reg drive_output;


assign IO = drive_output ? tmp : 8'bZ;

initial begin
    drive_output = 0;
end

// Behaviour when OE changes
always @(OE) begin
	// Read cycle 1
	if (WE) begin
		if (!OE && !CS) begin
			#6 tmp = buffer[A]; // TOE
			drive_output = 1;
		end
		if (OE)
			#6 drive_output = 0;  // TOHZ
	end
end




// Behaviour when CS changes
always @(CS) begin
	// Read cycle 1
	if (WE) begin
		if (!OE && !CS) begin
			#4 tmp = buffer[A]; // tclz
			drive_output = 1;
		end

		// If CS goes high, the output  will be put in HI 
		if (CS) #6 drive_output = 0; // tczh
	end

	// Write cycles
	// Write cycle 1
	if (WE && CS) #6 drive_output = 0; // Disable chip weh CS goes h

	// Write cycle 2
	if (!WE && !CS) buffer[A] = IO; // taw
end

// Behaviour when address changes
always @(A) begin
	// Read cycle 2
	if (!OE && !CS && WE) begin
		#3 tmp = 8'bx; //toh
		#9 tmp = buffer[A];
		drive_output = 1;
	end else
		drive_output = 0;
end

// Behaviour when WE changes
always @(WE) begin
	// Write cycel
	if (OE) begin
		if (!CS && !WE) begin
			#6 drive_output <= 0; // twhz
			#8 buffer[A] <= IO;
		end

		if (!CS && WE) begin
			#4 drive_output <= 1; // tow
		end
	end
end








endmodule
`endif
