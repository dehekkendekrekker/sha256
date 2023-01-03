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

reg drive_output;

assign IO = drive_output ? buffer[A] : 8'bZ;

initial begin
    drive_output = 0;
end

always @* begin
	// Read
	if (!CS && !OE && WE) begin
		#12 drive_output = 1;
	end

	// Write
	if (!CS && !WE) begin
		drive_output = 0;
		#12 buffer[A] = IO;
	end

	if (!CS && OE && WE) begin
		drive_output = 0;
	end

	if (CS) 
		drive_output = 0;



end
endmodule
`endif
