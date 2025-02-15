module sign_extend_16 (
    input  wire [15:0] in,
    output wire [31:0] out
);
    assign data_out = (in[15] ? {{16{1'b1}},in} : {{16{1'b0}},in});     //deve ter coisa errada; o in ta dentro de chaves, acho q deveria estar depois do parenteses do operador ternario
endmodule
