module mux_3_32b(
    input wire [1:0] seletor,
    input wire [31:0] in_0,
    input wire [31:0] in_1,
    input wire [31:0] in_2,
    output wire [31:0] out
);

    assign out = (selector[1] ? (selector[0] ? 32{1'b0} : in_2) : (selector[0] ? in_1 : in_0));

endmodule
