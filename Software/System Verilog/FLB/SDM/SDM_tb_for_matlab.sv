module SDM_tb_for_matlab;

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
real data_file;
integer seed;
real value;

SDM uut (
	.nsh_clk(nsh_clk),       
	.os_data(os_data+value), 
	.sdm_on(sdm_on), 
	.sdm_order(sdm_order),
	.sdm_man_val(sdm_man_val),
	.sdm_man_on(sdm_man_on),
	.sdm_thrm_en(sdm_thrm_en),
	.os_bin(os_bin),    
	.os_thrm(os_thrm)  
);

initial begin
	value = 0;
	sum = 0 ;
	count = 0 ;
	nsh_clk = 1'b0;
	os_data = 8'b0;
	sdm_on = 0;
	sdm_order = 0;
	sdm_man_val = 3'b0;
	sdm_man_on = 0;
	sdm_thrm_en = 1;
	seed = $urandom();
	data_file = $fopen("sdm_data.txt", "w");

	for (i=0; i<10; i=i+1) begin
		#10;
		nsh_clk = 1'b1;
		#10;
		nsh_clk = 1'b0;
	end
	
	os_data = 130;
	sdm_on = 1;
	sdm_order = 1;
	sdm_man_val = 3'b000;
	sdm_man_on = 0;
	sdm_thrm_en = 0;
  
	//Collecting output samples to data_file
  
	for (i=0; i<100000; i=i+1) begin
		#10;
		value = ($dist_normal(seed, 0, 1000) > 0);
		nsh_clk = 1'b1;
		sum = sum + os_bin ;
		count = count + 1 ;
		$fwrite(data_file, "%d\n", os_bin);
		#10;
		nsh_clk = 1'b0;
	end
	
	$fclose(data_file);
	$finish;
end
endmodule

