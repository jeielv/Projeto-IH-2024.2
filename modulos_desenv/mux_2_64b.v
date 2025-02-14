module mux_2_64b(
    input wire seletor,
    input wire [63:0] in_0,
    input wire [63:0] in_1,
    output wire [63:0] out
);

    assign out = (selector ? in_1 : in_0);

endmodule
