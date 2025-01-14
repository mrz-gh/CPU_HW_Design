`define IF 4'd0
`define ID 4'd1
`define DPI_TC1 4'd2
`define DPI_TC2 4'd3
`define DPI_e1 4'd4
`define DPI_e2 4'd5
`define DTI0_1 4'd6
`define DTI0_2 4'd7
`define DTI0_3 4'd8
`define DTI1_1 4'd9
`define DTI1_2 4'd10
`define BI 4'd11
`define BI0 4'd12
`define BI1 4'd13



`define ADD 3'b000
`define SUB 3'b001
`define RSB 3'b010
`define AND 3'b011
`define NOT 3'b100
`define TST 3'b101
`define CMP 3'b110
`define MOV 3'b111


module Controller (rst, clk, 	//inputs
	LT, GT, EQ, Inst, 	//inputs from DP
	PCWrite, J, IRWrite, RegWrite, ldZN, ldCV, 	// Sequential Control Signals
	IorD, sel, RegDst, MemToReg, PCSrc, 	// Combinational Control Signals
	ALUSrcA, ALUSrcB, ALUOperation, 	// Combinational Control Signals
	MemWrite, MemRead 	// Memory Control Signals
	);

	input rst, clk;
	input LT, GT, EQ;
	input [31:0] Inst;
	
	output reg PCWrite, J, IRWrite, RegWrite, ldZN, ldCV;
	output reg IorD, sel, RegDst, PCSrc;
	output reg [1:0] MemToReg;
	output reg [1:0] ALUSrcA, ALUSrcB;
	output reg [2:0] ALUOperation;
	output reg MemWrite, MemRead;

	wire [1:0] C;
	wire L_DTI, L_BI, I;
	wire [2:0] opc;
	reg [1:0] ALUop;
	
	reg [3:0] ps, ns;


	assign C = Inst[31:30];
	assign opc = Inst[22:20];
	assign {L_DTI, L_BI, I} = {Inst[20], Inst[26], Inst[23]};

	always @(ps, LT, GT, EQ, Inst) 
	begin
	{PCWrite, J, IRWrite, RegWrite, IorD, sel, RegDst, PCSrc, ldCV, ldZN} = 10'd0;
	{MemToReg, ALUSrcA, ALUSrcB, ALUop, MemWrite, MemRead} = 9'd0;
	ns = 4'd0;
	case(ps)
		`IF : begin
			ns = `ID;
			MemRead = 1'b1;
			ALUSrcA = 2'b00;
			ALUSrcB = 2'b01;
			IorD = 1'b0;
			IRWrite = 1'b1;
			ALUop = 2'b00;
			PCSrc = 1'b0;
			PCWrite = 1'b1;
		end
		`ID : begin
			sel = 1'b0;
			ALUSrcA = 2'b00;
			ALUSrcB = 2'b01;
			ALUop = 2'b01;

			if ((~C[1] & ~C[0] & EQ) | (~C[1] & C[0] & GT) | (C[1] & ~C[0] & LT) | (C[1] & C[0])) begin
				if (Inst[29:24] == 6'b000000) 
					ns = (opc == `TST) | (opc == `CMP) ? `DPI_TC1 : `DPI_e1 ;
				else if (Inst[29:21] == 9'b0_1000_0000) 
					ns = L_DTI ? `DTI1_1 : `DTI0_1 ;
				else if (Inst[29:27] == 3'b101)
					ns = `BI;
				else
					ns = 4'bzzzz;
			end
			else ns = `IF;
					   
		end
		`DPI_TC1 : begin 
			ns = `DPI_TC2;
			sel = 1'b0;
		end
		`DPI_TC2 : begin
			ns = `IF;
			ALUSrcA = 2'b10;
			ALUSrcB = I ? 2'b10 : 2'b00;
			ldZN = 1'b1;
			ldCV = (opc == `CMP) ? 1'b1 : 1'b0 ;
			ALUop = 2'b10;
		end
		`DPI_e1 : begin
			ns = `DPI_e2;
			ALUSrcA = 2'b10;
			ALUSrcB = I ? 2'b10 : 2'b00;
			ldZN = 1'b1;
			ldCV = (opc == `ADD) | (opc == `SUB) | (opc == `RSB) ? 1'b1 : 1'b0 ;
			ALUop = 2'b10;
		end
		`DPI_e2 : begin
			ns = `IF;
			RegDst = 1'b1;
			RegWrite = 1'b1;
			MemToReg = 2'b01;
		end
		`DTI0_1 : begin
			ns = `DTI0_2;
			ALUSrcA = 2'b10;
			ALUSrcB = 2'b10;
			ALUop = 2'b00;
		end
		`DTI0_2 : begin
			ns = `DTI0_3;
			IorD = 1'b1;
			MemRead = 1'b1;
		end
		`DTI0_3 : begin
			ns = `IF;
			RegDst = 1'b1;
			MemToReg = 2'b10;
			RegWrite = 1'b1;
		end
		`DTI1_1 : begin
			ns = `DTI1_2;
			ALUSrcA = 2'b10;
			ALUSrcB = 2'b10;
			ALUop = 2'b00;
			sel = 1'b1;
		end
		`DTI1_2 : begin
			ns = `IF;
			IorD = 1'b1;
			MemWrite = 1'b1;
		end
		`BI : begin
			ns = (L_BI == 1'b0) ? `BI0 : `BI1;
			ALUSrcA = 2'b01;
			ALUSrcB = 2'b11;
			ALUop = 2'b00;
		end
		`BI0 : begin
			ns = `IF;
			PCSrc = 1'b1;
			J = 1'b1;
		end
		`BI1 : begin
			ns = `IF;
			PCSrc = 1'b1;
			J = 1'b1;
			RegDst = 1'b0;
			MemToReg = 2'b00;
			RegWrite = 1'b1;
		end

		default : ns = 4'bzzzz;
	endcase
	end
	
	// ALU OPERATION
	always @(ALUop, opc)
	begin
	ALUOperation = 3'b000;
		if(ALUop == 2'b00) 
			ALUOperation = 3'b000;
		else if (ALUop == 2'b01)		
			ALUOperation = 3'b001;
		else if (ALUop == 2'b10) begin
			case(opc)
			`ADD : ALUOperation = 3'b000;
			`SUB : ALUOperation = 3'b001;
			`RSB : ALUOperation = 3'b001;
			`CMP : ALUOperation = 3'b001;
			`AND : ALUOperation = 3'b010;
			`TST : ALUOperation = 3'b010;
			`NOT : ALUOperation = 3'b011;
			`MOV : ALUOperation = 3'b100;
			default : ALUOperation = 3'bzzz;
			endcase
		end
	end

	always @(posedge clk, posedge rst)
	begin
		if(rst) 
			ps <= 4'b0000;
		else 
			ps <= ns;
	end
endmodule

	
		
