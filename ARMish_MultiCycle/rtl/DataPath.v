module DataPath (rst, clk, PCWrite, J, IorD, MemAddr, WriteMem, MemOut, sel, RegDst, IRWrite, 
	MemToReg, RegWrite, ALUSrcA, ALUSrcB, ALUop, PCSrc, ldCV, ldZN, LT, GT, EQ, Instruction);

	input rst, clk;
	input PCWrite, J, IorD, sel, RegDst, IRWrite, RegWrite, PCSrc, ldCV, ldZN;
	input [1:0] MemToReg, ALUSrcA, ALUSrcB;
	input [31:0] MemOut;
	input [2:0] ALUop;	

	output LT, GT, EQ;
	output [31:0] MemAddr, WriteMem;
	output [31:0] Instruction;

	wire [31:0] PCin, PCout, ALUout, Inst, MDRout, WriteData, DataRead1, DataRead2, A, B, ExInst25to0;
	wire [31:0] ExInst11to0, SrcA, SrcB, ALUo;
	wire C, V, Z, N,CC, VV, ZZ, NN;
	wire [3:0] ReadReg1, Dst;


	assign Instruction = Inst;
	assign WriteMem = A;

	// PC 
	Reg32bitW PC ( .clk(clk),
		.rst(rst),
		.write(PCWrite | J),
		.in(PCin),
		.out(PCout)
		);
	
	// MUX IorD
	MUX2to1 muxIorD ( .inA(PCout),
			.inB(ALUout),
			.select(IorD),
			.out(MemAddr)
			);

	// IR
	Reg32bitW IR ( .clk(clk),
		.rst(rst),
		.write(IRWrite),
		.in(MemOut),
		.out(Inst)
		);

	// MDR
	Reg32bit MDR ( .clk(clk),
		.rst(rst),
		.in(MemOut),
		.out(MDRout)
		);

	// MUX sel
	mu2to1 mu_sel ( .inA(Inst[19:16]),
		.inB(Inst[15:12]),
		.select(sel),
		.out(ReadReg1)
		);
	//MUX RegDst
	mu2to1 mu_Dst ( .inA(4'b1111),
		.inB(Inst[15:12]),
		.select(RegDst),
		.out(Dst)
		);
	
	// MUX MemToReg
	MUX3to1 mux_MemToReg ( .inA(PCout),
			.inB(ALUout),
			.inC(MDRout),
			.select(MemToReg),
			.out(WriteData)
		);
	// RegFile
	RegFile RF ( .clk(clk), 
		.rst(rst),
		.RegWrite(RegWrite),
		.ReadReg1(ReadReg1),
		.ReadReg2(Inst[3:0]),
		.WriteReg(Dst),
		.WriteData(WriteData),
		.DataRead1(DataRead1),
		.DataRead2(DataRead2)
		);
	// Reg A
	Reg32bit A_Reg ( .clk(clk),
		.rst(rst),
		.in(DataRead1),
		.out(A)
		);

	// Reg B
	Reg32bit B_Reg (.clk(clk),
		.rst(rst),
		.in(DataRead2),
		.out(B)
		);

	// Sign Extend Inst[25:0] 
	assign ExInst25to0 = {{6{Inst[25]}}, Inst[25:0]};
	
	// Sign Extend Inst[11:0]
	assign ExInst11to0 = {{20{Inst[11]}}, Inst[11:0]};

	// MUX ALUSrcA
	MUX3to1 mux_SrcA (.inA(PCout),
		.inB(ExInst25to0),
		.inC(A),
		.select(ALUSrcA),
		.out(SrcA)
	);

	// MUX ALUSrcB
	MUX4to1 mux_SrcB (.inA(B),
			.inB(32'd1),
			.inC(ExInst11to0),
			.inD(ALUout),
			.select(ALUSrcB),
			.out(SrcB)
			);

	// ALU 
	ALU alu (.ALUFunc(ALUop),
		.inA(SrcA),
		.inB(SrcB),
		.out(ALUo),
		.C(C),
		.V(V),
		.Z(Z),
		.N(N)
		);
	
	// ALUOut Reg
	Reg32bit ALUOU (.clk(clk),
		.rst(rst),
		.in(ALUo),
		.out(ALUout)
		);

	// MUX PCSrc
	MUX2to1 mux_PCsrc (.inA(ALUo),
			.inB(ALUout),
			.select(PCSrc),
			.out(PCin)
			);

	//Flip Flop C
	FlipFlop CF (.clk(clk),
		.rst(rst), 
		.ld(ldCV),
		.in(C),
		.out(CC)
		);

	//Flip Flop V
	FlipFlop VF (.clk(clk),
		.rst(rst), 
		.ld(ldCV),
		.in(V),
		.out(VV)
		);

	//Flip Flop Z
	FlipFlop ZF (.clk(clk),
		.rst(rst), 
		.ld(ldZN),
		.in(Z),
		.out(ZZ)
		);

	//Flip Flop N
	FlipFlop NF (.clk(clk),
		.rst(rst), 
		.ld(ldZN),
		.in(N),
		.out(NN)
		);

	assign LT = NN ^ VV;
	assign GT = (~ZZ & NN & VV) | (~ZZ & ~NN & ~VV);
	assign EQ = ZZ;

endmodule




	
