module SYNC (
	input  logic nsh_clk,     
	input  logic ref_clk, 
	input  logic [15:0] dlf_out, 
	input  logic [7:0] band,
	input  logic [1:0] csr_flb_mtrx_clk_lag,
	input  logic [1:0] csr_flb_smpl_clk_lag,
	input  logic csr_flb_rst_n,
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
	
	//2-FF Synchronizer for CDC 
	
	always_ff @(posedge nsh_clk or negedge csr_flb_rst_n) begin
		if (~csr_flb_rst_n)
			sampled <= 1'd0;
		else
			sampled <= ref_clk;
	end
	
	always_ff @(posedge nsh_clk or negedge csr_flb_rst_n) begin
		if (~csr_flb_rst_n)			
			ref_clk_sync <= 1'd0;
		else
			ref_clk_sync <= sampled;
	  end
	
	always_ff @(posedge nsh_clk or negedge csr_flb_rst_n) begin
		if (~csr_flb_rst_n)
			ref_clk_sampled <= 1'd0;
		else			
			ref_clk_sampled <= ref_clk_sync;
	end
	
	assign lv_pulse = (~ref_clk_sampled) & ref_clk_sync; //creating a pulse when a rise in ref_clk is detected
	
	always_ff @(posedge nsh_clk or negedge csr_flb_rst_n) begin
		if (~csr_flb_rst_n)
			q1 <= 1'b0;
		else
			q1 <= lv_pulse;
	end
	
	always_ff @(posedge nsh_clk or negedge csr_flb_rst_n) begin
		if (~csr_flb_rst_n)
			q2 <= 1'd0;
		else 
			q2 <= q1;
	end
	
	always_ff @(posedge nsh_clk or negedge csr_flb_rst_n) begin
		if (~csr_flb_rst_n)
			q3 <= 1'd0;
		else 
			q3 <= q2;
	end

	always_ff @(posedge nsh_clk or negedge csr_flb_rst_n) begin
		if (~csr_flb_rst_n)
			q4 <= 1'd0;
		else 
			q4 <= q3;
	end
	
	//Sampling the lv_pulse according to smpl_clk_lag[1:0]
	
	always_comb begin
		case(csr_flb_smpl_clk_lag)
			2'b00: smpl_clk = q1;
			2'b01: smpl_clk = q2;
			2'b10: smpl_clk = q3;
			2'b11: smpl_clk = q4;
		endcase
	end
	
	//Sampling the lv_pulse according to mtrx_clk_lag[1:0]
	
	always_comb begin
		case(csr_flb_mtrx_clk_lag)
			2'b00: d1 = q1;
			2'b01: d1 = q2;
			2'b10: d1 = q3;
			2'b11: d1 = q4;
		endcase
	end
	
	//Delaying dec_clk by one cycle, so the default space between smpl_clk and dec_clk is at least one cycle
	
	
	always_ff @(posedge nsh_clk or negedge csr_flb_rst_n) begin
		if (~csr_flb_rst_n)
			dec_clk <= 1'b0;
		else 
			dec_clk <= d1; //dec_clk is used as an input of the decoder to sample the outputs of the FLB to the DCO
	end
	
	//smpl_clk is used to sample the inputs of the synchronizer
	
	always_ff @(posedge smpl_clk or negedge csr_flb_rst_n) begin
		if (~csr_flb_rst_n) begin
			s_os <= 8'b0;
			s_mtrx <= 8'b0;
		end	  	
		else begin
		  	s_os <= dlf_out[7:0];
		  	s_mtrx <= dlf_out[15:8] ;
		end
	end
	
	always_ff @(posedge smpl_clk or negedge csr_flb_rst_n) begin			
		if (~csr_flb_rst_n)
			s_band <= 8'b0;
		else
			s_band <= band;
	end   

endmodule
