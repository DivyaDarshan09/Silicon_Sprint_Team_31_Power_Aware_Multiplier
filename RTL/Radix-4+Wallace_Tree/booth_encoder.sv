module booth_encoder (
    input  logic y2,
    input  logic y1,
    input  logic y0,

    output logic neg,
    output logic one,
    output logic two
);

assign neg = y2;

assign one = y1 ^ y0;

assign two = (~y2 & y1 & y0) | (y2 & ~y1 & ~y0);

endmodule
