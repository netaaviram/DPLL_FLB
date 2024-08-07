module FLB_tb;

// Parameters
logic nsh_clk;
logic ref_clk;
logic [15:0] dlf_out; 
logic [7:0] band;
logic [15:0] band_thrm_hi;
logic [15:0] band_thrm_lo;

// Registers Inputs (EMAS) 
logic csr_flb_sdm_on;
logic csr_flb_sdm_order;
logic csr_flb_sdm_thrm_en;
logic csr_flb_sdm_man_on;
logic csr_flb_rst_n;
logic [2:0] csr_flb_sdm_man_val;
logic [1:0] csr_flb_mtrx_clk_lag;
logic [1:0] csr_flb_smpl_clk_lag;


// Outputs 
logic [2:0] os_thrm;
logic [7:0] band_bin;


// Instantiate the FLB module
FLB uut (
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

// Clock generation
always #5 nsh_clk = ~nsh_clk;
always #50 ref_clk = ~ref_clk;

initial begin
  // Initialize inputs
  nsh_clk = 1'b0;
  ref_clk = 1'b0;
  dlf_out = 16'h0000;
  band = 8'h00;
  csr_flb_sdm_on = 1'b0;
  csr_flb_sdm_order = 1'b0;
  csr_flb_sdm_thrm_en = 1'b0;
  csr_flb_sdm_man_on = 1'b0;
  csr_flb_sdm_man_val = 3'b000;
  csr_flb_mtrx_clk_lag = 2'b00;
  csr_flb_smpl_clk_lag = 2'b00;
  csr_flb_rst_n = 1'b0;

  // Apply reset
  #50;
  csr_flb_rst_n = 1'b1;

  // Apply test vectors
  #80;
  dlf_out = 16'h1234; 
  band = 8'hAA;
  csr_flb_sdm_on = 1'b1; //noise shaping enabled
  csr_flb_sdm_order = 1'b1; //second order SDM
  csr_flb_sdm_thrm_en = 1'b1; //thermometric output enabled
  csr_flb_sdm_man_on = 1'b0; // manually output disabled
  csr_flb_sdm_man_val = 3'b000;
  csr_flb_mtrx_clk_lag = 2'b11;
  csr_flb_smpl_clk_lag = 2'b00;

  #200;
  // Change test vectors
  dlf_out = 16'h5678;
  band = 8'hBB;
  csr_flb_mtrx_clk_lag = 2'b10;
  csr_flb_smpl_clk_lag = 2'b01;

  #500;
  // End of simulation
 $finish;
end

// Monitor output signals
initial begin
  $monitor("Time: %t, os_thrm = %b, row_p = %b, row_n = %b, col_on = %b, col_off = %b, band_thrm_hi = %b, band_thrm_lo = %b", 
			$time, os_thrm, row_p, row_n, col_on, col_off, band_thrm_hi, band_thrm_lo);
end

endmodule
