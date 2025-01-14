module MIPS(clk, rst, MemRead, MemWrite,InstAddr, DataAddr, WriteMem, Inst, Memout,in,opcc,rgw);
input clk , rst;
output  MemRead, MemWrite,rgw;

input [31:0] Inst, Memout;
output [31:0] InstAddr, DataAddr, WriteMem,in;
output  [5:0]opcc;

wire Sel1,RegDst,Sel2,RegWrite,Zero,ALUSrc,MemtoReg,PCSrc;
wire [2:0] ALUOperation;
wire[5:0] FUNC,OPC;
wire [1:0]Jmp;



Controller CC(OPC,FUNC, Sel1,RegDst,Sel2,RegWrite,
			Zero,ALUSrc,ALUOperation,MemRead,MemWrite,MemtoReg,PCSrc,Jmp );

DataPath DP(clk, rst, RegDst, Sel1, Sel2, RegWrite, ALUSrc, ALUOperation, PCSrc, MemtoReg,
	Jmp, Zero,InstAddr, DataAddr, WriteMem, Inst, Memout,OPC,FUNC);

assign in = Inst;
assign opcc = OPC;
assign rgw = RegWrite;

//initial $monitor("%b", ALUOperation);

endmodule

