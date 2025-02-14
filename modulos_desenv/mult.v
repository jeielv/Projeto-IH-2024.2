module mult(
    input wire [31:0] data_A
    input wire [31:0] data_B
    output wire [63:0] out
);
    assign out = data_A * data_B;

endmodule
