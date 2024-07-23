module COL_B2T (
	input  [3:0] bin,   // 4-bit binary input
	output [15:0] rise_o, // 16-bit thermometer code output
	output [15:0] fall_o // 16-bit thermometer code output
);

wire [15:0] th;
// Instantiate bin_to_thermo to generate rise_o
B2T B2T_inst (
	.binary(bin),
	.thermo(th)
);

// Generate fall_o as the complement of rise_o

assign rise_o =   {th[14:0],1'b1}; 
assign fall_o =   {1'b1 ,~th[14:0]};

endmodule

