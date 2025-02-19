module cpu_todo(
    input wire clk,
    input wire reset
);

wire one;
assign one = 1'b1;

wire pc_write;
wire [31:0] pc_in;
wire [31:0] pc_out;

wire [31:0] mem_addr;
wire [31:0] write_data_mem;
wire [31:0] mem_data;

wire ir_write;
wire [5:0] opcode;
wire [4:0] RS;
wire [4:0] RT;
wire [15:0] inst15_0;

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
wire [63:0] div_result;
wire [63:0] mult_result;
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

wire [5:0] funct;
assign funct = inst15_0[5:0];

wire [4:0] trinta_e_um;
assign trinta_e_um = 5'b11111;
wire [2:0] quatro;
assign quatro = 3'b100;

wire [31:0] to_mux_to_write_data_reg;

wire [7:0] MDR7_0;
assign MDR7_0 = out_MDR[7:0];
wire[31:0] MDR_byte_extd;
wire [31:0] lui_result;
wire [31:0] A_to_div;
wire [31:0] B_to_div;

wire byte_or_word;
wire [1:0] i_or_d;
wire [1:0] reg_dst;
wire [2:0] mem_to_reg;
wire [1:0] divmul_sh_reg;
wire ab_from_memory;
wire div_or_mul;
wire [1:0] alu_src_a;
wire [1:0] alu_src_b;
wire [1:0] pc_src;
wire mem_write;

