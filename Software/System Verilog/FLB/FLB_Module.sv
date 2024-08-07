module FLB (
	//Block inputs
	input  logic nsh_clk, 
	input  logic ref_clk,
	input  logic [15:0] dlf_out, 
	input  logic [7:0] band,
	//Registers Inputs (EMAS) 
	input  logic csr_flb_sdm_on,
	input  logic csr_flb_sdm_order,
	input  logic csr_flb_sdm_thrm_en,
	input  logic csr_flb_sdm_man_on,
	input  logic [2:0] csr_flb_sdm_man_val,
	input  logic [1:0] csr_flb_mtrx_clk_lag,
	input  logic [1:0] csr_flb_smpl_clk_lag,
	input  logic csr_flb_rst_n,
	//outputs 
	output logic [2:0] os_thrm,
	output logic [15:0] row_p, // 16-bit row positive output
	output logic [15:0] row_n, // 16-bit row negative output
	output logic [15:0] col_on, // 16-bit column on output
	output logic [15:0] col_off, // 16-bit column off output
	output logic [7:0] band_bin,
	output logic [15:0] band_thrm_hi,
	output logic [15:0] band_thrm_lo
);

	logic [7:0] s_os; //Input of the SDM
	logic dec_clk; //Input of the Decoder
	logic [7:0] s_mtrx; //Input of the Decoder
	logic [7:0] s_band; //Input of the Decoder
	logic [1:0] os_bin; //Input of the Decoder
	
//SYNC instantiation
SYNC my_synchronizer (
	.nsh_clk(nsh_clk),
	.ref_clk(ref_clk),
	.dlf_out(dlf_out), 
	.band(band), 
	.csr_flb_mtrx_clk_lag(csr_flb_mtrx_clk_lag),
	.csr_flb_smpl_clk_lag(csr_flb_smpl_clk_lag),
	.csr_flb_rst_n(csr_flb_rst_n),
	.s_os(s_os),
	.dec_clk(dec_clk),
	.s_mtrx(s_mtrx),
	.s_band(s_band)
);

//SDM instantiation
SDM my_sdm (
	.nsh_clk(nsh_clk),       
	.os_data(s_os), 
	.csr_flb_sdm_on(csr_flb_sdm_on), 
	.csr_flb_sdm_order(csr_flb_sdm_order),
	.csr_flb_sdm_man_val(csr_flb_sdm_man_val),
	.csr_flb_sdm_man_on(csr_flb_sdm_man_on),
	.csr_flb_sdm_thrm_en(csr_flb_sdm_thrm_en),
	.os_bin(os_bin),    
	.os_thrm(os_thrm)
);

//DECODER instantiation
DECODER my_dec (
	.csr_flb_rst_n(csr_flb_rst_n),
	.os_bin(os_bin),
	.clk(dec_clk),
	.s_mtrx(s_mtrx),
	.s_band(s_band),
	.row_p(row_p),
	.row_n(row_n),
	.col_on(col_on),
	.col_off(col_off),
	.band_thrm_hi(band_thrm_hi),
	.band_thrm_lo(band_thrm_lo),
	.band_bin(band_bin)
);

endmodule
