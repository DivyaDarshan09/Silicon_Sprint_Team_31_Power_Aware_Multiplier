module booth_preencode (
    input  logic y2,
    input  logic y1,
    input  logic y0,
    output logic zero
);

assign zero = (~y2 & ~y1 & ~y0) | (y2 & y1 & y0);

endmodule
