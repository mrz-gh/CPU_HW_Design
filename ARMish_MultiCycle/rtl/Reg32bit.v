module Reg32bit (rst, clk, in, out);
	
	input rst, clk;
	input [31:0] in;

	output reg [31:0] out;

	always @(posedge clk, posedge rst)
	begin
		if(rst)
			out <= 32'd0;
		else 
			out <= in;

	end
endmodule
	
