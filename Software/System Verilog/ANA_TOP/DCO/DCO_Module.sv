//`timescale 1ps/1fs

module DCO (
	input [15:0] band_thrm_hi, //Output of the FLB
	input [15:0] band_thrm_lo, //Output of the FLB
	input [7:0] band_bin, //Output of the FLB
	input [15:0] row_p, //Output of the FLB
	input [15:0] row_n, //Output of the FLB
	input [15:0] col_on, //Output of the FLB
	input [15:0] col_off, //Output of the FLB 
	input [2:0] os_thrm, //Output of the FLB
	output logic dco_clk //Input of the divider
);

integer dco_cap_num;

// Instantiate ENCODER
ENCODER ENCODER_inst (
  .row_p(row_p),
  .dco_cap_num(dco_cap_num)
);
	// Parameters
	parameter real Ind         = 12e-10;
	parameter real Cmin       = 170e-15;   
	parameter real Coarse     = 36e-15;    
	parameter real Fine       = 4e-15;     
	parameter real SmallCap   = 33e-18;   
	parameter real NsSgm      = 30e-6;     
	parameter integer NumOfCoarse = 0;
	parameter integer NumOfFine   = 5;

	// Constants
	real pi = $acos(-1);
	
	// Internal variables
	real total_cap;
	real fdco;
	real time_clk;
	real dlf_norm;
   	integer coarse_act;
	integer fine_act;
	integer seed;
	real random;
	
	initial 
	  begin
		 dco_clk = 1'b0;
		 seed = 0;
	  end

	assign coarse_act = (band_bin[7:4] > NumOfCoarse) ? NumOfCoarse : band_bin[7:4];
	assign fine_act = (band_bin[3:0] > NumOfFine) ? NumOfFine : band_bin[3:0];

	always @(posedge dco_clk) begin
		
		random = $itor($dist_normal(seed, 0, 100000000))/100000000;
		dlf_norm = dco_cap_num + os_thrm[2] + os_thrm[1] + os_thrm[0]; // Encoder's output + num of ones(os_thrm[2:0])   		
		
		total_cap = Cmin + (coarse_act * Coarse) + (fine_act * Fine) + (dlf_norm * SmallCap);
	   
		fdco = 1 / (2 * pi * $sqrt(total_cap * Ind))*(1 + NsSgm*random);
	   
		time_clk = (1 / fdco) * 1e12;
	   
		//seed=seed+1;
	end

	always begin
		#(time_clk) dco_clk = ~dco_clk;
	end 
endmodule
