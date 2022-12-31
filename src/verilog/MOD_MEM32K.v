(* keep *)
module MOD_MEM32K(
	input [0:14] A,
    inout [0:7] IO,
	input CS,
	input OE,
	input WE
);

reg [0:7] buffer [0:32767];
reg drive_output;

initial begin
    drive_output = 0;
end

assign IO = drive_output ? buffer[A] : 8'bZ;

always @* begin
	if (!CS && !OE && WE) begin
		#12 drive_output <= 1;
	end else begin
		drive_output <= 0;
	end

	if (!CS && !WE) begin
		#12 buffer[A] <= IO;
	end
end

endmodule

