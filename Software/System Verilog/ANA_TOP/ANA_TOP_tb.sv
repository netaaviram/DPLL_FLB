//`timescale 1ps/1fs

module tb_ANA_TOP;

	// Testbench signals
	logic tb_ref_clk;
	logic [15:0] tb_dlf_out;
	logic [7:0] tb_band;
	logic tb_csr_flb_sdm_on;
	logic tb_csr_flb_sdm_order;
	logic tb_csr_flb_sdm_thrm_en;
	logic tb_csr_flb_sdm_man_on;
	logic [2:0] tb_csr_flb_sdm_man_val;
	logic [1:0] tb_csr_flb_mtrx_clk_lag;
	logic [1:0] tb_csr_flb_smpl_clk_lag;
	logic tb_csr_flb_rst_n;
	logic [7:0] tb_csr_div_ratio;
	logic tb_csr_div_power_down;

	// Outputs from ANA_TOP
	logic tb_dco_clk;
	logic [63:0] tb_sampled_tdc;

	// Instantiate the ANA_TOP module
	ANA_TOP uut (
		.ref_clk(tb_ref_clk),
		.dlf_out(tb_dlf_out),
		.band(tb_band),
		.csr_flb_sdm_on(tb_csr_flb_sdm_on),
		.csr_flb_sdm_order(tb_csr_flb_sdm_order),
		.csr_flb_sdm_thrm_en(tb_csr_flb_sdm_thrm_en),
		.csr_flb_sdm_man_on(tb_csr_flb_sdm_man_on),
		.csr_flb_sdm_man_val(tb_csr_flb_sdm_man_val),
		.csr_flb_mtrx_clk_lag(tb_csr_flb_mtrx_clk_lag),
		.csr_flb_smpl_clk_lag(tb_csr_flb_smpl_clk_lag),
		.csr_flb_rst_n(tb_csr_flb_rst_n),
		.csr_div_ratio(tb_csr_div_ratio),
		.csr_div_power_down(tb_csr_div_power_down),
		//output
		.dco_clk(tb_dco_clk),
		.sampled_tdc(tb_sampled_tdc)
	);

	// Clock generation
	initial begin
		tb_ref_clk = 0;
		forever #5 tb_ref_clk = ~tb_ref_clk; // 100 MHz clock
	end

	// Testbench stimulus
	initial begin
		// Initialize inputs
		tb_dlf_out = 16'h0000;
		tb_band = 8'h00;
		tb_csr_flb_sdm_on = 0;
		tb_csr_flb_sdm_order = 0;
		tb_csr_flb_sdm_thrm_en = 0;
		tb_csr_flb_sdm_man_on = 0;
		tb_csr_flb_sdm_man_val = 3'b000;
		tb_csr_flb_mtrx_clk_lag = 2'b00;
		tb_csr_flb_smpl_clk_lag = 2'b00;
		tb_csr_flb_rst_n = 0;
		tb_csr_div_ratio = 8'h02; // Example divide by 2
		tb_csr_div_power_down = 0;

		// Reset the design
		#20;
		tb_csr_flb_rst_n = 1;
		
		// Apply some test stimuli
		#100;
		tb_dlf_out = 16'h00FF;
		tb_band = 8'hAA;
		tb_csr_flb_sdm_on = 1; 
		tb_csr_flb_sdm_order = 1; //for second order SDM
		tb_csr_flb_sdm_thrm_en = 0; //Binary output os_bin[1:0]
		tb_csr_flb_sdm_man_on = 0;
		tb_csr_flb_sdm_man_val = 3'b101;
		tb_csr_flb_mtrx_clk_lag = 2'b10;
		tb_csr_flb_smpl_clk_lag = 2'b01;
		tb_csr_div_ratio = 8'h04; // Change divide ratio

		// Wait and observe the outputs
		#500;
		
		// Add more stimuli if needed
		// ...

		// End the simulation
		#1000;
		$stop;
	end

endmodule
