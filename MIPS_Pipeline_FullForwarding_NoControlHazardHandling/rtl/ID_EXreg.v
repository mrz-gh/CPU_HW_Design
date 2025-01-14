module ID_EXreg (rst, clk, in, out);
	
	input rst, clk;
	input [160:0] in;

	output reg [160:0] out;

	always @(posedge clk, posedge rst)
	begin
		if(rst)
			out <= 161'd0;
		else 
			out <= in;

	end
endmodule
	
