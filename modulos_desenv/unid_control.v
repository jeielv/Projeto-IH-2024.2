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

    output reg [1:0] i_or_d,    // mux
    output reg [2:0] mem_to_reg,    // mux
    output reg [1:0] pc_src,     // mux
    output reg [2:0] alu_op,
    output reg [1:0] alu_src_a,   // mux
    output reg [1:0] alu_src_b,   // mux
    output reg [1:0] reg_dst,    // mux
    output reg [1:0] divmul_sh_reg,  // mux
    output reg [2:0] sh_op   

);

    reg [4:0] STATE;

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
    parameter FETCH = 5'b11001;
    parameter BRANCH_END = 5'b11010;
    parameter DECODE = 5'b11011

initial begin
    pc_write_cond = 1'b0;
    pc_write = 1'b0;
    mem_read = 1'b0;
    mem_write = 1'b0;
    byte_or_word = 1'b0;
    ir_write = 1'b0;
    reg_write = 1'b0;
    ab_from_memory = 1'b0;
    div_mul_wr = 1'b0;
    div_mul_to_reg = 1'b0;
    alu_op = 3'b000;
    sh_op = 3'b000;
    STATE = FETCH;
end

always @(posedge clk) begin
    if (reset == 1) begin
        STATE = RESET;
        pc_write_cond = 1'b0;
        pc_write = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        byte_or_word = 1'b0;
        ir_write = 1'b0;
        reg_write = 1'b0;
        ab_from_memory = 1'b0;
        div_mul_wr = 1'b0;
        div_mul_to_reg = 1'b0;
        alu_op = 3'b000;
        sh_op = 3'b000;
        i_or_d = 2'b00;
        mem_to_reg = 3'b000;
        pc_src = 2'b00;
        alu_src_a = 2'b00;
        alu_src_b = 2'b00;
        reg_dst = 2'b00;
        divmul_sh_reg = 2'b00;
    end
    else begin
        case (STATE)
            RESET: begin
                STATE = RESET;
                pc_write_cond = 1'b0;
                pc_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                byte_or_word = 1'b0;
                ir_write = 1'b0;
                reg_write = 1'b0;
                ab_from_memory = 1'b0;
                div_mul_wr = 1'b0;
                div_mul_to_reg = 1'b0;
                alu_op = 3'b000;
                sh_op = 3'b000;
                i_or_d = 2'b00;
                mem_to_reg = 3'b000;
                pc_src = 2'b00;
                alu_src_a = 2'b00;
                alu_src_b = 2'b00;
                reg_dst = 2'b00;
                divmul_sh_reg = 2'b00;
            end

            FETCH: begin
                STATE = BRANCH_END;
                pc_write_cond = 1'b0;
                pc_write = 1'b1;
                mem_read = 1'b1;
                mem_write = 1'b0;
                byte_or_word = 1'b0;
                ir_write = 1'b1;
                reg_write = 1'b0;
                ab_from_memory = 1'b0;
                div_mul_wr = 1'b0;
                div_mul_to_reg = 1'b0;
                alu_op = 3'b000;
                sh_op = 3'b000;
                i_or_d = 2'b00;
                mem_to_reg = 3'b000;
                pc_src = 2'b00;
                alu_src_a = 2'b00;
                alu_src_b = 2'b01;
                reg_dst = 2'b00;
                divmul_sh_reg = 2'b00;
            end

            BRANCH_END: begin
                STATE = DECODE;
                pc_write_cond = 1'b0;
                pc_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                byte_or_word = 1'b0;
                ir_write = 1'b0;
                reg_write = 1'b0;
                ab_from_memory = 1'b0;
                div_mul_wr = 1'b0;
                div_mul_to_reg = 1'b0;
                alu_op = 3'b000;
                sh_op = 3'b000;
                i_or_d = 2'b00;
                mem_to_reg = 3'b000;
                pc_src = 2'b00;
                alu_src_a = 2'b00;
                alu_src_b = 2'b11;
                reg_dst = 2'b00;
                divmul_sh_reg = 2'b00;
            end

            DECODE: begin
                if(opcode == 6'b000000) begin
                    if(funct == 6'b100000 || funct == 6'b100100 || funct == 6'b100010) begin
                        STATE = ALU_OP_2;
                    end
                    else begin
                        if(funct == 6'b000000 || funct == 6'b000011) begin
                            STATE = DESLOC_CALC;
                        end
                        else begin
                            if(funct == 6'b000101) begin
                                STATE = A_MEM_READ;
                            end
                            else begin
                                if (funct == 6'b101010) begin
                                    STATE = ALU_OP_1;
                                end
                                else begin
                                    if(funct == 6'b001000) begin
                                        STATE = JUMP_REG;
                                    end
                                    else begin
                                        if (funct == 6'b011010 || funct == 6'b011000) begin
                                            STATE = DIV_MUL_REG_WRITE;
                                        end
                                        else begin
                                            if(funct == 6'b01000 || funct == 6'b010010) begin
                                                STATE = WRITE_BACK_3;
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                else begin
                    if ()
                end
            end
    end
end

endmodule
