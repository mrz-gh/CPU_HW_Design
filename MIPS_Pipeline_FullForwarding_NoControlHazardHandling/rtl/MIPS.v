module MIPS (rst, clk, 
	MEM_MemRead, MEM_MemWrite, 
	InstAddr, InstMemOut,
	DataAddr, WriteMem, DataMemOut
	);

	input rst, clk;
	input [31:0] InstMemOut, DataMemOut;
	
	output MEM_MemRead, MEM_MemWrite;
	output [31:0] InstAddr, DataAddr, WriteMem;

	wire PCWrite, IF_IDWrite, ALUSrc, RegDst, sel1, sel2, Jmp, zero, MemToReg, MEM_RegWrite, RegWrite;
	wire MemRead, MemWrite, WBRegWrite, EX_MemRead;
	wire [1:0] PCSrc, ForwardA, ForwardB;
	wire [2:0] ALUOperation;
	wire [4:0] EX_Rs,EX_Rt,MEM_Rd,WB_Rd;
	wire [5:0] EX_OPC;
	wire [31:0] inst; 

	DataPath DP (.rst(rst), .clk(clk),
		.PCSrc(PCSrc), .PCWrite(PCWrite), .IF_IDWrite(IF_IDWrite),
		.InstAddr(InstAddr), .InstMemOut(InstMemOut), .ALUSrc(ALUSrc), 
		.RegDst(RegDst), .ForwardA(ForwardA), .ForwardB(ForwardB),
		.ALUOperation(ALUOperation), .sel1(sel1), .jmp(Jmp),
		.DataAddr(DataAddr), .WriteMem(WriteMem), .DataMemOut(DataMemOut),
		.MemRead(MemRead), .MemWrite(MemWrite), .MMemRead(MEM_MemRead),
		.MMemWrite(MEM_MemWrite), .zero(zero), .Inst(inst), 
		.MemToReg(MemToReg), .RegWrite(RegWrite), .MEM_RegWrite(MEM_RegWrite),
		.sel2(sel2), .EX_OPC(EX_OPC), .WriteReg(WB_Rd), .EMDst(MEM_Rd),
		.WBRegWrite(WB_RegWrite), .EX_MemRead(EX_MemRead), .IERs(EX_Rs), .IERt(EX_Rt)
	);

	Controller CU (.PCSrc(PCSrc), .PCWrite(PCWrite),
		.IF_IDWrite(IF_IDWrite), .ALUSrc(ALUSrc), .RegDst(RegDst),
		.ALUOperation(ALUOperation), .ForwardA(ForwardA), .ForwardB(ForwardB),
		.Sel1(sel1), .Jmp(Jmp), .MemtoReg(MemToReg), 
		.RegWrite(RegWrite), .Sel2(sel2), 
		.MemRead(MemRead), .MemWrite(MemWrite),
		.Z_after_ALU(zero), .inst(inst), .EX_Rs(EX_Rs), .EX_Rt(EX_Rt), 
		.MEM_Rd(MEM_Rd), .WB_Rd(WB_Rd), .MEM_RegWrite(MEM_RegWrite), .WB_RegWrite(WB_RegWrite),
		.EX_MemRead(EX_MemRead), .EX_OPC(EX_OPC)
		);


endmodule