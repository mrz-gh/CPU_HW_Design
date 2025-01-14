`timescale 1ns/1ns
module mu2to1 (inA, inB, select, out);

	input [3:0] inA, inB;
	input select;
	
	reg [3:0] outp;
	output [3:0] out;

	always @(inA, inB, select)begin
		if (select) 
			outp = inB;
		else
			outp = inA;
	end
	assign out = outp;
	
	//initial $monitor("%b %b %b", inA, inB, out);
endmodule