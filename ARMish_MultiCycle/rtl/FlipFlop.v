module FlipFlop (rst, clk, ld, in, out);

	input rst, clk;
	input ld;
	input in;
	
	output reg out;
	
	always @(posedge clk, posedge rst)
		begin
			if (rst)
				out <= 1'b0;
			else if (ld)
				out <= in;

		end

endmodule
