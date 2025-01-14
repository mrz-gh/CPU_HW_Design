module MUX3to1 (inA, inB, inC, select, out);

	parameter n = 32;

	input [n-1:0] inA, inB, inC;
	input [1:0] select;

	output [n-1:0] out;

	assign out = (select == 00) ? inA : 
			(select == 01) ? inB : 
			(select == 10) ? inC : 32'bz;

	//initial $monitor("%b %b %b", inA, inB, inC);
endmodule
