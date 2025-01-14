module Memory (clk, L, MemRead, MemWrite, Address, WriteData, ReadData, loadMem);

	input clk, L, MemRead, MemWrite;
	input [31:0] Address, WriteData;
	
	output [31:0] ReadData;
	
	
	input [32*2048 - 1:0] loadMem;


	reg [31:0] memory [0:2047];


	integer i;
	always @(posedge clk , posedge L)begin
		if (L)begin
			for (i=0; i<2048 ; i = i+1)begin
				memory [i] = loadMem[32*i +: 32];
			end
		end
		else if(MemWrite) 
			memory [Address[11:0]] <= WriteData;

	end

	assign ReadData = MemRead ? memory[Address[11:0]] : 32'bz;

	
endmodule
	
