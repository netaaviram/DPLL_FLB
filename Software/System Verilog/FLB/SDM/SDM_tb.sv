module SDM_tb;

logic nsh_clk;       
logic [7:0] os_data; 
logic sdm_on; 
logic sdm_order;
logic [2:0] sdm_man_val;
logic sdm_man_on;
logic sdm_thrm_en;

logic [1:0] os_bin;    
logic [2:0] os_thrm; 
integer sum ;
integer count ; 
integer i ;
integer order;
real avg ; 
real theo_avg ; 
real i_f ; 
real sum_f ;
real os_data_f;

SDM uut (
	.nsh_clk(nsh_clk),       
	.os_data(os_data), 
	.sdm_on(sdm_on), 
	.sdm_order(sdm_order),
	.sdm_man_val(sdm_man_val),
	.sdm_man_on(sdm_man_on),
	.sdm_thrm_en(sdm_thrm_en),
	.os_bin(os_bin),    
	.os_thrm(os_thrm)  
);

initial begin
	sum = 0 ;
	count = 0 ;
	nsh_clk = 1'b0;
	os_data = 8'b0;
	sdm_on = 0;
	sdm_order = 0;
	sdm_man_val = 3'b0;
	sdm_man_on = 0;
	sdm_thrm_en = 1;

	for (i=0; i<10; i=i+1) begin
		#10;
		nsh_clk = 1'b1;
		#10;
		nsh_clk = 1'b0;
	end
	
	os_data = 8'b01000000;
	sdm_on = 1; 
	sdm_order = 1; //Second order SDM
	sdm_man_val = 3'b000;
	sdm_man_on = 0;
	sdm_thrm_en = 0;
	
	for (i=0; i<60; i=i+1) begin
		#10;
		nsh_clk = 1'b1;
		sum = sum + os_bin ;
		count = count + 1 ;
		$display("At time %t: os_bin = %d, os_thrm = %b , sum = %d , count = %d", $time, os_bin, os_thrm , sum, count);
		#10;
		nsh_clk = 1'b0;
	end

//Calculating the Average over time
  
	os_data_f = os_data ; 
	theo_avg = os_data_f / 256.0 ; 
	i_f = i ; 
	sum_f = sum ;
	avg = (sum_f / i_f) - 1.0; 
	order = sdm_order + 1;
	
	$display("SDM order = %d \nNumber of nsh_clk cycles = %d \nThe theoretical fraction value is = %f \nThe sdm average over time is = %f \n" ,order ,i,theo_avg,avg);
	$finish;
end
endmodule

