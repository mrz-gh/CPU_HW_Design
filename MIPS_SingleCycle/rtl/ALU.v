`define ADD 3'b000
`define SUB 3'b001
`define AND 3'b010
`define OR 3'b011
`define SLT 3'b100


module ALU (ALUop, inA, inB, out, zero);

	input [2:0] ALUop;
	input [31:0] inA, inB;

	output reg [31:0] out;
	output zero;
	reg co;

	always @(ALUop, inA, inB)begin

		out = 32'd0;

		case (ALUop)

		`ADD : {co, out} = inA + inB;
		`SUB : out = inA - inB;
		`AND : out = inA & inB;
		`OR : out = inA | inB;
		`SLT : begin if ( inA < inB) 
				out = 32'd1;
			else 
				out = 32'd0;
		end
		default : out = 32'b0;
		endcase
	end
	assign zero = (out == 32'd0) ? 1 : 0;
	//initial $monitor("%d %d %d %b", out, inA, inB, ALUop);
endmodule