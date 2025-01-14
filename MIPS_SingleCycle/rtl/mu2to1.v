`timescale 1ns/1ns
module mu2to1 (inA, inB, select, out);

	input [4:0] inA, inB;
	input select;
	
	reg [4:0] outp;
	output [4:0] out;

	always @(inA, inB, select)begin
		if (select) 
			outp = inB;
		else
			outp = inA;
	end
	assign out = outp;
	
	//initial $monitor("%b %b %b", inA, inB, out);
endmodule