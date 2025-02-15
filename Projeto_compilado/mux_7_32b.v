module mux_7_32b(
    input wire [2:0] selector,
    input wire [31:0] in_0,
    input wire [31:0] in_1,
    input wire [31:0] in_2,
    input wire [31:0] in_3,
    input wire [31:0] in_4,
    input wire [31:0] in_5 ,
    input wire [31:0] in_6 ,
    output wire [31:0] out
);

    assign out = (selector[2] ? ((selector[1] ? (selector[0] ? {32{1'b0}} : in_6) : (selector[0] ? in_5 : in_4))) : ((selector[1] ? (selector[0] ? in_3 : in_2) : (selector[0] ? in_1 : in_0))));

endmodule
