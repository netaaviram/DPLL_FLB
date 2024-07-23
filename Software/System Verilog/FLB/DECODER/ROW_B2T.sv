module ROW_B2T (
  input  [3:0] data_i,  
  input  [0:0] oc,   
  output [15:0] data_o
);

wire [15:0] th;
wire [3:0] bin;
assign bin = data_i ^ {4{oc}}; 

// Instantiate B2T
B2T B2T_inst (
	.binary(bin),
	.thermo(th)
);

assign data_o = (oc==1'b0) ? th : {th[14:0],1'b1};
//assign data_o = (oc==1'b0) ? th : (th<<1)|(16'b1);
//assign data_o = (oc==1'b0) ? th : (th<<1)+1;
//assign data_o = (oc==1'b0) ? th : (th*2)+1; 
 
endmodule

	  
