`timescale 1ns/1ns
module TestBench;

reg cclk = 0, rrst = 0, ld = 0;
reg [31:0] ldMemory [0:2047];
reg [32*2048 - 1:0] loadMem;

wire MMemWrite, MMemRead;
wire [31:0] MMemAddr, WWriteMem, MMemOut;

Processor MP ( .clk(cclk),
	.rst(rrst),
	.MemOut(MMemOut),
	.MemWrite(MMemWrite),
	.MemRead(MMemRead),
	.MemAddr(MMemAddr),
	.WriteMem(WWriteMem)
	);

Memory Mem (.clk(cclk),
	.L(ld),
	.MemRead(MMemRead),
	.MemWrite(MMemWrite),
	.Address(MMemAddr),
	.WriteData(WWriteMem),
	.ReadData(MMemOut),
	.loadMem(loadMem)
	);


always #50 cclk = ~cclk;

integer i;
initial begin

	$readmemb("inst.txt", ldMemory,0,13);
	$readmemb("data.txt", ldMemory,1000,1009);
	for (i = 0 ; i < 2048 ; i = i+1)begin
		loadMem [32*i +: 32] = ldMemory[i];
	end
	
	#5 ld = 1'b1;
	#5 ld = 1'b0;
	#45 rrst = 1'b1;
	#100 rrst = 1'b0;

	#32000  $stop;

end

endmodule

