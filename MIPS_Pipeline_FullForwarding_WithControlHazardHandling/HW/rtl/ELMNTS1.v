module mux3_to_1 #(parameter num_bit)(input [num_bit-1:0]data1,data2,data3, input [1:0]sel,output [num_bit-1:0]out);
	
	assign out=~sel[1] ? (sel[0] ? data2 : data1 ) : data3;	
endmodule

module mux2_to_1 #(parameter num_bit)(input [num_bit-1:0]data1,data2, input sel,output [num_bit-1:0]out);
	
	assign out=~sel?data1:data2;
endmodule

module sign_extension(input [15:0]primary,input signed_imm, output [31:0] extended);

	assign extended=(signed_imm)?$signed(primary):{16'b0,primary};
endmodule

module shl2 #(parameter num_bit)(input [num_bit-1:0]adr, output [num_bit-1:0]sh_adr);

	assign sh_adr=adr<<2;
endmodule

module alu(input [31:0]data1,data2, input [3:0]alu_op,input [4:0]shamt,input signed_imm, output reg[31:0]alu_result, output zero_flag);
	
	always@(alu_op,data1,data2) begin
		alu_result=32'b0;
		case (alu_op)
			4'b0000: 	alu_result=data1 & data2;
			4'b0001:	alu_result=data1 | data2;
			4'b0010:	alu_result=data1 + data2;
			4'b0011:	alu_result=data1 - data2;
			4'b0110: 	alu_result=data1 ^ data2;
			4'b0111: 	alu_result={data2[15:0],16'b0};
			4'b0101:    alu_result=~(data1 | data2);
			4'b1000:	alu_result=data2 << shamt;
			4'b1001:	alu_result=data2 >> shamt;
			4'b1010:	alu_result=$signed(data2) >>> shamt;
			4'b1011:	alu_result=data2 << data1[4:0];
			4'b1100:	alu_result=data2 >> data1[4:0];
			4'b1101:	alu_result=$signed(data2) >>> data1[4:0];

			4'b0100: begin
				alu_result= (data1 - data2);
				alu_result= alu_result[31] ? 32'b1:32'b0;
			end
		endcase
	end
	assign zero_flag=(alu_result==32'b0) ? 1'b1:1'b0;
endmodule

module adder(input clk,input [31:0] data1,data2, output [31:0]sum);
	
	wire co;
	assign {co,sum}=data1+data2;
endmodule


module reg_file(input clk,rst,RegWrite,input [4:0] read_reg1,read_reg2,write_reg,input [31:0]write_data,
		output [31:0]read_data1,read_data2);

	reg [31:0] register[0:31];
	integer i;
	always@(negedge clk, posedge rst) begin
		if(rst) begin
			for(i=0;i<32;i=i+1) register[i]<=32'b0;
		end
		else begin
			if(RegWrite) register[write_reg]<=write_data;
		end
	end
	assign read_data1=register[read_reg1];
	assign read_data2=register[read_reg2];
endmodule

module inst_memory(input clk,rst,input [31:0]adr,output [31:0]instruction);

	reg [31:0]mem_inst[0:255];
	initial begin
		$readmemb("instructionmemory.txt",mem_inst);
  	end
	assign instruction=mem_inst[adr>>2];
endmodule

module data_memory(input clk,rst,mem_read,mem_write,input [31:0]adr,write_data,output reg[31:0]read_data,
		   output [31:0] out1,out2);

	reg [31:0]mem_data[0:511];

	wire [31:0] addr;
	assign addr = adr - 32'h0000_2000;

	integer i,f;
	initial begin
		$readmemb("datamemory.txt",mem_data);
  	end

	always@(posedge clk) begin
		if(mem_write) mem_data[addr>>2]<=write_data;
	end

	always@(mem_read,addr) begin
		if(mem_read) read_data<=mem_data[addr>>2];
		else read_data<=32'b0;	
	end
	
	initial begin
		$writememb("datamemory.txt",mem_data); 
  	end

	initial begin
  		f = $fopen("datamemory.txt","w");
		for(i=0;i<512;i=i+1) begin
		$fwrite(f,"%b\n",mem_data[i]);
		end
		$fclose(f);  
	end

	assign out1=mem_data[500];
	assign out2=mem_data[501];
	
endmodule

module pc(input clk, input rst, input ld_en_i, input [31:0]in,output reg[31:0]out);

	always @(posedge clk, posedge rst) begin
		if(rst) 
			out <= 32'b0;
		else if (ld_en_i)
			out <= in;

	end
endmodule
