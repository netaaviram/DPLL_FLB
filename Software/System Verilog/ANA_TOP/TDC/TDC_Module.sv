//`timescale 1ps/1fs

module tdc (
	input wire ref_clk,
	input wire dco,
	output logic [63:0] sampled_tdc
);
	parameter real dt = 4;
	parameter NTDC = 64;

	integer i;
	logic [NTDC-1:0] clk_chain;

	always @(*) begin
		for (i = 0; i < NTDC; i++) begin
			clk_chain[i] <= #(i*dt*1ps) ref_clk;            
		end
	end // always @ (*)
	 
	genvar n;
	generate
		for (n = 0; n < NTDC; n++) begin : FF_GEN
			always @(posedge clk_chain[n]) begin
				sampled_tdc[n] <= dco;
			end
		end
	endgenerate
endmodule

