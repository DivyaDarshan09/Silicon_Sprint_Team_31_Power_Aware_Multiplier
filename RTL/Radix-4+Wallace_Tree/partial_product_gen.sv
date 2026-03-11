module partial_product_gen #(
    parameter N = 16
)(
    input  logic [N-1:0] X,
    input  logic zero,
    input  logic neg,
    input  logic one,
    input  logic two,

    output logic signed [N:0] PP
);

logic signed [N:0] X_ext;
logic signed [N:0] result;

assign X_ext = {X[N-1], X};

always_comb begin

    if (zero)
        result = 0;

    else if (one)
        result = X_ext;

    else if (two)
        result = X_ext <<< 1;

    else
        result = 0;

    if (neg)
        PP = -result;
    else
        PP = result;

end

endmodule
