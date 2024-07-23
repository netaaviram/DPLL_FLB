module SYNC (
	input  logic nsh_clk,     
	input  logic ref_clk, 
	input  logic [15:0] dlf_out, 
	input  logic [7:0] band,
	input  logic [1:0] mtrx_clk_lag,
	input  logic [1:0] smpl_clk_lag,
	output logic [7:0] s_os,     
	output logic [7:0] s_mtrx,   
	output logic [7:0] s_band,   
	output logic dec_clk         
);

	logic ref_clk_sampled;
	logic lv_pulse;
	logic q1;
	logic q2;
	logic q3;
	logic q4;
	logic smpl_clk;
	logic d1;
	logic ref_clk_sync; 
	logic sampled;
	
	//2-FF Synchronizer - CDC 
	
	always_ff @(posedge nsh_clk) begin
		sampled <= ref_clk;
	end
	
	always_ff @(posedge nsh_clk) begin
		ref_clk_sync <= sampled;
	  end
	
	always_ff @(posedge nsh_clk) begin
		ref_clk_sampled <= ref_clk_sync;
	end
	
	assign lv_pulse = (~ref_clk_sampled) & ref_clk_sync; 
	
	always_ff @(posedge nsh_clk) begin
	  q1 <= lv_pulse;
	end
	
	always_ff @(posedge nsh_clk) begin
	  q2 <= q1;
	end
	
	always_ff @(posedge nsh_clk) begin
	  q3 <= q2;
	end

	always_ff @(posedge nsh_clk) begin
	  q4 <= q3;
	end 
	
	always_comb begin
		case(smpl_clk_lag)
			2'b00: smpl_clk = q1;
			2'b01: smpl_clk = q2;
			2'b10: smpl_clk = q3;
			2'b11: smpl_clk = q4;
		endcase
	end
	
	always_comb begin
		case(mtrx_clk_lag)
			2'b00: d1 = q1;
			2'b01: d1 = q2;
			2'b10: d1 = q3;
			2'b11: d1 = q4;
		endcase
	end
	
	always_ff @(posedge nsh_clk) begin
	  dec_clk <= d1;
	end 
	
	always_ff @(posedge smpl_clk) begin
	  s_os <= dlf_out[7:0];
	  s_mtrx <= dlf_out[15:8];
	end
	
	always_ff @(posedge smpl_clk) begin
	  s_band <= band;
	end   

endmodule

