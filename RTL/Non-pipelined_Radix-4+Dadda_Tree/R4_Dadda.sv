
module R4_Dadda #(
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

    assign partial[i] = $signed({{(2*N-(N+1)){pp[N]}}, pp}) <<< (2*i);

end

endgenerate
localparam WIDTH = 2*N;

logic signed [WIDTH-1:0] row0,row1,row2,row3;
logic signed [WIDTH-1:0] row4,row5,row6,row7;

assign row0 = partial[0];
assign row1 = partial[1];
assign row2 = partial[2];
assign row3 = partial[3];
assign row4 = partial[4];
assign row5 = partial[5];
assign row6 = partial[6];
assign row7 = partial[7];

//////////////////////////////////////////////////
// CSA reduction
//////////////////////////////////////////////////

logic signed [WIDTH-1:0] s1,c1;
logic signed [WIDTH-1:0] s2,c2;
logic signed [WIDTH-1:0] s3,c3;

assign s1 = row0 ^ row1 ^ row2;
assign c1 = ((row0 & row1) | (row1 & row2) | (row0 & row2)) << 1;

assign s2 = row3 ^ row4 ^ row5;
assign c2 = ((row3 & row4) | (row4 & row5) | (row3 & row5)) << 1;

assign s3 = s1 ^ c1 ^ s2;
assign c3 = ((s1 & c1) | (c1 & s2) | (s1 & s2)) << 1;

//////////////////////////////////////////////////
// Final accumulation
//////////////////////////////////////////////////

logic signed [WIDTH-1:0] temp;

assign temp = s3 + c3 + row6 + row7;

assign P = temp;
endmodule