module unid_control(
    input wire clk,
    input wire reset, 
    input wire [5:0] opcode,
    input wire [5:0] funct,

    output reg pc_write_cond,
    output reg pc_write,
    output reg mem_read,
    output reg mem_write,
    output reg byte_or_word,
    output reg ir_write,
    output reg reg_write,
    output reg ab_from_memory,
    output reg div_mul_wr,
    output reg div_mul_to_reg,

    output reg [1:0] i_or_d,
    output reg [2:0] mem_to_reg,
    output reg [1:0] pc_src,
    output reg [2:0] alu_op,
    output reg [1:0] alu_src_a,
    output reg [1:0] alu_src_b,
    output reg [1:0] reg_dst,
    output reg [1:0] divmul_sh_bankreg,
    output reg [1:0] sh_reg_op

);

    reg [4:0] STATE;
    reg [2:0] COUNTER;

    parameter A_MEM_READ = 5'b00000;
    parameter B_MEM_READ = 5'b00001;
    parameter DIVM = 5'b00010;
    parameter ALU_OP_1 = 5'b00011;
    parameter DESLOC_CALC = 5'b00100;
    parameter WRITE_BACK_1 = 5'b00101;
    parameter ALU_OP_2 = 5'b00110;
    parameter WRITE_BACK_2 = 5'b00111;
    parameter JUMP_REG = 5'b01000;
    parameter DIV_MUL_REG_WRITE = 5'b01001;
    parameter WRITE_BACK_3 = 5'b01010;
    parameter JUMP = 5'b01011;
    parameter JUMP_WRITE = 5'b01100;
    parameter ALU_OP_3 = 5'b01101;
    parameter WRITE_BACK_4 = 5'b01110;
    parameter ALU_OP_4 = 5'b01111;
    parameter END_CALC = 5'b10000;
    parameter MEM_READ = 5'b10001;
    parameter ALU_OP_5 = 5'b10010;
    parameter WRITE_BACK_5 = 5'b10011;
    parameter WRITE_BACK_6 = 5'b10100;
    parameter MEM_WRITE_1 = 5'b10101;
    parameter WRITE_BACK_7 = 5'b10110;
    parameter MEM_READ_END_BACK = 5'b10111;
    parameter MEM_WRITE_2 = 5'b11000;
    parameter READ_INST_PC_INC = 5'b11001;
    parameter BRANCH_END = 5'b11010;

endmodule
