module ShL2 (in, out);

	input [31:0] in;
	output [31: 0] out;

	assign out = in << 2;
	//initial $monitor("%b %b %b", inA, inB, inC);

endmodule
