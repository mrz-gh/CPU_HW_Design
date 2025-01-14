
module Reg32bitW (rst, clk, write, in, out);
	
	input rst, clk;
	input write;
	input [31:0] in;

	output reg [31:0] out;

	always @(posedge clk, posedge rst)
	begin
		if(rst)
			out <= 32'd0;
		else if (write)
			out <= in;

	end
endmodule
	