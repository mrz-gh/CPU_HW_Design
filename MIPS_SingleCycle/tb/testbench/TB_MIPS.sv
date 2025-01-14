`timescale 1ns/1ns
module TB_MIPS;


reg cclk = 0, rrst = 0, LD = 0, LI = 0;
reg [31:0] loadInstMem [0:15];
reg [31:0] loadDataMem [0:511];
reg [32*16 - 1 :0] loadInsts;
reg [32*512 - 1:0] loadDatas;

wire  MMemRead, MMemWrite,rgww;

wire [31:0] IInst, MMemout;
wire [31:0] IInstAddr, DDataAddr, WWriteMem,inn;
wire [5:0]oppcc;

MIPS p(cclk, rrst, MMemRead, MMemWrite,IInstAddr, DDataAddr, WWriteMem, IInst, MMemout,inn,oppcc,rgww);
InstMem IM(IInstAddr, IInst, loadInsts, LI);
DataMem DM(cclk, LD, MMemRead, MMemWrite, DDataAddr, WWriteMem, MMemout, loadDatas);

always #50 cclk = ~cclk;
integer i;
initial begin
	
	
	$readmemb("INST.txt", loadInstMem);
	for (i = 0; i<16 ; i = i+1)begin
		loadInsts[32*i +: 32] = loadInstMem [i];
	end
	$readmemb("DM.txt", loadDataMem, 250, 269);
	for (i = 0; i<512 ; i = i+1)begin
		loadDatas[32*i +: 32] = loadDataMem [i];
	end
	$display("%b", loadDatas[32*250 +: 32]);
	#5 LI = 1'b1;
	#5 LD = 1'b1;
	
	#5 {LI, LD} = 2'b00;
	#45 rrst=1;
	#100 rrst=0;
	
	#18500 $stop;
end

endmodule
		