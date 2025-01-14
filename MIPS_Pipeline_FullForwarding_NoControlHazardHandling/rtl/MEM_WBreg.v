module MEM_WBreg (rst, clk, in, out);
	
	input rst, clk;
	input [103:0] in;

	output reg [103:0] out;

	always @(posedge clk, posedge rst)
	begin
		if(rst)
			out <= 104'd0;
		else 
			out <= in;

	end
endmodule
	
