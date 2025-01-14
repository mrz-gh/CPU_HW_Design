`timescale 1ns/1ns

module mips(
	input wire clk,
	input wire rst,
	output wire [31:0] out1,
	output wire [31:0] out2
	);


	wire MemRead_ID_ctrl, MemRead_ID, MemRead_EX , MemRead_MEM; 
	wire MemWrite_ID_ctrl, MemWrite_ID, MemWrite_EX , MemWrite_MEM;
	wire RegWrite_ID_ctrl, RegWrite_ID, RegWrite_EX, RegWrite_MEM, RegWrite_WB;

	wire [31:0] write_data_reg_MEM, write_data_reg_WB;
	wire [31:0] alu_result_EX, alu_result_MEM;
	wire [31:0] instruction_instmem, instruction_IF, instruction_ID,instruction_EX;
	wire [4:0] 	write_reg_EX, write_reg_MEM, write_reg_WB;
	wire [31:0] read_data1_reg_ID, read_data1_EX, read_data1_ID;
	wire [31:0] read_data_rt_ID, read_data2_ID, read_data2_EX; // Data2 in ID stage
	wire [31:0] read_data2_reg_ID, read_data2_reg_EX, read_data2_reg_MEM;
	wire [31:0] imm_extended_ID, imm_extended_EX;
	wire imm_en;
	wire [4:0] write_reg;
	wire [31:0] write_data;
	wire DataC_ID_ctrl, DataC_ID, DataC_EX, DataC_MEM, DataC_WB;
	wire signed_imm_ID,signed_imm_EX;
	wire write_reg_sel_ID, write_reg_sel_EX;
	wire [31:0] read_data_mem;

	wire [3:0] AluOperation_ID, AluOperation_EX;

	wire [31:0] in_pc, pc_IF, pc_ID;
	wire [31:0] pc4_IF, pc4_ID, pc4_EX, pc4_MEM, pc4_WB;
	wire [4:0] rd_ID, rd_EX, rt_ID, rt_EX, rs_ID;

	wire [1:0] PCSrc_ID_ctrl, PCSrc_ID;
	wire Branch_ID_ctrl, Branch_ID, Branch_EX;

	wire zero_EX;

	wire stall;
	wire [1:0] Asrc, Bsrc;

	wire flush_branch, flush_jmp;

	assign flush_branch = (instruction_EX[31:26]==6'b000100 && zero_EX && Branch_EX) | 
				(instruction_EX[31:26]== 6'b000101 && (~zero_EX) && Branch_EX) ;


	assign flush_jmp = (PCSrc_ID == 2'b01) | (PCSrc_ID == 2'b10);

	mips_stall_controller stall_controller(
		.rs_i(rs_ID),
		.rt_i(rt_ID),

		.MemRead_EX_i(MemRead_EX),
		.MemRead_MEM_i(MemRead_MEM),

		.write_reg_EX_i(write_reg_EX),
		.write_reg_MEM_i(write_reg_MEM),
		.RegWrite_EX_i(RegWrite_EX),
		.RegWrite_MEM_i(RegWrite_MEM),

		.stall_o(stall),
		.Asrc_o(Asrc),
		.Bsrc_o(Bsrc)

	);



	///////////// IF Stage /////////////////////////////
	pc PC(.clk(clk),.rst(rst),.ld_en_i(~stall), .in(in_pc),.out(pc_IF));

	adder adder_of_pc(.clk(clk),.data1(pc_IF),.data2(32'd4),.sum(pc4_IF));
	
	inst_memory InstMem(.clk(clk),.rst(rst),.adr(pc_IF),.instruction(instruction_IF));

	assign in_pc = (instruction_EX[31:26]==6'b000100 && zero_EX && Branch_EX) ?  (pc_ID + (imm_extended_EX << 2)) : //beg
				(instruction_EX[31:26]== 6'b000101 && (~zero_EX) && Branch_EX) ?  (pc_ID + (imm_extended_EX << 2)) : //bne
				(PCSrc_ID == 2'b00) ?  pc4_IF:
				(PCSrc_ID == 2'b01) ?  {pc_IF[31:28], instruction_ID[25:0] ,2'b00} :
				(PCSrc_ID == 2'b10) ?  read_data1_ID : 32'd0; 
																// assume pc_ID = pc of EX inst + 4 ???

	
	///////////// ID Stage /////////////////////////////
	assign rs_ID = instruction_ID[25:21];
	assign rt_ID = instruction_ID[20:16];
	assign rd_ID = instruction_ID[15:11];
	
	register #(96) IF_ID_preg(
		.clk_i (clk),
		.rst_ni(~rst),
		.clear_i(flush_branch | flush_jmp),
		.ld_i(~stall),
		.reg_di({pc_IF, pc4_IF, instruction_IF}),
		.reg_qo({pc_ID, pc4_ID, instruction_ID})
	);
	controller CU(
		.opcode(instruction_ID[31:26]),
		.func(instruction_ID[5:0]),
		.RegDst(write_reg_sel_ID),
		.PCSrc_o(PCSrc_ID_ctrl),

		// Control signals
		.DataC(DataC_ID_ctrl),
		.RegWrite(RegWrite_ID_ctrl),
		.Branch(Branch_ID_ctrl),
		.MemRead(MemRead_ID_ctrl),
		.MemWrite(MemWrite_ID_ctrl),
	
		.AluOperation(AluOperation_ID),
		.imm_en_o(imm_en),
		.signed_imm(signed_imm_ID)
		);


	assign {RegWrite_ID, Branch_ID, MemRead_ID, MemWrite_ID, DataC_ID, PCSrc_ID} = stall | flush_branch ? 0 :
					 {RegWrite_ID_ctrl, Branch_ID_ctrl, MemRead_ID_ctrl, MemWrite_ID_ctrl, DataC_ID_ctrl, PCSrc_ID_ctrl};

	reg_file RegFile(.clk(clk), .rst(rst), .RegWrite(RegWrite_WB),.read_reg1(rs_ID),
					.read_reg2(rt_ID), .write_reg(write_reg),.write_data(write_data),
					.read_data1(read_data1_reg_ID),.read_data2(read_data2_reg_ID));

	sign_extension sign_ext(.primary(instruction_ID[15:0]),.signed_imm(signed_imm_ID),.extended(imm_extended_ID));
	// Forwarding MUXs
	assign read_data1_ID = Asrc == 2'b00 ? read_data1_reg_ID :
						Asrc == 2'b01 ? 	alu_result_EX	:
						Asrc == 2'b10 ? 	write_data_reg_MEM : 32'b0;

	assign read_data_rt_ID = Bsrc == 2'b00 ? read_data2_reg_ID :
						Bsrc == 2'b01 ? 	alu_result_EX	:
						Bsrc == 2'b10 ? 	write_data_reg_MEM : 32'b0;


	mux2_to_1 #(32) read_data2_mux (.data1(read_data_rt_ID),.data2(imm_extended_ID),.sel(imm_en),.out(read_data2_ID));



	mux2_to_1 #(5) writereg_mux (.data1(write_reg_WB),.data2(5'd31),.sel(DataC_WB),.out(write_reg));
	mux2_to_1 #(32) writedata_mux (.data1(write_data_reg_WB),.data2(pc4_WB),.sel(DataC_WB),.out(write_data));
	///////////// EX Stage /////////////////////////////
	register #(213) ID_EX_preg(
		.clk_i (clk),
		.rst_ni(~rst),
		.clear_i(1'b0),
		.ld_i(1'b1),
		.reg_di({pc4_ID, instruction_ID, Branch_ID, imm_extended_ID, write_reg_sel_ID, MemWrite_ID, MemRead_ID, 
				AluOperation_ID, RegWrite_ID, rd_ID, rt_ID, read_data1_ID, read_data2_ID, read_data2_reg_ID,signed_imm_ID
				,DataC_ID}),
		.reg_qo({pc4_EX,instruction_EX,Branch_EX, imm_extended_EX, write_reg_sel_EX, MemWrite_EX, MemRead_EX, 
				AluOperation_EX, RegWrite_EX, rd_EX, rt_EX, read_data1_EX, read_data2_EX, read_data2_reg_EX,signed_imm_EX
				,DataC_EX})
	);

	alu ALU(
		.data1(read_data1_EX),
		.data2(read_data2_EX),
		.alu_op(AluOperation_EX),
		.alu_result(alu_result_EX),
		.zero_flag(zero_EX),
		.shamt(instruction_EX[10:6]),
		.signed_imm(signed_imm_EX)
		);

	mux2_to_1 #(5) write_reg_mux (.data1(rd_EX),.data2(rt_EX),.sel(write_reg_sel_EX),.out(write_reg_EX));


	
	///////////// MEM Stage /////////////////////////////
	register #(105) EX_MEM_preg(
		.clk_i (clk),
		.rst_ni(~rst),
		.clear_i(1'b0),
		.ld_i(1'b1),
		.reg_di({pc4_EX, MemWrite_EX, MemRead_EX, RegWrite_EX, write_reg_EX,
				 read_data2_reg_EX, alu_result_EX, DataC_EX}),
		.reg_qo({pc4_MEM,MemWrite_MEM, MemRead_MEM, RegWrite_MEM, write_reg_MEM,
				 read_data2_reg_MEM, alu_result_MEM,DataC_MEM})
	);
	
	data_memory data_mem(.clk(clk),.rst(rst),.mem_read(MemRead_MEM),.mem_write(MemWrite_MEM),.adr(alu_result_MEM),
						 .write_data(read_data2_reg_MEM),.read_data(read_data_mem),.out1(out1),.out2(out2)); 

	mux2_to_1 #(32) write_data_reg_mux (.data1(alu_result_MEM),.data2(read_data_mem),
			.sel(MemRead_MEM),.out(write_data_reg_MEM)
			);

	
	///////////// WB Stage /////////////////////////////
	register #(71) MEM_WB_preg(
		.clk_i (clk),
		.rst_ni(~rst),
		.clear_i(1'b0),
		.ld_i(1'b1),
		.reg_di({pc4_MEM,RegWrite_MEM, write_reg_MEM, write_data_reg_MEM,DataC_MEM}),
		.reg_qo({pc4_WB,RegWrite_WB, write_reg_WB, write_data_reg_WB,DataC_WB})
	);


endmodule
