module Processor (rst, clk, MemOut,
	MemWrite, MemRead, MemAddr, WriteMem );

	input rst, clk;
	input [31:0] MemOut;
	
	output MemWrite, MemRead;
	output [31:0] MemAddr, WriteMem;
	
	wire PCWrite, IorD, J, sel, RegDst, IRWrite, RegWrite, PCSrc, ldCV, ldZN, LT, GT, EQ;
	wire [1:0] MemToReg, ALUSrcA, ALUSrcB;
	wire [2:0] ALUOperation;
	wire [31:0] Instruction;

	DataPath DP ( .clk(clk),
		.rst(rst),
		.PCWrite(PCWrite),
		.IorD(IorD),
		.J(J),
		.MemAddr(MemAddr),
		.WriteMem(WriteMem),
		.MemOut(MemOut),
		.sel(sel),
		.RegDst(RegDst),
		.IRWrite(IRWrite),
		.MemToReg(MemToReg),
		.RegWrite(RegWrite),
		.ALUSrcA(ALUSrcA),
		.ALUSrcB(ALUSrcB),
		.ALUop(ALUOperation), //ALUOperation
		.PCSrc(PCSrc),
		.ldCV(ldCV),
		.ldZN(ldZN),
		.LT(LT),
		.GT(GT),
		.EQ(EQ),
		.Instruction(Instruction) // Instruction
		);
	Controller CU ( .clk(clk), 
		.rst(rst),
		.LT(LT),
		.GT(GT),
		.EQ(EQ),
		.Inst(Instruction),
		.PCWrite(PCWrite),
		.J(J),
		.IRWrite(IRWrite),
		.RegWrite(RegWrite),
		.ldZN(ldZN),
		.ldCV(ldCV),
		.IorD(IorD),
		.sel(sel),
		.RegDst(RegDst),
		.MemToReg(MemToReg),
		.PCSrc(PCSrc),
		.ALUSrcA(ALUSrcA),
		.ALUSrcB(ALUSrcB),
		.ALUOperation(ALUOperation),
		.MemWrite(MemWrite),
		.MemRead(MemRead)
		);

// initial $monitor("%b %b %b", MemOut, MemAddr, Instruction);

endmodule
		
		
		
