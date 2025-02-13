module mux_2(
    input wire seletor
    input wire [31:0] in_0
    input wire [31:0] in_1
    output wire [31:0] out
);

    assign out = (selector ? in_1 : in_0);

endmodule
