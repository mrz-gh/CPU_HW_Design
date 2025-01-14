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



module Controller (OPC,FUNC,  Sel1,RegDst,Sel2,RegWrite,
			Zero,ALUSrc,ALUOperation,MemRead,MemWrite,MemtoReg,PCSrc,Jmp ,rgw);

	input Zero;
	input [5:0] OPC,FUNC;
	
		
	output  rgw,Sel1,RegDst,Sel2,RegWrite,ALUSrc,MemRead,MemWrite,MemtoReg,PCSrc;
	output [1:0] Jmp;
	output [2:0]ALUOperation;
	
	reg Sel1,RegDst,Sel2,RegWrite,ALUSrc,MemRead,MemWrite,MemtoReg,PCSrc;
	reg [1:0]Jmp;
	reg [2:0]ALUOperation;

	always @ (Zero,FUNC,OPC)
	
       begin  
     	 case(OPC)   
     	 `ALI: begin // RTI
                Sel1 = 1'b0;
	   	RegDst = 1'b1;
		Sel2 = 1'b1;
		RegWrite = 1'b1;
		ALUSrc  = 1'b0;
		MemRead  = 1'b0;
		MemWrite  = 1'b0;
		MemtoReg = 1'b0;
		PCSrc  = 1'b0;
		Jmp = 2'b01;   
               
		case(FUNC)
			`add : ALUOperation = 3'b000;
			`sub : ALUOperation = 3'b001;	
			`AND : ALUOperation = 3'b010;	
			`OR : ALUOperation = 3'b011;	
			`SLT : ALUOperation = 3'b100;				
		endcase
		end  
         `ADDI: begin // ADDI  
               Sel1 = 1'b0;
	   	RegDst = 1'b0;
		Sel2 = 1'b1;
		RegWrite = 1'b1;
		ALUSrc  = 1'b1;
		ALUOperation  = 3'b000;
		MemRead  = 1'b0;
		MemWrite  = 1'b0;
		MemtoReg = 1'b0;
		PCSrc  = 1'b0;
		Jmp = 2'b01;   
                end  
      `SLTI: begin // SLTI  
               Sel1 = 1'b0;
	   	RegDst = 1'b0;
		Sel2 = 1'b1;
		RegWrite = 1'b1;
		ALUSrc  = 1'b1;
		ALUOperation  = 3'b100;
		MemRead  = 1'b0;
		MemWrite  = 1'b0;
		MemtoReg = 1'b0;
		PCSrc  = 1'b0;
		Jmp = 2'b01;   
                end  
      `LW: begin // LW  
                Sel1 = 1'b0;
	   	RegDst = 1'b0;
		Sel2 = 1'b1;
		RegWrite = 1'b1;
		ALUSrc  = 1'b1;
		ALUOperation  = 3'b000;
		MemRead  = 1'b1;
		MemWrite  = 1'b0;
		MemtoReg = 1'b1;
		PCSrc  = 1'b0;
		Jmp = 2'b01;    
                end  
      `SW: begin // SW 
                Sel1 = 1'b0;
	   	RegDst = 1'b0;
		Sel2 = 1'b0;
		RegWrite = 1'b0;
		ALUSrc  = 1'b1;
		ALUOperation  = 3'b000;
		MemRead  = 1'b0;
		MemWrite  = 1'b1;
		MemtoReg = 1'b0;
		PCSrc  = 1'b0;
		Jmp = 2'b01;  
                end  
      `beq: begin // beq  
               Sel1 = 1'b0;
	   	RegDst = 1'b0;
		Sel2 = 1'b0;
		RegWrite = 1'b0;
		ALUSrc  = 1'b0;
		ALUOperation  = 3'b001;
		MemRead  = 1'b0;
		MemWrite  = 1'b0;
		MemtoReg = 1'b0;
		PCSrc  = (Zero==1'b1)?1'b1:1'b0;
		Jmp = 2'b01;  
                end  
      `j: begin // J 
                Sel1 = 1'b0;
	   	RegDst = 1'b0;
		Sel2 = 1'b0;
		RegWrite = 1'b0;
		ALUSrc  = 1'b0;
		ALUOperation  = 3'b000;
		MemRead  = 1'b0;
		MemWrite  = 1'b0;
		MemtoReg = 1'b0;
		PCSrc  = 1'b0;
		Jmp = 2'b00;  
                end  
      `jr: begin // j r 
                Sel1 = 1'b0;
	   	RegDst = 1'b0;
		Sel2 = 1'b0;
		RegWrite = 1'b0;
		ALUSrc  = 1'b0;
		ALUOperation  = 3'b000;
		MemRead  = 1'b0;
		MemWrite  = 1'b0;
		MemtoReg = 1'b0;
		PCSrc  = 1'b0;
		Jmp = 2'b10;  
                end
	`jal: begin // jal  
                Sel1 = 1'b1;
	   	RegDst = 1'b0;
		Sel2 = 1'b0;
		RegWrite = 1'b1;
		ALUSrc  = 1'b0;
		ALUOperation  = 3'b000;
		MemRead  = 1'b0;
		MemWrite  = 1'b0;
		MemtoReg = 1'b0;
		PCSrc  = 1'b0;
		Jmp = 2'b00;  
                end  
      default: begin  
              Sel1 = 1'b0;
	   	RegDst = 1'b0;
		Sel2 = 1'b0;
		RegWrite = 1'b0;
		ALUSrc  = 1'b0;
		ALUOperation  = 3'b000;
		MemRead  = 1'b0;
		MemWrite  = 1'b0;
		MemtoReg = 1'b0;
		PCSrc  = 1'b0;
		Jmp = 2'b01;  
                end  
      endcase  

end



endmodule
