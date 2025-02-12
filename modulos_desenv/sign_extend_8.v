module sign_extend_8(
    input  wire [7-0] in,
    output wire [31:0] out,
);
    assign out = {{{31{1'b0}},in}};
endmodule
