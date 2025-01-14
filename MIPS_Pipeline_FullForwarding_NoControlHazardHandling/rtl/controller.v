`define ALI 6'b000000
`define ADDI 6'b000001
`define SLTI 6'b000010
`define LW 6'b000011
`define SW 6'b000100
`define beq 6'b000101
`define j 6'b000110
`define jr 6'b000111
`define jal 6'b001000

`define add 6'b000001
`define sub 6'b000010
`define AND 6'b000100
`define OR  6'b001000
`define SLT 6'b010000
`define ShR2 6'b100000


module Controller (PCSrc, PCWrite, IF_IDWrite, ALUSrc, RegDst, ALUOperation,
	ForwardA, ForwardB, Sel1, Jmp, 
	 MemtoReg, RegWrite, Sel2, MemRead, MemWrite
	,Z_after_ALU,inst,EX_Rs,EX_Rt,MEM_Rd,WB_Rd,MEM_RegWrite,WB_RegWrite,EX_MemRead,EX_OPC);

	input [31:0]inst;
	input Z_after_ALU,MEM_RegWrite,WB_RegWrite,EX_MemRead;
	input [4:0]EX_Rs,EX_Rt,MEM_Rd,WB_Rd;
	input [5:0]EX_OPC;

	output PCWrite, IF_IDWrite, ALUSrc, RegWrite, RegDst, Sel1, Jmp, MemtoReg, Sel2,
		MemRead, MemWrite;
	output [1:0] ForwardA, ForwardB,PCSrc;
	output [2:0] ALUOperation;

	reg PCWrite, IF_IDWrite, ALUSrc, RegWrite, RegDst, Sel1, Jmp, MemtoReg, Sel2,
		MemRead, MemWrite;
	reg [1:0]PCSrc,ForwardA, ForwardB;
	reg [2:0]ALUOperation;

	reg [5:0] OPC,FUNC;
	
	assign OPC = inst[31:26];
	assign FUNC = inst[5:0];
	
	always @ (Z_after_ALU,FUNC,OPC)
	
       begin  
     	 case(OPC)   
     	 `ALI: begin // RTI
                ALUSrc  = 1'b0;
		RegWrite = 1'b1;
		MemRead  = 1'b0;
		MemWrite  = 1'b0;
		RegDst = 1'b1;
		Sel1 = 1'b0;
                Sel2 = 1'b0;
		MemtoReg = 1'b1;
		PCSrc  = 2'b00;

		case(FUNC)
			`add : ALUOperation = 3'b000;
			`sub : ALUOperation = 3'b001;	
			`AND : ALUOperation = 3'b010;	
			`OR : ALUOperation = 3'b011;	
			`SLT : ALUOperation = 3'b100;
			`ShR2 : ALUOperation = 3'b101;				
		endcase
		end  
         `ADDI: begin // ADDI  
               ALUSrc  = 1'b1;
		RegWrite = 1'b1;
		MemRead  = 1'b0;
		MemWrite  = 1'b0;
		RegDst = 1'b0;
		Sel1 = 1'b0;
                Sel2 = 1'b0;
		MemtoReg = 1'b1;
		PCSrc  = 2'b00;
	   	ALUOperation = 3'b000;

                end  
      `SLTI: begin // SLTI  
                ALUSrc  = 1'b1;
		RegWrite = 1'b1;
		MemRead  = 1'b0;
		MemWrite  = 1'b0;
		RegDst = 1'b0;
		Sel1 = 1'b0;
                Sel2 = 1'b0;
		MemtoReg = 1'b1;
		PCSrc  = 2'b00;
  		ALUOperation = 3'b100;

                end  
      `LW: begin // LW  
                 
		ALUSrc  = 1'b1;
		RegWrite = 1'b1;
		MemRead  = 1'b1;
		MemWrite  = 1'b0;
		RegDst = 1'b0;
		Sel1 = 1'b0;
                Sel2 = 1'b1;
		MemtoReg = 1'b1;
		PCSrc  = 2'b00;
	   	ALUOperation = 3'b000;
  
                end  
      `SW: begin // SW 
             ALUSrc  = 1'b1;
		RegWrite = 1'b0;
		MemRead  = 1'b0;
		MemWrite  = 1'b1;
		RegDst = 1'b0;
		Sel1 = 1'b0;
                Sel2 = 1'b1;
		MemtoReg = 1'b1;
		PCSrc  = 2'b00;
	   	ALUOperation = 3'b000;
 
                end  
      `beq: begin // beq  
              ALUSrc  = 1'b0;//
		RegWrite = 1'b0;//
		MemRead  = 1'b0;//
		MemWrite  = 1'b0;//
		RegDst = 1'b0;//
		Sel1 = 1'b0;//
                Sel2 = 1'b0;//
		MemtoReg = 1'b0;//
		//PCSrc  = (Z_after_ALU==1'b1) ? 2'b01:2'b00;
	   	ALUOperation = 3'b001;//
		Jmp=1'b0;
                end  
      `j: begin // J 
                ALUSrc  = 1'b0;//
		RegWrite = 1'b0;//
		MemRead  = 1'b0;//
		MemWrite  = 1'b0;//
		RegDst = 1'b0;//
		Sel1 = 1'b0;//
                Sel2 = 1'b0;//
		MemtoReg = 1'b0;//
		PCSrc  = 2'b10;
	   	ALUOperation = 3'b000;//
 		Jmp=1'b0;
                end  
      `jr: begin // j r 
                ALUSrc  = 1'b0;//
		RegWrite = 1'b0;//
		MemRead  = 1'b0;//
		MemWrite  = 1'b0;//
		RegDst = 1'b0;//
		Sel1 = 1'b0;//
                Sel2 = 1'b0;//
		MemtoReg = 1'b0;//
		PCSrc  = 2'b01;
	   	ALUOperation = 3'b000;//  
		Jmp=1'b1;

                end
	`jal: begin // jal  
             ALUSrc  = 1'b0;//
		RegWrite = 1'b1;
		MemRead  = 1'b0;//
		MemWrite  = 1'b0;//
		RegDst = 1'b0;//
		Sel1 = 1'b1;
                Sel2 = 1'b0;//
		MemtoReg = 1'b0;
		PCSrc  = 2'b10;
	   	ALUOperation = 3'b000;// 
		Jmp=1'b0;
                end  
      default: begin  
             ALUSrc  = 1'b0;//
		RegWrite = 1'b0;//
		MemRead  = 1'b0;//
		MemWrite  = 1'b0;//
		RegDst = 1'b0;//
		Sel1 = 1'b0;//
                Sel2 = 1'b0;//
		MemtoReg = 1'b0;//
		PCSrc  = 2'b00;
	   	ALUOperation = 3'b000;// 
                end  
      endcase  