wire [31:0] offset_to_add;
wire [31:0] branch_offset;
wire [31:0] jump_addr;
assign jump_addr = {pc_out[31:28], RS, RT, inst15_0, 2'b00};

wire mem_read;

wire [4:0] STATE;

Registrador PC(
    .Clk(clk),
    .Reset(reset),
    .Load(pc_write),
    .Entrada(pc_in),
    .Saida(pc_out)
);

Memoria MEM(
    .Address(mem_addr),
    .Clock(clk),
    .Wr(mem_write),
    .Datain(write_data_mem),
    .Dataout(mem_data)
);

Instr_Reg IR(
    .Clk(clk), 
    .Reset(reset),
    .Load_ir(ir_write),
    .Entrada(mem_data),
    .Instr31_26(opcode),
    .Instr25_21(RS),
    .Instr20_16(RT),
    .Instr15_0(inst15_0)
);

Banco_reg regs(
    .Clk(clk),
    .Reset(reset),
    .RegWrite(reg_write),
    .ReadReg1(RS),
    .ReadReg2(RT),
    .WriteReg(write_reg),
    .WriteData(write_data_reg),
    .ReadData1(out_rs),
    .ReadData2(out_rt)
);

ula32 ULA(
    .A(op1ULA),
    .B(op2ULA),
    .Seletor(alu_op),
    .S(alu_result),
    .Overflow(ov),
    .Negativo(negt),
    .z(zero),
    .Igual(eq),
    .Maior(maior),
    .Menor(slt_signal)
);

RegDesloc regDesloc(
    .Clk(clk),
    .Reset(reset),
    .Shift(sh_op),
    .N(shamt),
    .Entrada(out_rt),
    .Saida(out_regDesloc)
);

Registrador MDR(
    .Clk(clk),
    .Reset(reset),
    .Load(one),
    .Entrada(mem_data),
    .Saida(out_MDR)
);

Registrador A_from_memory(
    .Clk(clk),
    .Reset(reset),
    .Load(one),
    .Entrada(mem_data),
    .Saida(out_A_from_mem)
);

Registrador regA(
    .Clk(clk),
    .Reset(reset),
    .Load(one),
    .Entrada(out_rs),
    .Saida(A_out)
);

Registrador regB(
    .Clk(clk),
    .Reset(reset),
    .Load(one),
    .Entrada(out_rt),
    .Saida(B_out)
);

Registrador ALUOut(
    .Clk(clk),
    .Reset(reset),
    .Load(one),
    .Entrada(alu_result),
    .Saida(aluout_out)
);

Registrador divMul_regHI(
    .Clk(clk),
    .Reset(reset),
    .Load(div_mul_wr),
    .Entrada(div_mul_inHI),
    .Saida(div_mul_outHI)
);

Registrador divMul_regLOW(
    .Clk(clk),
    .Reset(reset),
    .Load(div_mul_wr),
    .Entrada(div_mul_inLOW),
    .Saida(div_mul_outLOW)
);

sb_manip SB_manip(
    .mem_byte(out_MDR),
    .b_byte(B_out),
    .out(sb_manip_out)
);

mux_2_32b mux_write_data_mem(
    .selector(byte_or_word),
    .in_0(B_out),
    .in_1(sb_manip_out),
    .out(write_data_mem)
);

mux_2_32b mux_A_to_div(
    .selector(ab_from_memory),
    .in_0(out_A_from_mem),
    .in_1(A_out),
    .out(A_to_div)
);

mux_2_32b mux_B_to_div(
    .selector(ab_from_memory),
    .in_0(mem_data),
    .in_1(B_out),
    .out(B_to_div)
);

mux_4_32b mux_mem_addr(
    .selector(i_or_d),
    .in_0(pc_out),
    .in_1(A_out),
    .in_2(B_out),
    .in_3(aluout_out),
    .out(mem_addr)
);

mux_3_5b mux_write_reg(
    .selector(reg_dst), 
    .in_0(RT),
    .in_1(inst15_11),
    .in_2(trinta_e_um),
    .out(write_reg)
);

mux_3_32b mux_divmul_shft(
    .selector(divmul_sh_reg),
    .in_0(div_mul_outHI),
    .in_1(div_mul_outLOW),
    .in_2(out_regDesloc),
    .out(to_mux_to_write_data_reg)
);

mux_7_32b mux_write_data_reg(
    .selector(mem_to_reg),
    .in_0(pc_out),
    .in_1(to_mux_to_write_data_reg),
    .in_2(out_MDR),
    .in_3(slt_signal_extd),
    .in_4(MDR_byte_extd),
    .in_5(aluout_out),
    .in_6(lui_result),
    .out(write_data_reg)
);

mux_2_64b mux_to_divmul_reg(
    .selector(div_or_mul),
    .in_0(div_result),
    .in_1(mult_result),
    .out(div_mul_in)
);

div calc_div(
    .data_A(A_to_div),
    .data_B(B_to_div),
    .out(div_result)
);

mult calc_mult(
    .data_A(A_out),
    .data_B(B_out),
    .out(mult_result)
);

sign_extend_1 slt_extd(
    .in(slt_signal),
    .out(slt_signal_extd)
);

sign_extend_8 mem_byte_extd(
    .in(MDR7_0),
    .out(MDR_byte_extd)
);

sign_extend_16 extd_offset(
    .in(inst15_0),
    .out(offset_to_add)
);

shiftleft_16_in16 lui(
    .in(inst15_0),
    .out(lui_result)
);

shiftleft_2_in32 shft_to_branch(
    .in(offset_to_add),
    .out(branch_offset)
);

mux_3_32b mux_op1(
    .selector(alu_src_a),
    .in_0(pc_out),
    .in_1(A_out),
    .in_2(out_MDR),
    .out(op1ULA)
);

mux_4_32b muxop2(
    .selector(alu_src_b),
    .in_0(B_out),
    .in_1(quatro),
    .in_2(offset_to_add),
    .in_3(branch_offset),
    .out(op2ULA)
);

mux_4_32b mux_pc_valor(
    .selector(pc_src),
    .in_0(alu_result),
    .in_1(aluout_out),
    .in_2(jump_addr),
    .in_3(A_out),
    .out(pc_in)
);

unid_control ctrl_unit(
    .clk(clk), 
    .reset(reset),
    .opcode(opcode),
    .funct(funct),
    .eq(eq),
    .pc_write(pc_write),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .byte_or_word(byte_or_word),
    .ir_write(ir_write),
    .reg_write(reg_write),
    .ab_from_memory(ab_from_memory),
    .div_mul_wr(div_mul_wr),
    .div_or_mul(div_or_mul),
    .i_or_d(i_or_d),
    .mem_to_reg(mem_to_reg),
    .pc_src(pc_src),
    .alu_op(alu_op),
    .alu_src_a(alu_src_a),
    .alu_src_b(alu_src_b),
    .reg_dst(reg_dst),
    .divmul_sh_reg(divmul_sh_reg),
    .sh_op(sh_op),
    .STATE(STATE) 
);

endmodule
