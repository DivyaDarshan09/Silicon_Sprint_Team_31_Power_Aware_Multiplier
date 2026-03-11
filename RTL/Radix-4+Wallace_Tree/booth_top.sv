module booth_top #(
    parameter N = 16
)(
    input  logic signed [N-1:0] X,
    input  logic signed [N-1:0] Y,

    output logic signed [2*N-1:0] P
);

localparam GROUPS = N/2;

logic [N:0] Y_ext;

assign Y_ext = {Y,1'b0};

logic signed [2*N-1:0] partial[GROUPS-1:0];

genvar i;

generate

for(i=0;i<GROUPS;i++) begin : booth_stage

    logic zero;
    logic neg;
    logic one;
    logic two;

    logic signed [N:0] pp;

    booth_preencode pre (
        .y2(Y_ext[2*i+2]),
        .y1(Y_ext[2*i+1]),
        .y0(Y_ext[2*i]),
        .zero(zero)
    );

    booth_encoder enc (
        .y2(Y_ext[2*i+2]),
        .y1(Y_ext[2*i+1]),
        .y0(Y_ext[2*i]),
        .neg(neg),
        .one(one),
        .two(two)
    );

    partial_product_gen #(.N(N)) ppgen (
        .X(X),
        .zero(zero),
        .neg(neg),
        .one(one),
        .two(two),
        .PP(pp)
    );

    assign partial[i] = pp <<< (2*i);

end

endgenerate


integer j;

always_comb begin

    P = 0;

    for(j=0;j<GROUPS;j++)
        P += partial[j];

end

endmodule

