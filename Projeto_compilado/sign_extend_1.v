module sign_extend_1(
    input  wire in,
    output wire [31:0] out
);
    assign out = {{{31{1'b0}},in}};
endmodule
