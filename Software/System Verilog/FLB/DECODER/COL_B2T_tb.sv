///////////////////////// Testbench for COL_B2T///////////////////

module tb_COL_B2T;

// Testbench signals
reg  [3:0] binary;
wire [15:0] rise_o;
wire [15:0] fall_o;

// Instantiate the bin_to_thermo module
COL_B2T uut (
	.bin(binary),
	.rise_o(rise_o),
	.fall_o(fall_o)
);

initial begin
// Display signal values on each change/  $monitor("Time = %0d, binary = %b, rise_o = %b, fall_o = %b", $time, binary, rise_o,fall_o );

	// Test all binary input values
	binary = 4'b0000; #10;
	binary = 4'b0001; #10;
	binary = 4'b0010; #10;
	binary = 4'b0011; #10;
	binary = 4'b0100; #10;
	binary = 4'b0101; #10;
	binary = 4'b0110; #10;
	binary = 4'b0111; #10;
	binary = 4'b1000; #10;
	binary = 4'b1001; #10;
	binary = 4'b1010; #10;
	binary = 4'b1011; #10;
	binary = 4'b1100; #10;
	binary = 4'b1101; #10;
	binary = 4'b1110; #10;
	binary = 4'b1111; #10;

	// Finish the simulation
	$finish;
end

endmodule
