module cpu_tot(
    input wire clk,
    input wire reset
);

wire one;
assign one = 1'b1;

wire pc_w;
wire [31:0] pc_in;
wire [31:0] pc_out;

wire [31:0] mem_addr;
wire [31:0] write_data_mem;
wire [31:0] mem_data;

wire [31:0] ir_write;
wire [31:0] opcode;
wire [31:0] RS;
wire [31:0] RT;
wire [31:0] inst15_0;

wire reg_write;
wire [4:0] write_reg;
wire [31:0] write_data_reg;
wire [31:0] out_rs;
wire [31:0] out_rt;

wire [31:0] op1ULA;
wire [31:0] op2ULA;
wire [2:0] alu_op;
wire [31:0] alu_result;
wire ov;
wire negt;
wire zero;
wire eq;
wire maior;
wire slt_signal;

wire [4:0] shamt;
assign shamt = inst15_0[10:6];
wire [2:0] sh_op;
wire [31:0] out_regDesloc;

wire [31:0] out_MDR;
wire [31:0] out_A_from_mem;
wire [31:0] A_out;
wire [31:0] B_out;
wire [31:0] aluout_out;

wire div_mul_wr;
wire [31:0] div_mul_in;
wire [31:0] div_mul_out;

Registrador PC(
    clk,
    reset,
    pc_w,
    pc_in,
    pc_out
);

Memoria MEM(
    mem_addr,
    clk,
    mem_write,
    write_data_mem,
    mem_data
);

Instr_Reg IR(
    clk, 
    reset,
    ir_write,
    mem_data,
    opcode,
    RS,
    RT,
    inst15_0
);

Banco_reg regs(
    clk,
    reset,
    reg_write,
    RS,
    RT,
    write_reg,
    write_data_reg,
    out_rs,
    out_rt
);

ula32 ULA(
    op1ULA,
    op2ULA,
    alu_op,
    alu_result,
    ov,
    negt,
    zero,
    eq,
    maior,
    slt_signal
);

RegDesloc regDesloc(
    clk,
    reset,
    sh_op,
    shamt,
    out_rt,
    out_regDesloc
);

Registrador MDR(
    clk,
    reset,
    one,
    mem_data,
    out_MDR
);

Registrador A_from_memory(
    clk,
    reset,
    one,
    mem_data,
    out_A_from_mem
);

Registrador regA(
    clk,
    reset,
    one,
    out_rs,
    A_out
);

Registrador regB(
    clk,
    reset,
    one,
    out_rs,
    B_out
);

Registrador ALUOut(
    clk,
    reset,
    one,
    alu_result,
    aluout_out
);

Registrador divMul_reg(
    clk,
    reset,
    div_mul_wr,
    div_mul_in,
    div_mul_out
);

endmodule
