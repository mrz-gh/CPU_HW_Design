/* Controller (PCSrc, PCWrite, IF_IDWrite, InstAddr, InstMemOut, ALUSrc, RegDst, ALUOperation,
	ForwardA, ForwardB, EMZ, sel1, Jmp, WriteMem, 
	 MemToReg, RegWrite, sel2, MemRead, MemWrite
	,EQ_after_RF,inst,EX_Rs,EX_Rt,MEM_Rd,WB_Rd,MEM_RegWrite,WB_RegWrite,EX_MemRead,EX_OPC);
*/

module DataPath (rst, clk, 
	PCSrc, PCWrite, IF_IDWrite, InstAddr, InstMemOut, ALUSrc, RegDst, ALUOperation,
	ForwardA, ForwardB, sel1, jmp, DataAddr, WriteMem, DataMemOut,
	MMemRead, MMemWrite, MemToReg, RegWrite, sel2, MemRead, MemWrite,
	EX_OPC, zero, Inst, WriteReg, EMDst, WBRegWrite, EX_MemRead, IERs, IERt, MEM_RegWrite
	);
	
	input rst, clk;
	input PCWrite, IF_IDWrite, ALUSrc, RegWrite, RegDst, sel1, jmp, MemToReg, sel2;
	input MemRead, MemWrite;
	input [31:0] InstMemOut, DataMemOut;
	input [1:0] ForwardA, ForwardB, PCSrc;
	input [2:0] ALUOperation;

	output [31:0] InstAddr, DataAddr, WriteMem;
	output zero, MMemRead, MMemWrite;
	output [5:0] EX_OPC;
	output [31:0] Inst;
	output [4:0] IERs, IERt, WriteReg, EMDst;
	output WBRegWrite, MEM_RegWrite, EX_MemRead;

	
	

	// WB Control Signals
	wire [2:0] WB, IE_WB, EM_WB, MW_WB;
	wire WBMemToReg, WBsel2;
	assign WB = {RegWrite, MemToReg, sel2};
	assign {WBRegWrite, WBMemToReg, WBsel2} = MW_WB;
	assign MEM_RegWrite = EM_WB[2];
	// Mem Control Signals
	wire [1:0] M, IE_M, EM_M;
	assign M = {MemRead, MemWrite};
	assign {MMemRead, MMemWrite} = EM_M;
	assign EX_MemRead = IE_M[1];
	// EX Control Signals
	wire [6:0] EX, IE_EX;
	wire EXjmp, EXRegDst, EXsel1, EXALUSrc;
	wire [2:0] EXALUOperation;
	assign EX = {jmp, RegDst, sel1, ALUSrc, ALUOperation};
	assign {EXjmp, EXRegDst, EXsel1, EXALUSrc, EXALUOperation} = IE_EX;
	
	wire [5:0] OPC;
	assign OPC = Inst[31:26];

	wire [31:0] PCin, PCout;
	wire [31:0] PC4, IIPC4, IEPC4, EMPC4, MWPC4;
	wire [31:0] JrBeqAddr;
	wire [4:0] Rs, Rt, Rd, IERd;
	wire [31:0] DataRead1, DataRead2,IEDataRead1, IEDataRead2, WriteData, WriteData0;
	wire [31:0] ExInst, IEExInst, IEExInstShL;
	wire [4:0]  Dst0, Dst;
	wire [31:0] SrcA, SrcB0, EMSrcB0, SrcB;
	wire [31:0] ALUout,EMALUout, MWALUout;
	wire [31:0] BeqAddr;
	wire [31:0] MWDataMemOut;
	wire [27:0] Inst250ShL;
	
