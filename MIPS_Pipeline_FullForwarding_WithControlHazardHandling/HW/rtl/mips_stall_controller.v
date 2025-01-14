
`define EX_forward      01
`define MEM_forward   10  

module mips_stall_controller (
    input wire [4:0] rs_i,
    input wire [4:0] rt_i,

    input wire MemRead_EX_i,
    input wire MemRead_MEM_i,

    input wire [4:0] write_reg_EX_i,
    input wire [4:0] write_reg_MEM_i,
    input wire RegWrite_EX_i,
    input wire RegWrite_MEM_i,

    output reg stall_o,
    output reg [1:0] Asrc_o,
    output reg [1:0] Bsrc_o
);

    always @(*) begin
        stall_o = 0;

        if (write_reg_EX_i != 0)
            if (MemRead_EX_i & 
                ((write_reg_EX_i == rs_i) | (write_reg_EX_i == rt_i))) // TODO
                stall_o = 1'b1;
    end

    always @(*) begin
        Asrc_o = 0;
        Bsrc_o = 0;

        if ( (write_reg_EX_i != 0) & (write_reg_EX_i == rs_i) & RegWrite_EX_i)
            Asrc_o = `EX_forward;
        else if ( (write_reg_MEM_i != 0) & (write_reg_MEM_i == rs_i) & RegWrite_MEM_i)
            Asrc_o = `MEM_forward;


        if ((write_reg_EX_i != 0) & (write_reg_EX_i == rt_i) & RegWrite_EX_i)
            Bsrc_o = `EX_forward;
        else if ((write_reg_MEM_i != 0) & (write_reg_MEM_i == rt_i) & RegWrite_MEM_i)
            Bsrc_o = `MEM_forward;
    
        

    end


    
endmodule