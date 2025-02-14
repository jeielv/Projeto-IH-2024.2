module div(
    input wire [31:0] data_A
    input wire [31:0] data_B
    output wire [63:0] out
);
    wire [31:0] div;
    wire [31:0] rest;

    assign div = data_A / data_B;
    assign rest = data_A % data_B;

    assign out = {rest, div};

endmodule
