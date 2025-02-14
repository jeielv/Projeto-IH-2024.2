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
wire [63:0] div_mul_in;
wire [31:0] div_mul_inHI;
wire [31:0] div_mul_outHI;
wire [31:0] div_mul_inLOW;
wire [31:0] div_mul_outLOW;
assign div_mul_inHI = div_mul_in[63:32];
assign div_mul_inLOW = div_mul_in[31:0];

wire [31:0] sb_manip_out;

wire [4:0] inst15_11;
assign inst15_11 = inst15_0[15:11];

wire [4:0] trinta_e_um;
assign trinta_e_um = 5'b11111;

wire [31:0] to_mux_to_write_data_reg;

wire [7:0] MDR7_0;
assign MDR7_0 = out_MDR[7:0];
wire[31:0] MDR_byte_extd;
wire [31:0] lui_result;

wire byte_or_word;
wire [1:0] i_or_d;
wire [1:0] reg_dst;
wire [2:0] mem_to_reg;
wire [1:0] divmul_sh_reg;

Registrador PC(
    clk,
    reset,
    pc_write,
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

Registrador divMul_regHI(
    clk,
    reset,
    div_mul_wr,
    div_mul_inHI,
    div_mul_outHI
);

Registrador divMul_regLOW(
    clk,
    reset,
    div_mul_wr,
    div_mul_inLOW,
    div_mul_outLOW
);

sb_manip SB_manip(
    out_MDR,
    B_out,
    sb_manip_out
);

mux_2_32b mux_write_data_mem(
    byte_or_word,
    B_out,
    write_data_mem
);

mux_4_32b mux_mem_addr(
    i_or_d,
    pc_out,
    A_out,
    B_out,
    aluout_out,
    mem_addr
);

mux_3_5b mux_write_reg(
    reg_dst, 
    RT,
    inst15_11,
    trinta_e_um,
    write_reg
);

mux_3_32b mux_divmul_shft(
    divmul_sh_reg,
    div_mul_outHI,
    div_mul_outLOW,
    out_regDesloc,
    to_mux_to_write_data_reg
);

mux_7_32b mux_write_data_reg(
    mem_to_reg,
    pc_out,
    to_mux_to_write_data_reg,
    out_MDR,
    slt_signal_extd,
    MDR_byte_extd,
    aluout_out,
    lui_result,
    write_data_reg
);

sign_extend_1 slt_extd(
    slt_signal,
    slt_signal_extd
);

sign_extend_8 mem_byte_extd(
    MDR7_0,
    MDR_byte_extd
);

shiftleft_16_in16 lui(
    inst15_0,
    lui_result
);


endmodule
