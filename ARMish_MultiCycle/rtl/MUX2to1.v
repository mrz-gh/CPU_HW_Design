module MUX2to1 (inA, inB, select, out);

	input [31:0] inA, inB;
	input select;
	
	reg [31:0] outp;
	output [31:0] out;

	always @(inA, inB, select)begin
		if (select) 
			outp = inB;
		else
			outp = inA;
	end
	assign out = outp;

endmodule
