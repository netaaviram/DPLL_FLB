//`timescale 1ps/1fs

module ANA_TOP (
	// ANA_TOP inputs
	input logic ref_clk,
	input logic [15:0] dlf_out,
	input logic [7:0] band,
	input logic csr_flb_sdm_on,
	input logic csr_flb_sdm_order,
	input logic csr_flb_sdm_thrm_en,
	input logic csr_flb_sdm_man_on,
	input logic [2:0] csr_flb_sdm_man_val,
	input logic [1:0] csr_flb_mtrx_clk_lag,
	input logic [1:0] csr_flb_smpl_clk_lag,
	input logic csr_flb_rst_n,
	input logic [7:0] csr_div_ratio,
	input logic csr_div_power_down,
	
	// ANA_TOP outputs
	output logic dco_clk,
	output logic [63:0] sampled_tdc
);
	logic [15:0] row_p ; // 16-bit row positive output
	logic [15:0] row_n; // 16-bit row negative output
	logic [15:0] col_on; // 16-bit column on output
	logic [15:0] col_off; // 16-bit column off output	output logic [255:0] band_thrm,
	logic [15:0] band_thrm_hi;
	logic [15:0] band_thrm_lo;
	logic [7:0] band_bin;
	logic nsh_clk;
	logic [2:0] os_thrm;	

	// Instantiating FLB
	FLB flb_inst (
		.nsh_clk(nsh_clk),
		.ref_clk(ref_clk),
		.dlf_out(dlf_out),
		.band(band),
		.csr_flb_sdm_on(csr_flb_sdm_on),
		.csr_flb_sdm_order(csr_flb_sdm_order),
		.csr_flb_sdm_thrm_en(csr_flb_sdm_thrm_en),
		.csr_flb_sdm_man_on(csr_flb_sdm_man_on),
		.csr_flb_sdm_man_val(csr_flb_sdm_man_val),
		.csr_flb_mtrx_clk_lag(csr_flb_mtrx_clk_lag),
		.csr_flb_smpl_clk_lag(csr_flb_smpl_clk_lag),
		.csr_flb_rst_n(csr_flb_rst_n),
		//output 
		.os_thrm(os_thrm),
		.row_p(row_p),
		.row_n(row_n),
		.col_on(col_on),
		.col_off(col_off),
		.band_thrm_hi(band_thrm_hi),
		.band_thrm_lo(band_thrm_lo),
		.band_bin(band_bin)
	);

	// Instantiating DCO
	DCO dco_inst (
		.os_thrm(os_thrm),
		.row_p(row_p),
		.row_n(row_n),
		.col_on(col_on),
		.col_off(col_off),
		.band_thrm_hi(band_thrm_hi),
		.band_thrm_lo(band_thrm_lo),
		.band_bin(band_bin),
		//output 
		.dco_clk(dco_clk)
	);
	
	// Instantiating DIVIDER
	DIVIDER divider_inst (
		.clk_in(dco_clk),
		.divide_by(csr_div_ratio),
		.power_down(csr_div_power_down),
		//output 
		.clk_out(nsh_clk)
	);

	// Instantiating TDC
	tdc tdc_inst (
		.ref_clk(ref_clk),
		.dco(dco_clk),
		//output 
		.sampled_tdc(sampled_tdc)
	);

endmodule
