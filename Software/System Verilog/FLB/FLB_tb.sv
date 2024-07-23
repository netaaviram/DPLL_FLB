module FLB_tb;

// Parameters
logic nsh_clk;
logic ref_clk;
logic [15:0] dlf_out; 
logic [7:0] band;
wire [15:0] row_p;
wire [15:0] row_n;
wire [15:0] col_on;
wire [15:0] col_off;

// Registers Inputs (EMAS) 
logic sdm_on;
logic sdm_order;
logic sdm_thrm_en;
logic sdm_man_on;
logic [2:0] sdm_man_val;
logic [1:0] mtrx_clk_lag;
logic [1:0] smpl_clk_lag;
logic rst_n;

// Outputs 
logic [2:0] os_thrm;
logic [63:0] mtrx_thrm;
logic [255:0] band_thrm;
logic [7:0] band_bin;


// Instantiate the FLB module
FLB uut (
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

// Clock generation
always #5 nsh_clk = ~nsh_clk;
always #50 ref_clk = ~ref_clk;
assign col_off = mtrx_thrm[15:0];
assign col_on = mtrx_thrm[31:16];
assign row_n = mtrx_thrm[47:32];
assign row_p = mtrx_thrm[63:48];

initial begin
  // Initialize inputs
  nsh_clk = 0;
  ref_clk = 0;
  dlf_out = 16'h0000;
  band = 8'h00;
  sdm_on = 0;
  sdm_order = 0;
  sdm_thrm_en = 0;
  sdm_man_on = 0;
  sdm_man_val = 3'b000;
  mtrx_clk_lag = 2'b00;
  smpl_clk_lag = 2'b00;
  rst_n = 0;

  // Apply reset
  #50;
  rst_n = 1;

  // Apply test vectors
  #80;
  dlf_out = 16'h1234;
  band = 8'hAA;
  sdm_on = 1;
  sdm_order = 1;
  sdm_thrm_en = 1;
  sdm_man_on = 0;
  sdm_man_val = 3'b000;
  mtrx_clk_lag = 2'b11;
  smpl_clk_lag = 2'b00;

  #200;
  // Change test vectors
  dlf_out = 16'h5678;
  band = 8'hBB;
//  sdm_on = 0;
//  sdm_order = 0;
//  sdm_thrm_en = 0;
//  sdm_man_on = 0;
//  sdm_man_val = 3'b010;
  mtrx_clk_lag = 2'b10;
  smpl_clk_lag = 2'b01;

  #500;
  // End of simulation
  $stop;
end

// Monitor output signals
//initial begin
//  $monitor("Time: %t, os_thrm = %b, row_p = %b, row_n = %b, col_on = %b, col_off = %b, band_thrm = %b", 
//			$time, os_thrm, row_p, row_n, col_on, col_off, band_thrm);
//end

endmodule

