module tb_ROW_B2T;

// Testbench signals
reg [3:0] data_i;
reg oc;
wire [15:0] data_o;

// Instantiate the DUT
ROW_B2T DUT (
  .data_i(data_i),
  .oc(oc),
  .data_o(data_o)
);
// Stimulus generation
initial begin
  // Initialize inputs
  data_i = 4'b0000;
  oc = 1'd0; 
  // Wait for a few clock cycles
  #20;
  // Apply test vectors
  data_i = 4'b0001; // Test case 1
  oc = 1'd0; // Expect thermometer code for binary 1
  #10;
  data_i = 4'b0010; // Test case 2
  oc = 1'd0; // Expect thermometer code for binary 2
  #10;
  data_i = 4'b0100; // Test case 3
  oc = 1'd0; // Expect thermometer code for binary 4
  #10;
  data_i = 4'b1000; // Test case 4
  oc = 1'd0; // Expect thermometer code for binary 8
  #10;
  data_i = 4'b0001; // Test case 5
  oc = 1'd1; // Test case with oc = 1, expect shifted thermometer code
  #10;
  data_i = 4'b1111; // Test case 6
  oc = 1'd1; // Test case with oc = 1
  #10;
  data_i = 4'b1001; // Test case 7
  oc = 1'd1; // Test case with oc = 1, expect shifted thermometer code
  #10;
  data_i = 4'b1000; // Test case 8
  oc = 1'd1; // Test case with oc = 1
  #10;
  // End of simulation
  $finish;
end
// Monitor output at each simulation step
initial begin
  $monitor("Time = %0t : data_i = %b, oc = %b, data_o = %b",
		   $time, data_i, oc, data_o);
end
endmodule
