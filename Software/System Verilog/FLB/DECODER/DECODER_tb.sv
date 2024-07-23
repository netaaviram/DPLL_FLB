/////////////////// Testbench for DECODER_TOP_LEVEL///////////////////
module tb_DECODER;

// Testbench signals
reg clk;
reg [7:0] bin;
reg [63:0] mtrx_thrm;
wire [15:0] row_p;
wire [15:0] row_n;
wire [15:0] col_on;
wire [15:0] col_off;
integer i ; 
integer penc_col_on ;
integer penc_row_p ; 
integer penc_row_n ; 
integer DCO;
integer valid ;


// Instantiate the DUT (Device Under Test)
DECODER DUT (
  .clk(clk),
  .s_mtrx(bin),
  .mtrx_thrm(mtrx_thrm)
  .row_p(row_p),
  .row_n(row_n),
  .col_on(col_on),
  .col_off(col_off)
);

assign col_off = mtrx_thrm[15:0];
assign col_on = mtrx_thrm[31:16];
assign row_n = mtrx_thrm[47:32];
assign row_p = mtrx_thrm[63:48];


initial begin
	clk = 1'b0;
	bin = 8'b0;
	
	#10;
	clk = 1'b1;
	
	#10;
	clk = 1'b0;
	
	#10;
	clk = 1'b1;

	#10;
	clk = 1'b0;
	bin = 8'b00000001; // Test case 1

	#10;
	clk = 1'b1;
	
	#10;
	clk = 1'b0;
	bin = 8'b00000010; // Test case 1

	#10;
	clk = 1'b1;
	
	#10;
	clk = 1'b0;
	bin = 8'b00000011; // Test case 1

	#10;
	clk = 1'b1;
	
	#10;
	clk = 1'b0;
	bin = 8'b00010011; // Test case 1

	#10;
	clk = 1'b1;
	
	#10;
	clk = 1'b0;
	bin = 8'd120; // Test case 
	#10;
	clk = 1'b1;
	
	#10;
	clk = 1'b0;
	bin = 8'd250; // Test case 	
	#10;
	clk = 1'b1;
	
	#10;
	clk = 1'b0;
	bin = 8'd123; // Test case 	
	#10;
	clk = 1'b1;
	
	#10;
	clk = 1'b0;
	bin = 8'd15; // Test case 	
	#10;
	clk = 1'b1;
	
	#10;
	clk = 1'b0;
	bin = 8'd16; // Test case 	
	#10;
	clk = 1'b1;
	
	#10;
	clk = 1'b0;
	bin = 8'd17; // Test case 	
	#10;
	clk = 1'b1;
	
	#10;
	clk = 1'b0;
	bin = 8'd31; // Test case 	
	#10;
	clk = 1'b1;
	
	#10;
	clk = 1'b0;
	bin = 8'd32; // Test case 	
	#10;
	clk = 1'b1;
	
	#10;
	clk = 1'b0;
	bin = 8'd33; // Test case 	
	#10;
	clk = 1'b1;
	
	#10;
	clk = 1'b0;
	bin = 8'd33; // Test case 	
	#10;
	clk = 1'b1;
	
	#10;
	clk = 1'b0;
	bin = 8'd33; // Test case 	
	#10;
	clk = 1'b1;
	$finish;

		
end

// Clock generation
initial begin
  clk = 0;
  forever #5 clk = ~clk; // 10ns clock period
end

// Stimulus generation
initial begin
  // Initialize inputs
  bin = 8'b00000000;

  // Apply test vectors and wait
  #10;
  bin = 8'b00000001; // Test case 1
  #10;

  bin = 8'b00010010; // Test case 2
  #10;

  bin = 8'b00101101; // Test case 3
  #10;

  bin = 8'b11110000; // Test case 4
  #10;

  bin = 8'b10101010; // Test case 5
  #10;

  bin = 8'b00001111; // Test case 6
  #10;

  // End of simulation
  #10;
  $finish;
end

//This part of the code does the opposite functionality of the decoder.
//This is infact an encoder, that plays the role of the DCO.
//It gets a digital input mtrx_thrm[63:0] and encpodes it to a number.

  
// Monitor outputs and display bin value and corresponding output after flip-flops
always @(posedge clk) begin 
	penc_row_p = 0 ; 
	penc_row_n = 0 ; 
	penc_col_on = 0 ;
	for (i = 15; i >= 0; i = i - 1) begin
		if (col_on[i]) begin
			penc_col_on = i;
			valid = 1 ;
		  	break; // Break the loop once the highest priority '1' is found
		end
	end
	
	DCO = (valid) ? ((penc_col_on) * 16) : 0;
	//$display( "first DCO = %d " , DCO) ; 
	
	if (penc_col_on % 2 == 0 ) begin
		for (i = 15; i >= 0; i = i - 1) begin
			if (row_p[i]) begin
				penc_row_p = i + 1;				 
				break; // Break the loop once the highest priority '1' is found				  
			end		
	  	end	
		//$display( "penc_row_p = %d " , penc_row_p) ; 
		DCO = DCO + penc_row_p ;
	end

	else begin
		for (i = 15; i >= 0; i = i - 1) begin
			if (!row_n[i]) begin
				penc_row_n = 15 - i;				 
				break; // Break the loop once the highest priority '1' is found				  
			end
		end	
		//$display( "penc_row_n = %d " , penc_row_n) ; 
		DCO = DCO + penc_row_n ;
	end 
	
	$display("Time = %0t : bin = %d,actual bin = %d row_p = %b, row_n = %b, col_on = %b, col_off = %b",
			$time, bin, DCO, row_p, row_n, col_on, col_off);
end
endmodule
