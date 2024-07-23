//`timescale 1ps/1fs

module top_level (
	// Top-level inputs
	input logic nsh_clk, 
	input logic ref_clk,
	input logic [15:0] dlf_out,
	input logic [7:0] band,
	input logic sdm_on,
	input logic sdm_order,
	input logic sdm_thrm_en,
	input logic sdm_man_on,
	input logic [2:0] sdm_man_val,
	input logic [1:0] mtrx_clk_lag,
	input logic [1:0] smpl_clk_lag,
	input logic rst_n,
	input logic [7:0] divide_by,
	
	// Top-level outputs
	output logic [2:0] os_thrm,
	output logic [63:0] mtrx_thrm,
	output logic [255:0] band_thrm,
	output logic [7:0] band_bin,
	output logic clk_out_divider,
	output logic dco_clk,
	output logic [63:0] sampled_tdc
);

	// Instantiating FLB
	FLB flb_inst (
		.nsh_clk(nsh_clk),
		.ref_clk(ref_clk),
		.dlf_out(dlf_out),
		.band(band),
		.sdm_on(sdm_on),
		.sdm_order(sdm_order),
		.sdm_thrm_en(sdm_thrm_en),
		.sdm_man_on(sdm_man_on),
		.sdm_man_val(sdm_man_val),
		.mtrx_clk_lag(mtrx_clk_lag),
		.smpl_clk_lag(smpl_clk_lag),
		.rst_n(rst_n),
		.os_thrm(os_thrm),
		.mtrx_thrm(mtrx_thrm),
		.band_thrm(band_thrm),
		.band_bin(band_bin)
	);

	// Instantiating DCO
	dco dco_inst (
		.dlf_out(dlf_out),
		.dco_clk(dco_clk)
	);
	
	// Instantiating DIVIDER
	DIVIDER divider_inst (
		.clk_in(dco_clk),
		.divide_by(divide_by),
		.clk_out(clk_out_divider)
	);

	// Instantiating TDC
	tdc tdc_inst (
		.ref_clk(ref_clk),
		.dco(dco_clk),
		.sampled_tdc(sampled_tdc)
	);

endmodule

