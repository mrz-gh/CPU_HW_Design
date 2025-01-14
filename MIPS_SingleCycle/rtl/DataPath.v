module DataPath (clk, rst, RegDst, sel1, sel2, RegWrite, ALUSrc, ALUop, PCSrc, MemtoReg,
	jmp, zero, InstAddr, DataAddr, WriteMem, Inst, Memout, OPC, FUNC );

	input clk, rst;
	input sel2;
	input RegDst, sel1, ALUSrc, PCSrc, MemtoReg, RegWrite;
	input [2:0] ALUop;
	input [1:0] jmp;
	input [31:0] Inst, Memout;

	output zero;
	output [31:0] InstAddr, DataAddr, WriteMem;
	output [5:0] OPC,FUNC;

	wire [31:0] PCin, PCout, PC4, WriteData, MemReg, ALUB, ExInst, ALUout, ExInstShL, Jump;
	wire [31:0] PCJ, DataRead1, DataRead2;
	wire [4:0] Dst, WriteReg;
	wire [27:0] Inst250ShL;


	assign OPC = Inst[31:26];
	assign FUNC = Inst[5:0];

	//PC
	Reg32bit PC ( .clk(clk),
		.rst(rst),
		.in(PCin),
		.out(PCout)
		);

	//Inst. Mem.
	assign InstAddr = PCout;

	//PC Adder
	Adder32bit PCAdder (.inA(PCout),
			.inB(32'd4),
			.out(PC4)
			);
	
	//MUX RegDst
	mu2to1 muxDst ( .inA(Inst[20:16]),
			.inB(Inst[15:11]),
			.select(RegDst),
			.out(Dst)
			);

	//MUX sel1
	mu2to1  muxSel1 ( .inA(Dst),
			.inB(5'b11111),
			.select(sel1),
			.out(WriteReg)
			);
	
	//MUX sel2
	MUX2to1 muxSel2 ( .inA(PC4),
			.inB(MemReg),
			.select(sel2),
			.out(WriteData)
			);

	//Reg File
	RegFile regfile (.clk(clk),
			.rst(rst),
			.RegWrite(RegWrite),
			.ReadReg1(Inst[25:21]),
			.ReadReg2(Inst[20:16]),
			.WriteReg(WriteReg),
			.DataRead1(DataRead1),
			.DataRead2(DataRead2),
			.WriteData(WriteData)
			);
	//initial $monitor("%d %d %b", ALUout, WriteReg, WriteData);
	//Sign Extend
	SignExtend SiEx ( .in(Inst[15:0]),
			.out(ExInst)
			);

	// MUX ALUSrc 
	MUX2to1 muxALUSrc ( .inA(DataRead2),
			.inB(ExInst),
			.select(ALUSrc),
			.out(ALUB)
			);

	//ALU
	ALU Alu ( .ALUop(ALUop),
		.inA(DataRead1),
		.inB(ALUB),
		.out(ALUout),
		.zero(zero)
		);
	
	//Data Mem
	assign DataAddr = ALUout;
	assign WriteMem = DataRead2;
	// MUX MemtoReg
	MUX2to1 muxMemtoReg ( .inA(ALUout),
			.inB(Memout),
			.select(MemtoReg),
			.out(MemReg)
			);

	//Shift Extended Inst
	ShL2 ExInstSh ( .in(ExInst),
			.out(ExInstShL)
		);

	//Shift Inst 25-0
	assign Inst250ShL = {Inst[25:0], 2'b00};

	//Adder Jump 
	Adder32bit JAdder (.inA(PC4),
			.inB(ExInstShL),
			.out(Jump)
			);
	
	// MUX PC Src
	MUX2to1 muxPCSrc ( .inA(PC4),
			.inB(Jump),
			.select(PCSrc),
			.out(PCJ)
			);

	// MUX jmp
	MUX3to1 muxjmp ( .inA( {PC4[31:28], Inst250ShL}),
			.inB(PCJ),
			.inC(DataRead1),
			.select(jmp),
			.out(PCin)
			); 
	/*initial $monitor("%d %d %b %d %d %d %d %d %d", WriteReg, Inst[20:16], Inst, PCin, PCJ, jmp, PCSrc, PC4, WriteData
			, DataAddr);*/
endmodule
