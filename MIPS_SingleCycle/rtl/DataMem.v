module DataMem (clk, L, MemRead, MemWrite, Address, WriteData, ReadData, loadMem);

	input clk, L, MemRead, MemWrite;
	input [31:0] Address, WriteData;
	
	output [31:0] ReadData;
	
	integer i;
	input [32*512 - 1:0] loadMem;


	reg [31:0] memory [0:511];



	always @(posedge clk , posedge L)begin
		if (L)begin
			for (i=0; i<511 ; i = i+1)begin
				memory [i] = loadMem[32*i +: 32];
			end
		end
		else if(MemWrite) 
			memory [Address[10:2]] <= WriteData;

	end

	assign ReadData = MemRead ? memory[Address[10:2]] : 32'bz;

	
endmodule
	
