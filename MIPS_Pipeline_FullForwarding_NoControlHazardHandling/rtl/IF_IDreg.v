module IF_IDreg (rst, clk, write, in, out);
	
	input rst, clk;
	input write;
	input [63:0] in;

	output reg [63:0] out;

	always @(posedge clk, posedge rst)
	begin
		if(rst)
			out <= 63'd0;
		else if (write)
			out <= in;

	end
endmodule
