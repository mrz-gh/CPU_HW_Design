module RegFile (clk, rst, RegWrite, ReadReg1, ReadReg2, WriteReg, DataRead1, DataRead2, WriteData);


	input clk, rst, RegWrite;
	input [3:0] ReadReg1, ReadReg2, WriteReg;
	input [31:0] WriteData;

	output [31:0] DataRead1, DataRead2;


	reg [31:0] arr [0:15];

	integer i;

	always @(posedge clk, posedge rst) 
	begin
		if (rst) begin
			for (i = 0; i < 16; i = i + 1)begin
				arr[i] <= 32'd0;
			end
		end
		else if (RegWrite) 
			arr [WriteReg] <= WriteData;

	end

	assign DataRead1 = arr[ReadReg1];
	assign DataRead2 = arr[ReadReg2];
	
	initial $monitor("%d %d %d %d %d %d %d %d",arr[1], arr[2], arr[3], arr[4], arr[5], WriteData, WriteReg, RegWrite);
endmodule

	
