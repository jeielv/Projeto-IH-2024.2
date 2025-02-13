module mux_4(
    input wire [1:0] seletor
    input wire [31:0] in_0     // PC
    input wire [31:0] in_1     // A
    input wire [31:0] in_2     // B
    input wire [31:0] in_3     // ALU_Out
    output wire [31:0] out
);

    assign out = (selector[1] ? (selector[0] ? in_3 : in_2) : (selector[0] ? in_1 : in_0))

endmodule
