module wallace_final(
    input logic [31:0] sum,
    input logic [31:0] carry,
    output logic [31:0] product
);

logic Cout;
//fast CLA final adder
carry_lookahead_adder32 CLA_FINAL(
    .A(sum),
    .B(carry<<1),
    .Sum(product),
    .C0(Cout)
);

endmodule