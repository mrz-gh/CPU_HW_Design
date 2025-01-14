module Adder32bit (inA, inB, out);


	input [31:0] inA, inB;
	output [31:0] out;


	wire co;


	assign {co, out} = inA + inB;


endmodule
