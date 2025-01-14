module InstMem (Address, Instruction, loadMem, L);
	integer i;

	input L;
	input [31:0] Address;
	input [32*32 - 1:0] loadMem;

	output [31:0] Instruction;

	reg [31:0] memory [0:31];


	assign Instruction = memory [Address[6:2]];

	always @(posedge L)begin
		for (i=0 ; i<32 ; i = i+1)begin
			memory [i] <= loadMem [32 * i +: 32];
		end
	end

	/*
initial begin
		$readmemh("", memory, 0, 12);
	end
*/

endmodule

