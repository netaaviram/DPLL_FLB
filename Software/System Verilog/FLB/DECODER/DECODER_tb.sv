/////////////////// Testbench for DECODER_TOP_LEVEL///////////////////
module tb_DECODER;

// Testbench signals
reg clk;
reg [7:0] bin;
logic csr_flb_rst_n;
logic  [7:0] s_band;
logic  [7:0] band_bin;
logic [15:0] band_thrm_hi;
logic [15:0] band_thrm_lo;
wire [15:0] row_p;
wire [15:0] row_n;
wire [15:0] col_on;
wire [15:0] col_off;
integer dco_cap_num;
integer i;

// Instantiate the DUT (Device Under Test)
DECODER DUT (
  .clk(clk),
  .s_mtrx(bin),
  .s_band(s_band),
  .csr_flb_rst_n(csr_flb_rst_n),
  .row_p(row_p),
  .row_n(row_n),
  .col_on(col_on),
  .col_off(col_off),
  .band_thrm_hi(band_thrm_hi),
  .band_thrm_lo(band_thrm_lo),
  .band_bin(band_bin)
);

// Instantiate ENCODER
ENCODER ENCODER_inst (
	.row_p(row_p),
	.row_n(row_n),
	.col_on(col_on),
	.col_off(col_off),
  	.dco_cap_num(dco_cap_num)
);

initial begin
	clk = 1'b0;
	bin = 8'b0;
	csr_flb_rst_n = 0;
	s_band = 0; 
	
	#10;
	clk = 1'b1;

	#10;
	clk = 1'b0;
	
	#10;
	clk = 1'b1;

	#10;
	clk = 1'b0;
	csr_flb_rst_n = 1;
	s_band = 8'b11010101; 
	#10;
	clk = 1'b1;
	
	#10;
	clk = 1'b0;
	#10;
	clk = 1'b1;
	
	#10;
	clk = 1'b0;
			
	for (i=0; i<256; i=i+1) begin
		bin = i;
		#10;
		clk = 1'b1;
		#10;
		clk = 1'b0;
		$display("Time = %0t : actual bin = %d row_p = %b, row_n = %b, col_on = %b, col_off = %b, dco_output = %d, band_bin = %b, band_thrm_hi = %b, band_thrm_lo = %b ",
				$time, bin, row_p, row_n, col_on, col_off, dco_cap_num, band_bin, band_thrm_hi, band_thrm_lo);
		if (bin != dco_cap_num) begin
			$display("mismatch identified! Decoder_bin = %d != encoder_dco_cap_num = %d", bin, dco_cap_num);
		end
	end
	$finish;		
end
endmodule
