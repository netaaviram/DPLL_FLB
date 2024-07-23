module DECODER (
  input [1:0] os_bin,
  input  clk,   // clk input 
  input [7:0] s_mtrx, // binary representation 
  input [7:0] s_band,
  output reg [63:0] mtrx_thrm,
  output reg [255:0] band_thrm,
  output reg [7:0] band_bin
//  output reg [15:0] row_p, // 16-bit row positive output
//  output reg [15:0] row_n, // 16-bit row negative output
//  output reg [15:0] col_on, // 16-bit column on output
//  output reg [15:0] col_off // 16-bit column off output
);

  wire [15:0] data_o;
  wire [15:0] data_o_n;
  wire [15:0] rise_o;
  wire [15:0] fall_o;
  logic [15:0] row_p; // 16-bit row positive output
  logic [15:0] row_n; // 16-bit row negative output
  logic [15:0] col_on; // 16-bit column on output
  logic [15:0] col_off; // 16-bit column off output
  

	// Instantiate ROW_B2T
	ROW_B2T ROW_B2T_inst (
	  .data_i(s_mtrx[3:0]),
	  .oc(s_mtrx[4]),
	  .data_o(data_o)
	);

  // Instantiate COL_B2T  
  COL_B2T COL_B2T_inst (
	.bin(s_mtrx[7:4]),
	.rise_o(rise_o),
	.fall_o(fall_o)
  );

  assign data_o_n = ~data_o;

  always @( posedge clk)
  begin
	row_p <= data_o;
	row_n <= data_o_n;
  end
  
  always @( posedge clk)
  begin
	col_on <= rise_o;
	col_off <= fall_o;
	band_bin <= s_band; //Binary band output
  end 
  assign mtrx_thrm = {row_p, row_n, col_on, col_off}; 

  //Generating thermometric band output
  
  always @(posedge clk) begin  
	  band_thrm <= 256'b0; // Initialize all bits to 0	  
	  band_thrm <= (256'b1 << s_band) - 256'b1; // Generate thermometer code using shift logic		
  end
endmodule