//initial $monitor("%b ", Inst);

	/////////////////////////////////////////IF//////////////////////////////
	// MUX PCSrc 
	MUX3to1 muxPCSrc (.inA(PC4),
		.inB(JrBeqAddr),
		.inC({PC4[31:28], Inst250ShL}),
		.select(PCSrc),
		.out(PCin)
		);
	// PC + 4
	Adder32bit PCAdder (.inA(32'd4),
			.inB(PCout),
			.out(PC4)
			);

	// PC
	Reg32bitW PC (.rst(rst), 
		.clk(clk),
		.write(PCWrite), 
		.in(PCin), 
		.out(PCout)
		);
	assign InstAddr = PCout;
	//////////////////////////////////////////////////////////////////////////
	// IF_ID Reg
	IF_IDreg IFIDREG (.rst(rst),
		.clk(clk),
		.write(IF_IDWrite),
		.in({PC4, InstMemOut}),
		.out({IIPC4, Inst})
		);

	////////////////////////////////////ID////////////////////////////////////
	// Rs, Rt, Rd
	assign Rs = Inst[25:21];
	assign Rt = Inst[20:16];
	assign Rd = Inst[15:11];

	// RegFile 
	RegFile RF (.clk(clk),
		.rst(rst),
		.RegWrite(WBRegWrite),
		.ReadReg1(Rs),
		.ReadReg2(Rt),
		.WriteReg(WriteReg),
		.WriteData(WriteData),
		.DataRead1(DataRead1),
		.DataRead2(DataRead2)
		);

	// Sign Extend
	assign ExInst = {{16{Inst[15]}}, Inst[15:0]};
	assign Inst250ShL ={Inst[25:0],2'b00};
	//////////////////////////////////////////////////////////////////////////
	// ID_EX Reg
	ID_EXreg IDEXREG (.rst(rst),
		.clk(clk),
		.in({WB, M, EX, OPC, IIPC4, DataRead1, DataRead2, ExInst, Rt, Rd, Rs}),
		.out({IE_WB, IE_M, IE_EX, EX_OPC, IEPC4, IEDataRead1, IEDataRead2, IEExInst, IERt, IERd, IERs})
		);

	
	//////////////////////////////////////EX////////////////////////////////////
	//MUX ForwardA
	MUX3to1 muxForwardA (.inA(IEDataRead1),
			.inB(EMALUout),
			.inC(WriteData),
			.select(ForwardA),
			.out(SrcA)
			);

	// MUX ForwardB
	MUX3to1 muxForwardB (.inA(IEDataRead2),
			.inB(EMALUout),
			.inC(WriteData),
			.select(ForwardB),
			.out(SrcB0)
			);
	// MUX ALUSrc
	MUX2to1 muxALUSrc (.inA(SrcB0),
			.inB(IEExInst),
			.select(EXALUSrc),
			.out(SrcB)
			);


	// ALU
	ALU alu (.ALUop(EXALUOperation),
		.inA(SrcA),
		.inB(SrcB),
		.zero(zero),
		.out(ALUout)
		);


	// MUX IERegDst
	mu2to1 muxIERegDst (.inA(IERt),
			.inB(IERd),
			.select(EXRegDst),
			.out(Dst0)
			);
			

	// MUX IEsel1
	mu2to1 muxIEsel1 (.inA(Dst0),
			.inB(5'b11111),
			.select(EXsel1),
			.out(Dst)
			);

	// Shift left IEExInst
	ShL2 shlIEExInst (.in(IEExInst),
			.out(IEExInstShL)
			);

	// BeqAdder Adder
	Adder32bit BeqAdder (.inA(IEPC4),
			.inB(IEExInstShL),
			.out(BeqAddr)
			);

	// MUX jmp
	MUX2to1 muxjmp (.inA(BeqAddr),
			.inB(SrcA),
			.select(EXjmp),
			.out(JrBeqAddr)
			);

	//////////////////////////////////////////////////////////////////////////////
	// EX_MEMreg
	EX_MEMreg EXMEMREG (.rst(rst),
			.clk(clk),
			.in({IE_WB, IE_M, IEPC4, ALUout, SrcB0, Dst}),
			.out({EM_WB, EM_M, EMPC4, EMALUout, EMSrcB0, EMDst})
			);

	////////////////////////////////////MEM///////////////////////////////////////
	//Data Address
	assign DataAddr = EMALUout;
	
	//Write Data Memory
	assign WriteMem = EMSrcB0;

	

	/////////////////////////////////////////////////////////////////////////////
	// MEM_WBreg
	MEM_WBreg MEMWBREG (.rst(rst),
			.clk(clk),
			.in({EM_WB, EMPC4, DataMemOut, EMALUout, EMDst}),
			.out({MW_WB, MWPC4, MWDataMemOut, MWALUout, WriteReg})
			);

	////////////////////////////////////WB//////////////////////////////////////

	// MUX MWsel2
	MUX2to1 muxMWsel2 (.inA(MWALUout), 
			.inB(MWDataMemOut),
			.select(WBsel2),
			.out(WriteData0)
			);
	// MUX MWMemToReg
	MUX2to1 muxMemToReg (.inA(MWPC4),
			.inB(WriteData0),
			.select(WBMemToReg),
			.out(WriteData)
			);



endmodule