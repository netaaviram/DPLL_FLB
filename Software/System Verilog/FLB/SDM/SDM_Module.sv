module SDM (
	input  logic nsh_clk,       
	input  logic [7:0] os_data, 
	input  logic sdm_on, 
	input  logic sdm_order,
	input  logic [2:0] sdm_man_val,
	input  logic sdm_man_on,
	input  logic sdm_thrm_en,
	//outputs
	output logic [1:0] os_bin,    
	output logic [2:0] os_thrm  
);

	logic [8:0] y0;
	logic [8:0] y0_m1;
	logic [8:0] y1;
	logic [8:0] y1_m1;
	logic order_rst;
	logic y0_msb;
	logic [1:0] bin;
	logic y1_msb;
	logic [2:0] b2t;
	logic [1:0] b2t_temp;

	// First-order delta-sigma modulator
	assign y0 = os_data + y0_m1[7:0]; 
	always_ff @(posedge nsh_clk /*or posedge sdm_on*/) begin
		if (sdm_on)
			y0_m1 <= y0;
		else
			y0_m1 <= 9'b0;
	end
	
	always_ff @(posedge nsh_clk) begin
			y0_msb <= y0_m1[8];
	end
	
	// Second-order delta-sigma modulator
	assign order_rst = sdm_order & sdm_on;
	assign y1 = y0_m1[7:0] + y1_m1[7:0];
	always_ff @(posedge nsh_clk /*or posedge order_rst*/) begin
		if (order_rst)
			y1_m1 <= y1;
		else
			y1_m1 <= 9'b0;
	end
	
	always_ff @(posedge nsh_clk) begin
		y1_msb <= ~y1_m1[8];
	end
	
	assign bin = y1_m1[8] + y0_msb + y1_msb ;
	
	always_ff @(posedge nsh_clk  /*or negedge sdm_thrm_en */) begin
		if (sdm_thrm_en)
			os_bin <= 2'b0;
		else
			os_bin <= bin;
	end
	
	// Thermometer code conversion
	assign b2t_temp = bin & {2{sdm_thrm_en}} ;
	always_comb begin
		case(b2t_temp)
			2'b00: b2t = 3'b000;
			2'b01: b2t = 3'b001;
			2'b10: b2t = 3'b011;
			2'b11: b2t = 3'b111;
		endcase
	end
	//Decoded manual SDM value.
	always_ff @(posedge nsh_clk) begin
		if (sdm_man_on)
			os_thrm <= sdm_man_val;
		else
			os_thrm <= b2t;
	end
endmodule
