`define ADD 3'b000
`define SUB 3'b001
`define AND 3'b010
`define COMP 3'b011
`define MVB 3'b100


module ALU (ALUFunc, inA, inB, out, C, V, Z, N);

	input [2:0] ALUFunc;
	input [31:0] inA, inB;

	output reg [31:0] out;
	output reg C, V;
	output Z, N;

	wire [31:0] inBcomp;

	assign inBcomp = - inB;

	always @(ALUFunc, inA, inB)begin

		out = 32'd0;
		C = 1'b0;
		V = 1'b0;

		case (ALUFunc)

		`ADD : begin 
			{C, out} = inA + inB;
			V = (inA[31] & inB[31] & ~out[31]) | (~inA[31] & ~inB[31] & out[31]);
			end

		`SUB : begin 
			{C, out} = inA + inBcomp;
			V = (inA[31] & inBcomp[31] & ~out[31]) | (~inA[31] & ~inBcomp[31] & out[31]);
			end

		`AND : out = inA & inB;

		`COMP : out = inBcomp;

		`MVB : out = inB;

		default : begin 
				out = 32'b0;
				C = 1'b0;
				V = 1'b0;
			end
		endcase
	end
	assign Z = ~|(out[31:0]);
	assign N = out[31];
	//initial $monitor("%d %d %d %b", out, inA, inB, ALUop);
endmodule