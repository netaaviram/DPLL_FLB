module FLB (
	//Block inputs
	input  logic nsh_clk, 
	input  logic ref_clk,
	input  logic [15:0] dlf_out, 
	input  logic [7:0] band,
	//Registers Inputs (EMAS) 
	input  logic sdm_on,
	input  logic sdm_order,
	input  logic sdm_thrm_en,
	input  logic sdm_man_on,
	input  logic [2:0] sdm_man_val,
	input  logic [1:0] mtrx_clk_lag,
	input  logic [1:0] smpl_clk_lag,
	input  logic rst_n,
	//outputs 
	output logic [2:0] os_thrm,
	output logic [63:0] mtrx_thrm,
	output logic [255:0] band_thrm,
	output logic [7:0] band_bin
);

	logic [7:0] s_os;
	logic dec_clk;
	logic [7:0] s_mtrx;
	logic [7:0] s_band;
	logic [1:0] os_bin;
	
//SYNC instantiation
SYNC my_synchronizer (
	.nsh_clk(nsh_clk),
	.ref_clk(ref_clk),
	.dlf_out(dlf_out), 
	.band(band), 
	.mtrx_clk_lag(mtrx_clk_lag),
	.smpl_clk_lag(smpl_clk_lag),
	.s_os(s_os),
	.dec_clk(dec_clk),
	.s_mtrx(s_mtrx),
	.s_band(s_band)
);

//SDM instantiation
SDM my_sdm (
	.nsh_clk(nsh_clk),       
	.os_data(s_os), 
	.sdm_on(sdm_on), 
	.sdm_order(sdm_order),
	.sdm_man_val(sdm_man_val),
	.sdm_man_on(sdm_man_on),
	.sdm_thrm_en(sdm_thrm_en),
	.os_bin(os_bin),    
	.os_thrm(os_thrm)
);

//DECODER instantiation
DECODER my_dec (
	.os_bin(os_bin),
	.clk(dec_clk),
	.s_mtrx(s_mtrx),
	.s_band(s_band),
	.mtrx_thrm(mtrx_thrm),
	.band_thrm(band_thrm),
	.band_bin(band_bin)
);

endmodule
