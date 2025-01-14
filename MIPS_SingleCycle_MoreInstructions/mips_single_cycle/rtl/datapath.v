`timescale 1ns/1ns

module data_path(
	clk,
	rst,
	RegDst,
	Jmp,
	DataC,
	RegWrite,
	AluSrc,
	signed_imm,
	Branch,
	MemRead,
	MemWrite,
	MemtoReg,
	AluOperation,
	func,
	opcode,
	out1,
	out2
	);

	input 					clk,rst;
	input       [1:0]		RegDst,Jmp;
	input 					DataC,RegWrite,AluSrc,Branch,MemRead,MemWrite,MemtoReg;
	input					signed_imm;
	input       [3:0]		AluOperation;
	output reg  [5:0] 		func,opcode;
	output wire [31:0] 		out1,out2;

	wire        [31:0] 		in_pc,out_pc,instruction,write_data_reg,read_data1_reg,read_data2_reg,pc_adder,mem_read_data,
							inst_extended,alu_input2,alu_result,read_data_mem,shifted_inst_extended,out_adder2,out_branch;
	wire 		[4:0] 		write_reg;
	wire 		[25:0] 		shl2_inst;
	wire 					and_z_b,zero;
	

	pc PC(.clk(clk),.rst(rst),.in(in_pc),.out(out_pc));

	adder adder_of_pc(.clk(clk),.data1(out_pc),.data2(32'd4),.sum(pc_adder));

	adder adder2(.clk(clk),.data1(shifted_inst_extended),.data2(pc_adder),.sum(out_adder2));

	alu ALU(.data1(read_data1_reg),.data2(alu_input2),.shamt(instruction[10:6]),.signed_imm(signed_imm),.alu_op(AluOperation),.alu_result(alu_result),.zero_flag(zero));

	inst_memory InstMem(.clk(clk),.rst(rst),.adr(out_pc),.instruction(instruction));

	reg_file RegFile(.clk(clk),.rst(rst),.RegWrite(RegWrite),.read_reg1(instruction[25:21]),.read_reg2(instruction[20:16]),
					 .write_reg(write_reg),.write_data(write_data_reg),.read_data1(read_data1_reg),.read_data2(read_data2_reg));

	data_memory data_mem(.clk(clk),.rst(rst),.mem_read(MemRead),.mem_write(MemWrite),.adr(alu_result),
						 .write_data(read_data2_reg),.read_data(read_data_mem),.out1(out1),.out2(out2)); 

	mux3_to_1 #(5) mux3_reg_file(.clk(clk),.data1(instruction[20:16]),.data2(instruction[15:11]),.data3(5'd31),.sel(RegDst),.out(write_reg));

	mux3_to_1 #(32) mux3_jmp(.clk(clk),.data1(out_branch),.data2({pc_adder[31:26],shl2_inst}),.data3(read_data1_reg),.sel(Jmp),.out(in_pc));

	assign and_z_b=(instruction[31:26]==6'b000100 && zero && Branch)||(instruction[31:26]== 6'b000101 && (~zero) && Branch);

	mux2_to_1 #(32) mux2_reg_file(.clk(clk),.data1(mem_read_data),.data2(pc_adder),.sel(DataC),.out(write_data_reg));

	mux2_to_1 #(32) alu_mux(.clk(clk),.data1(read_data2_reg),.data2(inst_extended),.sel(AluSrc),.out(alu_input2));

	mux2_to_1 #(32) mux_of_mem(.clk(clk),.data1(alu_result),.data2(read_data_mem),.sel(MemtoReg),.out(mem_read_data));

	mux2_to_1 #(32) mux2_branch(.clk(clk),.data1(pc_adder),.data2(out_adder2),.sel(and_z_b),.out(out_branch));
	
	sign_extension sign_ext(.primary(instruction[15:0]),.extended(inst_extended),.signed_imm(signed_imm));

	shl2 #(26) shl2_1(.clk(clk),.adr(instruction[25:0]),.sh_adr(shl2_inst));

	shl2 #(32) shl2_of_adder2(.clk(clk),.adr(inst_extended),.sh_adr(shifted_inst_extended));

	assign func=instruction[5:0];

	assign opcode=instruction[31:26];

endmodule
