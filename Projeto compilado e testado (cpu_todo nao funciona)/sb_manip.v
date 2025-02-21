module sb_manip(
    input wire [31:0] mem_byte,
    input wire [31:0] b_byte,
    output wire [31:0] out
);

    assign out = {mem_byte[31:8], b_byte[7:0]};

endmodule
