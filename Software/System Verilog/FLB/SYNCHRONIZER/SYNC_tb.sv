module SYNC_tb;
// Signals for module ports
logic nsh_clk;
logic ref_clk;
logic [15:0] dlf_out;
logic [7:0] band;
logic [1:0] mtrx_clk_lag;
logic [1:0] smpl_clk_lag;
logic [7:0] s_os;
logic [7:0] s_mtrx;
logic [7:0] s_band;
logic dec_clk;

// Instantiate the module under test
SYNC dut (
  .nsh_clk(nsh_clk),
  .ref_clk(ref_clk),
  .dlf_out(dlf_out),
  .band(band),
  .mtrx_clk_lag(mtrx_clk_lag),
  .smpl_clk_lag(smpl_clk_lag),
  .s_os(s_os),
  .s_mtrx(s_mtrx),
  .s_band(s_band),
  .dec_clk(dec_clk)
);

initial begin
	nsh_clk = 1'b0;
	ref_clk = 1'b0;
	dlf_out = 16'hABCD;
	band = 8'hFF;
  //Change lines 34-35 to control the lag of the pulses
	mtrx_clk_lag = 2'b10;
	smpl_clk_lag = 2'b01;
	
	#10;
	nsh_clk = 1'b1;
	
	#10;
	nsh_clk = 1'b0;
	
	#10;
	nsh_clk = 1'b1;
	
	#10;
	nsh_clk = 1'b0;
	
	#10;
	nsh_clk = 1'b1;
	
	#10;
	nsh_clk = 1'b0;
	
	#10;
	nsh_clk = 1'b1;
	
	#10;
	nsh_clk = 1'b0;
	
	#10;
	nsh_clk = 1'b1;
	
	#10;
	nsh_clk = 1'b0;
	
	#10;
	nsh_clk = 1'b1;
	
	#10;
	nsh_clk = 1'b0;
	
	#10;
	nsh_clk = 1'b1;
	
	#10;
	nsh_clk = 1'b0;
	#5
	ref_clk = 1'b1;
	#5;
	nsh_clk = 1'b1;

	#10;
	nsh_clk = 1'b0;

	#10;
	nsh_clk = 1'b1;
	
	#10;
	nsh_clk = 1'b0;

	#10;
	nsh_clk = 1'b1;
	
	#10;
	nsh_clk = 1'b0;

	#10;
	nsh_clk = 1'b1;
	
	#10;
	nsh_clk = 1'b0;

	#10;
	nsh_clk = 1'b1;
	
	#10;
	nsh_clk = 1'b0;
	
	#10;
	nsh_clk = 1'b1;
	
	#10;
	nsh_clk = 1'b0;
	
	#10;
	nsh_clk = 1'b1;
	
	#10;
	nsh_clk = 1'b0;
	
	#10;
	nsh_clk = 1'b1;
	
	#10;
	nsh_clk = 1'b0;

	ref_clk = 1'b0;
	
	#10;
	nsh_clk = 1'b1;
	
	#10;
	nsh_clk = 1'b0;

	#10;
	nsh_clk = 1'b1;
	
	#10;
	nsh_clk = 1'b0;

	#10;
	nsh_clk = 1'b1;
	
	#10;
	nsh_clk = 1'b0;

	#10;
	nsh_clk = 1'b1;
	
	#10;
	nsh_clk = 1'b0;
	
	#10;
	nsh_clk = 1'b1;
	
	#10;
	nsh_clk = 1'b0;
	
	#10;
	nsh_clk = 1'b1;
	
	#10;
	nsh_clk = 1'b0;
	
	#10;
	nsh_clk = 1'b1;
	
	#10;
	nsh_clk = 1'b0;

	#10;
	nsh_clk = 1'b1;
	#5
	ref_clk = 1'b0;
	#5;
	nsh_clk = 1'b0;
	
	#10;
	nsh_clk = 1'b1;
	
	#10;
	nsh_clk = 1'b0;
	
	#10;
	nsh_clk = 1'b1;
	
	#10;
	nsh_clk = 1'b0;	#10;
	nsh_clk = 1'b1;
	
	#10;
	nsh_clk = 1'b0;

	#10;
	nsh_clk = 1'b1;
	
	#10;
	nsh_clk = 1'b0;
	
	#10;
	nsh_clk = 1'b1;
	
	#10;
	nsh_clk = 1'b0;
	
	#10;
	nsh_clk = 1'b1;
	
	#10;
	nsh_clk = 1'b0;
	$finish;	
end

  	always @(posedge nsh_clk) begin
	$display("Time %0t: ref_clk = %b, dlf_out = %h, band = %h, mtrx_clk_lag = %b, smpl_clk_lag = %b",
			 $time, ref_clk, dlf_out, band, mtrx_clk_lag, smpl_clk_lag);
	$display("        Outputs: s_os = %h, s_mtrx = %h, s_band = %h, dec_clk = %b",
			 s_os, s_mtrx, s_band, dec_clk);
	end
endmodule