end


///////////////////////Forwarding Unit///////////////////////

always @ (EX_Rs,EX_Rt,MEM_Rd,WB_Rd,MEM_RegWrite,WB_RegWrite)
begin  
     	  if((MEM_RegWrite==1'b1)&(MEM_Rd==EX_Rs)&(MEM_Rd!=5'b0))
			ForwardA=2'b01;

	 else if((WB_RegWrite==1'b1)&(WB_Rd==EX_Rs)&(WB_Rd!=5'b0)&(((MEM_RegWrite==1'b1)&(MEM_Rd==EX_Rs)&(MEM_Rd!=5'b0))!=1))
			ForwardA=2'b10;
	else 
		ForwardA=2'b00;
	 if((MEM_RegWrite==1'b1)&(MEM_Rd==EX_Rt)&(MEM_Rd!=5'b0))
			ForwardB=2'b01;
	  else if((WB_RegWrite==1'b1)&(WB_Rd==EX_Rt)&(WB_Rd!=5'b0)&(((MEM_RegWrite==1'b1)&(MEM_Rd==EX_Rt)&(MEM_Rd!=5'b0))!=1))
			ForwardB=2'b10;

	else 
		ForwardB=2'b00;
end


///////////////////////Hazard Unit///////////////////////
reg[4:0] ID_Rs,ID_Rt;
assign ID_Rs=inst[25:21];
assign ID_Rt=inst[20:16];

always @ (EX_OPC,EX_Rt,EX_MemRead, OPC, ID_Rs, ID_Rt)
begin  
     	  if((EX_MemRead==1'b1)&(ID_Rs==EX_Rt)&(ID_Rs!=5'b0))begin
		
		RegWrite = 1'b0;
		MemRead  = 1'b0;
		MemWrite  = 1'b0;
		PCSrc  = 2'b00;
		PCWrite=1'b0;
		IF_IDWrite=1'b0;
		end
	else if((EX_MemRead==1'b1)&(ID_Rt==EX_Rt)&(ID_Rt!=5'b0))begin
		
		RegWrite = 1'b0;
		MemRead  = 1'b0;
		MemWrite  = 1'b0;
		PCSrc  = 2'b00;
		PCWrite=1'b0;
		IF_IDWrite=1'b0;
		end	
	else if((OPC==`beq)&(EX_OPC!=`beq))begin
		
		RegWrite = 1'b0;
		MemRead  = 1'b0;
		MemWrite  = 1'b0;
		PCSrc = 2'b00;
		PCWrite=1'b0;
		IF_IDWrite=1'b0;
		end
	else if ((OPC==`beq)&(EX_OPC==`beq)) begin
		PCSrc  = (Z_after_ALU==1'b1) ? 2'b01:2'b00;
		PCWrite = 1'b1;
		IF_IDWrite = 1'b1;
	end
	else begin
	//PCSrc = 2'b00;
	PCWrite=1'b1;
	IF_IDWrite=1'b1;
		
	end
end
//initial $monitor("%b %b %b", OPC, FUNC, inst);
endmodule
