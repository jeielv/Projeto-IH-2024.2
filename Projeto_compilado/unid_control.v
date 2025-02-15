module unid_control(
    input wire clk,
    input wire reset, 
    input wire [5:0] opcode,
    input wire [5:0] funct,

    input wire eq,    // flag que sai da alu dizendo se A = B

    output reg pc_write,
    output reg mem_read,
    output reg mem_write,
    output reg byte_or_word,
    output reg ir_write,
    output reg reg_write,
    output reg ab_from_memory,
    output reg div_mul_wr,
    output reg div_or_mul,

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
    reg [2:0] INST_ID;

    //para INST_ID
    parameter LW = 3'b001;
    parameter SW = 3'b010;
    parameter LB = 3'b011;
    parameter SB = 3'b100;
    parameter ADDM = 3'b101;

    //para STATE
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
    parameter DECODE = 5'b11011;
    parameter RESET = 5'b11100;
    parameter WRITE_BACK_8 = 5'b11111;

initial begin
    pc_write = 1'b0;
    mem_read = 1'b0;
    mem_write = 1'b0;
    byte_or_word = 1'b0;
    ir_write = 1'b0;
    reg_write = 1'b0;
    ab_from_memory = 1'b0;
    div_mul_wr = 1'b0;
    div_or_mul = 1'b0;
    alu_op = 3'b000;
    sh_op = 3'b000;
    STATE = FETCH;
end

always @(posedge clk) begin
    if (reset == 1) begin
        STATE = RESET;
        INST_ID = 3'b000;
        pc_write = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        byte_or_word = 1'b0;
        ir_write = 1'b0;
        reg_write = 1'b0;
        ab_from_memory = 1'b0;
        div_mul_wr = 1'b0;
        div_or_mul = 1'b0;
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
                STATE = FETCH;
                INST_ID = 3'b000;
                pc_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                byte_or_word = 1'b0;
                ir_write = 1'b0;
                reg_write = 1'b0;
                ab_from_memory = 1'b0;
                div_mul_wr = 1'b0;
                div_or_mul = 1'b0;
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
                INST_ID = 3'b000;
                pc_write = 1'b1;
                mem_read = 1'b1;
                mem_write = 1'b0;
                byte_or_word = 1'b0;
                ir_write = 1'b1;
                reg_write = 1'b0;
                ab_from_memory = 1'b0;
                div_mul_wr = 1'b0;
                div_or_mul = 1'b0;
                alu_op = 3'b001;
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
                INST_ID = 3'b000;
                pc_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                byte_or_word = 1'b0;
                ir_write = 1'b0;
                reg_write = 1'b0;
                ab_from_memory = 1'b0;
                div_mul_wr = 1'b0;
                div_or_mul = 1'b0;
                alu_op = 3'b001;
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
                        INST_ID = 3'b000;
                    end
                    else begin
                        if(funct == 6'b000000 || funct == 6'b000011) begin
                            STATE = DESLOC_CALC;
                            INST_ID = 3'b000;
                        end
                        else begin
                            if(funct == 6'b000101) begin
                                STATE = A_MEM_READ;
                                INST_ID = 3'b000;
                            end
                            else begin
                                if (funct == 6'b101010) begin
                                    STATE = ALU_OP_1;
                                    INST_ID = 3'b000;
                                end
                                else begin
                                    if(funct == 6'b001000) begin
                                        STATE = JUMP_REG;
                                        INST_ID = 3'b000;
                                    end
                                    else begin
                                        if (funct == 6'b011010 || funct == 6'b011000) begin
                                            STATE = DIV_MUL_REG_WRITE;
                                            INST_ID = 3'b000;
                                        end
                                        else begin
                                            if(funct == 6'b010000 || funct == 6'b010010) begin
                                                STATE = WRITE_BACK_3;
                                                INST_ID = 3'b000;
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                else begin
                    if (opcode == 6'b000010) begin
                        STATE = JUMP;
                        INST_ID = 3'b000;
                    end
                    else begin 
                        if (opcode == 6'b000011) begin 
                            STATE = JUMP_REG;
                            INST_ID = 3'b000;
                        end
                        else begin 
                            if (opcode == 6'b001000) begin 
                                STATE = ALU_OP_3;
                                INST_ID = 3'b000;
                            end
                            else begin 
                                if(opcode == 6'b000100 || opcode == 6'b000101) begin 
                                    STATE = ALU_OP_4;
                                    INST_ID = 3'b000;
                                end
                                else begin 
                                    if (opcode == 6'b000001) begin 
                                        STATE = END_CALC;
                                        INST_ID = ADDM;
                                    end
                                    else begin 
                                        if (opcode == 6'b001111) begin 
                                            STATE = WRITE_BACK_5;
                                            INST_ID = 3'b000;
                                        end
                                        else begin 
                                            if (opcode == 6'b100011) begin
                                                STATE = END_CALC;
                                                INST_ID = LW;
                                            end
                                            else begin 
                                                if (opcode == 6'b101011) begin 
                                                    STATE = END_CALC;
                                                    INST_ID = SW;
                                                end
                                                else begin 
                                                    if (opcode == 6'b100000) begin 
                                                        STATE = END_CALC;
                                                        INST_ID = LB;
                                                    end
                                                    else begin 
                                                        if (opcode == 6'b101000) begin 
                                                            STATE = END_CALC;
                                                            INST_ID = SB;
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end

            A_MEM_READ: begin 
                STATE = B_MEM_READ;
                INST_ID = 3'b000;
                pc_write = 1'b0;
                mem_read = 1'b1;
                mem_write = 1'b0;
                byte_or_word = 1'b0;
                ir_write = 1'b0;
                reg_write = 1'b0;
                ab_from_memory = 1'b0;
                div_mul_wr = 1'b0;
                div_or_mul = 1'b0;
                alu_op = 3'b000;
                sh_op = 3'b000;
                i_or_d = 2'b01;
                mem_to_reg = 3'b000;
                pc_src = 2'b00;
                alu_src_a = 2'b00;
                alu_src_b = 2'b00;
                reg_dst = 2'b00;
                divmul_sh_reg = 2'b00;
            end

            B_MEM_READ: begin 
                STATE = DIVM;
                INST_ID = 3'b000;
                pc_write = 1'b0;
                mem_read = 1'b1;
                mem_write = 1'b0;
                byte_or_word = 1'b0;
                ir_write = 1'b0;
                reg_write = 1'b0;
                ab_from_memory = 1'b0;
                div_mul_wr = 1'b0;
                div_or_mul = 1'b0;
                alu_op = 3'b000;
                sh_op = 3'b000;
                i_or_d = 2'b10;
                mem_to_reg = 3'b000;
                pc_src = 2'b00;
                alu_src_a = 2'b00;
                alu_src_b = 2'b00;
                reg_dst = 2'b00;
                divmul_sh_reg = 2'b00;
            end

            DIVM: begin 
                STATE = FETCH;
                INST_ID = 3'b000;
                pc_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                byte_or_word = 1'b0;
                ir_write = 1'b0;
                reg_write = 1'b0;
                ab_from_memory = 1'b0;
                div_mul_wr = 1'b1;
                div_or_mul = 1'b0;
                alu_op = 3'b010;
                sh_op = 3'b000;
                i_or_d = 2'b00;
                mem_to_reg = 3'b000;
                pc_src = 2'b00;
                alu_src_a = 2'b00;
                alu_src_b = 2'b00;
                reg_dst = 2'b00;
                divmul_sh_reg = 2'b00;
            end

            ALU_OP_1: begin 
                STATE = FETCH;
                INST_ID = 3'b000;
                pc_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                byte_or_word = 1'b0;
                ir_write = 1'b0;
                reg_write = 1'b1;
                ab_from_memory = 1'b0;
                div_mul_wr = 1'b0;
                div_or_mul = 1'b0;
                alu_op = 3'b010;
                sh_op = 3'b000;
                i_or_d = 2'b00;
                mem_to_reg = 3'b011;
                pc_src = 2'b00;
                alu_src_a = 2'b01;
                alu_src_b = 2'b00;
                reg_dst = 2'b01;
                divmul_sh_reg = 2'b00;
            end

            DESLOC_CALC: begin 
                STATE = WRITE_BACK_1;
                INST_ID = 3'b000;
                pc_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                byte_or_word = 1'b0;
                ir_write = 1'b0;
                reg_write = 1'b0;
                ab_from_memory = 1'b0;
                div_mul_wr = 1'b0;
                div_or_mul = 1'b0;
                alu_op = 3'b000;

                if(funct == 6'b000000) begin
                    sh_op = 3'b010;
                end
                else begin
                    sh_op = 3'b100;
                end

                i_or_d = 2'b00;
                mem_to_reg = 3'b000;
                pc_src = 2'b00;
                alu_src_a = 2'b00;
                alu_src_b = 2'b00;
                reg_dst = 2'b00;
                divmul_sh_reg = 2'b00;
            end

            WRITE_BACK_1: begin 
                STATE = FETCH;
                INST_ID = 3'b000;
                pc_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                byte_or_word = 1'b0;
                ir_write = 1'b0;
                reg_write = 1'b0;
                ab_from_memory = 1'b0;
                div_mul_wr = 1'b0;
                div_or_mul = 1'b0;
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

            ALU_OP_2: begin 
                STATE = WRITE_BACK_2;
                INST_ID = 3'b000;
                pc_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                byte_or_word = 1'b0;
                ir_write = 1'b0;
                reg_write = 1'b0;
                ab_from_memory = 1'b0;
                div_mul_wr = 1'b0;
                div_or_mul = 1'b0;

                if (funct == 6'b100000) begin
                    alu_op = 3'b000;
                end
                else begin 
                    if(funct == 6'b100100) begin 
                        alu_op = 3'b011;
                    end

                    else begin 
                        alu_op = 3'b010;
                    end
                end

                sh_op = 3'b000;
                i_or_d = 2'b00;
                mem_to_reg = 3'b000;
                pc_src = 2'b00;
                alu_src_a = 2'b01;
                alu_src_b = 2'b00;
                reg_dst = 2'b00;
                divmul_sh_reg = 2'b00;
            end

            WRITE_BACK_2: begin 
                STATE = FETCH;
                INST_ID = 3'b000;
                pc_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                byte_or_word = 1'b0;
                ir_write = 1'b0;
                reg_write = 1'b1;
                ab_from_memory = 1'b0;
                div_mul_wr = 1'b0;
                div_or_mul = 1'b0;
                alu_op = 3'b000;
                sh_op = 3'b000;
                i_or_d = 2'b00;
                mem_to_reg = 3'b101;
                pc_src = 2'b00;
                alu_src_a = 2'b00;
                alu_src_b = 2'b00;
                reg_dst = 2'b01;
                divmul_sh_reg = 2'b00;
            end

            JUMP_REG: begin 
                STATE = FETCH;
                INST_ID = 3'b000;
                pc_write = 1'b1;
                mem_read = 1'b0;
                mem_write = 1'b0;
                byte_or_word = 1'b0;
                ir_write = 1'b0;
                reg_write = 1'b0;
                ab_from_memory = 1'b0;
                div_mul_wr = 1'b0;
                div_or_mul = 1'b0;
                alu_op = 3'b000;
                sh_op = 3'b000;
                i_or_d = 2'b00;
                mem_to_reg = 3'b000;
                pc_src = 2'b11;
                alu_src_a = 2'b00;
                alu_src_b = 2'b00;
                reg_dst = 2'b00;
                divmul_sh_reg = 2'b00;
            end

            DIV_MUL_REG_WRITE: begin 
                STATE = FETCH;
                INST_ID = 3'b000;
                pc_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                byte_or_word = 1'b0;
                ir_write = 1'b0;
                reg_write = 1'b0;
                ab_from_memory = 1'b1;
                div_mul_wr = 1'b1;

                if(funct == 6'b011010) begin
                    div_or_mul = 1'b0;
                end
                else begin 
                    div_or_mul = 1'b1;
                end

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

            WRITE_BACK_3: begin 
                STATE = FETCH;
                INST_ID = 3'b000;
                pc_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                byte_or_word = 1'b0;
                ir_write = 1'b0;
                reg_write = 1'b1;
                ab_from_memory = 1'b0;
                div_mul_wr = 1'b0;
                div_or_mul = 1'b0;
                alu_op = 3'b000;
                sh_op = 3'b000;
                i_or_d = 2'b00;
                mem_to_reg = 3'b001;
                pc_src = 2'b00;
                alu_src_a = 2'b00;
                alu_src_b = 2'b00;
                reg_dst = 2'b01;

                if(funct == 6'b010000)begin
                    divmul_sh_reg = 2'b00;
                end
                else begin
                    divmul_sh_reg = 2'b01;
                end
            end

            JUMP: begin 
                STATE = FETCH;
                INST_ID = 3'b000;
                pc_write = 1'b1;
                mem_read = 1'b0;
                mem_write = 1'b0;
                byte_or_word = 1'b0;
                ir_write = 1'b0;
                reg_write = 1'b0;
                ab_from_memory = 1'b0;
                div_mul_wr = 1'b0;
                div_or_mul = 1'b0;
                alu_op = 3'b000;
                sh_op = 3'b000;
                i_or_d = 2'b00;
                mem_to_reg = 3'b000;
                pc_src = 2'b10;
                alu_src_a = 2'b00;
                alu_src_b = 2'b00;
                reg_dst = 2'b00;
                divmul_sh_reg = 2'b00;
            end

            JUMP_WRITE: begin 
                STATE = FETCH;
                INST_ID = 3'b000;
                pc_write = 1'b1;
                mem_read = 1'b0;
                mem_write = 1'b0;
                byte_or_word = 1'b0;
                ir_write = 1'b0;
                reg_write = 1'b1;
                ab_from_memory = 1'b0;
                div_mul_wr = 1'b0;
                div_or_mul = 1'b0;
                alu_op = 3'b000;
                sh_op = 3'b000;
                i_or_d = 2'b00;
                mem_to_reg = 3'b000;
                pc_src = 2'b10;
                alu_src_a = 2'b00;
                alu_src_b = 2'b00;
                reg_dst = 2'b10;
                divmul_sh_reg = 2'b00;
            end

            ALU_OP_3: begin 
                STATE = WRITE_BACK_4;
                INST_ID = 3'b000;
                pc_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                byte_or_word = 1'b0;
                ir_write = 1'b0;
                reg_write = 1'b0;
                ab_from_memory = 1'b0;
                div_mul_wr = 1'b0;
                div_or_mul = 1'b0;
                alu_op = 3'b001;
                sh_op = 3'b000;
                i_or_d = 2'b00;
                mem_to_reg = 3'b000;
                pc_src = 2'b00;
                alu_src_a = 2'b01;
                alu_src_b = 2'b10;
                reg_dst = 2'b00;
                divmul_sh_reg = 2'b00;
            end

            WRITE_BACK_4: begin 
                STATE = FETCH;
                INST_ID = 3'b000;
                pc_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                byte_or_word = 1'b0;
                ir_write = 1'b0;
                reg_write = 1'b1;
                ab_from_memory = 1'b0;
                div_mul_wr = 1'b0;
                div_or_mul = 1'b0;
                alu_op = 3'b000;
                sh_op = 3'b000;
                i_or_d = 2'b00;
                mem_to_reg = 3'b101;
                pc_src = 2'b00;
                alu_src_a = 2'b00;
                alu_src_b = 2'b00;
                reg_dst = 2'b00;
                divmul_sh_reg = 2'b00;
            end

            ALU_OP_4: begin 
                STATE = FETCH;
                INST_ID = 3'b000;
                pc_write = eq ? (opcode[0]? 1'b0 : 1'b1) : (opcode[0]? 1'b1 : 1'b0);  // se A = B e eh bne, nao escreve pc; se A = B e eh beq, escreve pc
                mem_read = 1'b0;
                mem_write = 1'b0;
                byte_or_word = 1'b0;
                ir_write = 1'b0;
                reg_write = 1'b1;
                ab_from_memory = 1'b0;
                div_mul_wr = 1'b0;
                div_or_mul = 1'b0;
                alu_op = 3'b010;
                sh_op = 3'b000;
                i_or_d = 2'b00;
                mem_to_reg = 3'b101;
                pc_src = 2'b01;
                alu_src_a = 2'b01;
                alu_src_b = 2'b00;
                reg_dst = 2'b00;
                divmul_sh_reg = 2'b00;
            end
            
            END_CALC: begin
                if (INST_ID == ADDM) begin 
                    STATE = MEM_READ;
                    INST_ID = ADDM;
                end
                else begin 
                    if (INST_ID == LW) begin 
                        STATE = MEM_READ;
                        INST_ID = LW;
                    end
                    else begin 
                        if (INST_ID == SW) begin 
                            STATE =  MEM_WRITE_1;
                            INST_ID = SW;
                        end
                        else begin 
                            if (INST_ID == LB) begin 
                                STATE = MEM_READ;
                                INST_ID = LB;
                            end
                            else begin 
                                if (INST_ID == SB) begin 
                                    STATE = MEM_READ_END_BACK;
                                    INST_ID = SB;
                                end
                            end
                        end
                    end
                end
                pc_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                byte_or_word = 1'b0;
                ir_write = 1'b0;
                reg_write = 1'b0;
                ab_from_memory = 1'b0;
                div_mul_wr = 1'b0;
                div_or_mul = 1'b0;
                alu_op = 3'b001;
                sh_op = 3'b000;
                i_or_d = 2'b00;
                mem_to_reg = 3'b000;
                pc_src = 2'b00;
                alu_src_a = 2'b01;
                alu_src_b = 2'b10;
                reg_dst = 2'b00;
                divmul_sh_reg = 2'b00;
            end

            MEM_READ: begin 
                if (INST_ID == ADDM) begin 
                    STATE = ALU_OP_5;
                    INST_ID = ADDM;
                end
                else begin 
                    if (INST_ID == LW) begin 
                        STATE = WRITE_BACK_6;
                        INST_ID = LW;
                    end
                    else begin 
                        if (INST_ID == LB) begin 
                            STATE = WRITE_BACK_7;
                            INST_ID = LB;
                        end
                    end
                end
                pc_write = 1'b0;
                mem_read = 1'b1;
                mem_write = 1'b0;
                byte_or_word = 1'b0;
                ir_write = 1'b0;
                reg_write = 1'b0;
                ab_from_memory = 1'b0;
                div_mul_wr = 1'b0;
                div_or_mul = 1'b0;
                alu_op = 3'b000;
                sh_op = 3'b000;
                i_or_d = 2'b11;
                mem_to_reg = 3'b000;
                pc_src = 2'b00;
                alu_src_a = 2'b00;
                alu_src_b = 2'b00;
                reg_dst = 2'b00;
                divmul_sh_reg = 2'b00;
            end

            ALU_OP_5: begin 
                STATE = WRITE_BACK_3;
                INST_ID = ADDM;
                pc_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                byte_or_word = 1'b0;
                ir_write = 1'b0;
                reg_write = 1'b0;
                ab_from_memory = 1'b0;
                div_mul_wr = 1'b0;
                div_or_mul = 1'b0;
                alu_op = 3'b001;
                sh_op = 3'b000;
                i_or_d = 2'b00;
                mem_to_reg = 3'b000;
                pc_src = 2'b00;
                alu_src_a = 2'b10;
                alu_src_b = 2'b00;
                reg_dst = 2'b00;
                divmul_sh_reg = 2'b00;
            end

            WRITE_BACK_8: begin 
                STATE = FETCH;
                INST_ID = ADDM;
                pc_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                byte_or_word = 1'b0;
                ir_write = 1'b0;
                reg_write = 1'b1;
                ab_from_memory = 1'b0;
                div_mul_wr = 1'b0;
                div_or_mul = 1'b0;
                alu_op = 3'b000;
                sh_op = 3'b000;
                i_or_d = 2'b00;
                mem_to_reg = 3'b101;
                pc_src = 2'b00;
                alu_src_a = 2'b00;
                alu_src_b = 2'b00;
                reg_dst = 2'b00;
                divmul_sh_reg = 2'b00;
            end

            WRITE_BACK_5: begin 
                STATE = FETCH;
                INST_ID = 3'b000;
                pc_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                byte_or_word = 1'b0;
                ir_write = 1'b0;
                reg_write = 1'b1;
                ab_from_memory = 1'b0;
                div_mul_wr = 1'b0;
                div_or_mul = 1'b0;
                alu_op = 3'b000;
                sh_op = 3'b000;
                i_or_d = 2'b00;
                mem_to_reg = 3'b110;
                pc_src = 2'b00;
                alu_src_a = 2'b00;
                alu_src_b = 2'b00;
                reg_dst = 2'b00;
                divmul_sh_reg = 2'b00;
            end

            WRITE_BACK_6: begin 
                STATE = FETCH;
                INST_ID = LW;
                pc_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                byte_or_word = 1'b0;
                ir_write = 1'b0;
                reg_write = 1'b1;
                ab_from_memory = 1'b0;
                div_mul_wr = 1'b0;
                div_or_mul = 1'b0;
                alu_op = 3'b000;
                sh_op = 3'b000;
                i_or_d = 2'b00;
                mem_to_reg = 3'b010;
                pc_src = 2'b00;
                alu_src_a = 2'b00;
                alu_src_b = 2'b00;
                reg_dst = 2'b00;
                divmul_sh_reg = 2'b00;
            end

            MEM_WRITE_1: begin 
                STATE = FETCH;
                INST_ID = SW;
                pc_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b1;
                byte_or_word = 1'b0;
                ir_write = 1'b0;
                reg_write = 1'b0;
                ab_from_memory = 1'b0;
                div_mul_wr = 1'b0;
                div_or_mul = 1'b0;
                alu_op = 3'b000;
                sh_op = 3'b000;
                i_or_d = 2'b11;
                mem_to_reg = 3'b000;
                pc_src = 2'b00;
                alu_src_a = 2'b00;
                alu_src_b = 2'b00;
                reg_dst = 2'b00;
                divmul_sh_reg = 2'b00;
            end

            WRITE_BACK_7: begin 
                STATE = FETCH;
                INST_ID = LB;
                pc_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                byte_or_word = 1'b0;
                ir_write = 1'b0;
                reg_write = 1'b1;
                ab_from_memory = 1'b0;
                div_mul_wr = 1'b0;
                div_or_mul = 1'b0;
                alu_op = 3'b000;
                sh_op = 3'b000;
                i_or_d = 2'b00;
                mem_to_reg = 3'b100;
                pc_src = 2'b00;
                alu_src_a = 2'b00;
                alu_src_b = 2'b00;
                reg_dst = 2'b00;
                divmul_sh_reg = 2'b00;
            end

            MEM_READ_END_BACK: begin 
                STATE = MEM_WRITE_2;
                INST_ID = SB;
                pc_write = 1'b0;
                mem_read = 1'b1;
                mem_write = 1'b0;
                byte_or_word = 1'b0;
                ir_write = 1'b0;
                reg_write = 1'b0;
                ab_from_memory = 1'b0;
                div_mul_wr = 1'b0;
                div_or_mul = 1'b0;
                alu_op = 3'b001;
                sh_op = 3'b000;
                i_or_d = 2'b11;
                mem_to_reg = 3'b000;
                pc_src = 2'b00;
                alu_src_a = 2'b01;
                alu_src_b = 2'b10;
                reg_dst = 2'b00;
                divmul_sh_reg = 2'b00;
            end

            MEM_WRITE_2: begin 
                STATE = FETCH;
                INST_ID = SB;
                pc_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b1;
                byte_or_word = 1'b1;
                ir_write = 1'b0;
                reg_write = 1'b0;
                ab_from_memory = 1'b0;
                div_mul_wr = 1'b0;
                div_or_mul = 1'b0;
                alu_op = 3'b000;
                sh_op = 3'b000;
                i_or_d = 2'b11;
                mem_to_reg = 3'b000;
                pc_src = 2'b00;
                alu_src_a = 2'b00;
                alu_src_b = 2'b00;
                reg_dst = 2'b00;
                divmul_sh_reg = 2'b00;
            end

        endcase    
    end 
end

endmodule
