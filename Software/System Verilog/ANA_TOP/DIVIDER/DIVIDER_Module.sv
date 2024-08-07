module DIVIDER(
	input logic clk_in,            // Input clock
	input logic [7:0] divide_by,   // Divide factor (must be a power of 2, up to 64)
	input logic power_down,		// if power_down = 1 --> clk_out = 0
	output logic clk_out           // Output divided clock
);

	logic clk2;                    // Clock divided by 2
	logic clk4;                    // Clock divided by 4
	logic clk8;                    // Clock divided by 8
	logic clk16;                   // Clock divided by 16
	logic clk32;                   // Clock divided by 32
	logic clk64;                   // Clock divided by 64

	// Initialize clocks
	initial begin
		clk2 = 1'b0;
		clk4 = 1'b0;
		clk8 = 1'b0;
		clk16 = 1'b0;
		clk32 = 1'b0;
		clk64 = 1'b0;
		//clk_out = 0;
	end

	// Clock division logic
	always @(posedge clk_in or posedge power_down) begin
		if (power_down) begin
			clk2 <= 1'b0;
		end
		else begin
			clk2 <= ~clk2;            // Toggle clk2 on each rising edge of clk_in
		end
	end

	always @(posedge clk2 or posedge power_down) begin
		if (power_down) begin
			clk4 <= 1'b0;
		end
		else begin
			clk4 <= ~clk4;            // Toggle clk4 on each rising edge of clk2
		end
	end

	always @(posedge clk4 or posedge power_down) begin
		if (power_down) begin
			clk8 <= 1'b0;
		end
		else begin
			clk8 <= ~clk8;            // Toggle clk8 on each rising edge of clk4
		end
	end
	
	always @(posedge clk8 or posedge power_down) begin
		if (power_down) begin
			clk16 <= 1'b0;
		end
		else begin
			clk16 <= ~clk16;            // Toggle clk16 on each rising edge of clk8
		end
	end

	always @(posedge clk16 or posedge power_down) begin
		if (power_down) begin
			clk32 <= 1'b0;
		end
		else begin
			clk32 <= ~clk32;            // Toggle clk32 on each rising edge of clk16
		end
	end

	always @(posedge clk32 or posedge power_down) begin
		if (power_down) begin
			clk64 <= 1'b0;
		end
		else begin
			clk64 <= ~clk64;            // Toggle clk64 on each rising edge of clk_32
		end
	end

	// Assign clk_out based on divide_by
	always_comb begin
		if (power_down) begin
			clk_out = 1'b0;
			end
		else begin
			case (divide_by)
				8'd2: clk_out = clk2;
				8'd4: clk_out = clk4;
				8'd8: clk_out = clk8;
				8'd16: clk_out = clk16;
				8'd32: clk_out = clk32;
				8'd64: clk_out = clk64;
				default: clk_out = clk_in; // Pass through input clock if invalid value
			endcase
		end
	end
endmodule

