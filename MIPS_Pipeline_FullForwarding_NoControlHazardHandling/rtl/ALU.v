`define ADD 3'b000
`define SUB 3'b001
`define AND 3'b010
`define OR 3'b011
`define SLT 3'b100
`define ShR2 3'b101

module ALU (ALUop, inA, inB, out, zero);

	input [2:0] ALUop;
	input signed [31:0] inA, inB;

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
		`ShR2 : out = inA >> 2;
		default : out = 32'b0;
		endcase
	end
	assign zero = (out == 32'd0) ? 1'b1 : 1'b0;
	//initial $monitor("%d %d %d %b", out, inA, inB, ALUop);
endmodule