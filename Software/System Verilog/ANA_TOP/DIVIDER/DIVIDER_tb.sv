//`timescale 1ns/1ps

module tb_DIVIDER;

  // Testbench signals
  reg clk_in; //This is the dco_clk
  reg [7:0] divide_by; //EMAS Divider register signal
  reg power_down; //EMAS Divider register signal
  wire clk_out; //goes to nsh_clk of the FLB

  // Instantiate the DIVIDER module
  DIVIDER DUT (
	.clk_in(clk_in),
	.divide_by(divide_by),
	.power_down(power_down),
	.clk_out(clk_out)
  );

  // Clock generation
  initial begin
	clk_in = 0;
	forever #5 clk_in = ~clk_in; // 10ns clock period
  end

  initial begin
	// Initialize signals
	power_down = 1;
	divide_by = 8'd2; // Initial divide factor
	#10;

	// Release power down and change divide_by value
	power_down = 0;
	#1000;
	
	// Change divide_by to 4 when power_down is 1
	power_down = 1;
	#10;
	divide_by = 8'd4;
	#10;
	power_down = 0;
	#1000;
	
	// Change divide_by to 8 when power_down is 1
	power_down = 1;
	#10;
	divide_by = 8'd8;
	#10;
	power_down = 0;
	#1000;

	// Change divide_by to 16 when power_down is 1
	power_down = 1;
	#10;
	divide_by = 8'd16;
	#10;
	power_down = 0;
	#1000;

	// Change divide_by to 32 when power_down is 1
	power_down = 1;
	#10;
	divide_by = 8'd32;
	#10;
	power_down = 0;
	#1000;

	// Change divide_by to 64 when power_down is 1
	power_down = 1;
	#10;
	divide_by = 8'd64;
	#10;
	power_down = 0;
	#1500;

	$finish;
  end

  // Monitor signals
  initial begin
	$monitor("Time = %0t : clk_in = %b, power_down = %b, divide_by = %d, clk_out = %b", 
			 $time, clk_in, power_down, divide_by, clk_out);
  end

endmodule


