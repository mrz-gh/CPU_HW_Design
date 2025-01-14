
module EX_MEMreg (rst, clk, in, out);
	
	input rst, clk;
	input [105:0] in;

	output reg [105:0] out;

	always @(posedge clk, posedge rst)
	begin
		if(rst)
			out <= 106'd0;
		else 
			out <= in;

	end
endmodule
	