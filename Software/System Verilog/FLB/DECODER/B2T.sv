module B2T(
	input  [3:0] binary,   // 4-bit binary input
	output reg [15:0] thermo // 16-bit thermometer code output
);
  
always @(*) begin  
	thermo = 16'b0; // Initialize all bits to 0
	
	thermo = (16'b1 << binary) - 16'b1; // Generate thermometer code using shift logic		
		
	//integer i ;
	//for (i=0; i<16; i=i+1) begin
	  //if (i[3:0] < binary[3:0])
	  //thermo[i] = 1'b1;  
	//end
end
endmodule
