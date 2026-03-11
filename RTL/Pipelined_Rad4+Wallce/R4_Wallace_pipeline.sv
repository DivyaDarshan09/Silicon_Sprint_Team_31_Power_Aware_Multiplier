`timescale 1ns/1ps
module R4_Wallace_pipeline #(
    parameter N = 16
)(
    input  logic clk,
    input  logic rst,
    input  logic signed [N-1:0] X,
    input  logic signed [N-1:0] Y,
    output logic signed [2*N-1:0] P
);

localparam GROUPS = N/2;

//--------------------------------------
// Stage 1: Booth + Partial Product Generation
//--------------------------------------
logic [N:0] Y_ext;
assign Y_ext = {Y,1'b0};

logic signed [2*N-1:0] partial[GROUPS-1:0];
logic signed [2*N-1:0] partial_r[GROUPS-1:0]; // pipeline register stage1

genvar i;
generate
for(i=0;i<GROUPS;i++) begin : booth_stage
    logic zero, neg, one, two;
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

// Stage1 pipeline registers
always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        for(int k=0;k<GROUPS;k++) partial_r[k] <= '0;
    end else begin
        for(int k=0;k<GROUPS;k++) partial_r[k] <= partial[k];
    end
end

//--------------------------------------
// Stage 2: Wallace Stage1 + Stage2
//--------------------------------------
logic [31:0] pp0,pp1,pp2,pp3,pp4,pp5,pp6,pp7;
logic [31:0] s0,s1,s2,c0,c1,c2;
logic [31:0] s3,s4,c3,c4;

always_comb begin
    pp0 = partial_r[0][31:0]; pp1 = partial_r[1][31:0];
    pp2 = partial_r[2][31:0]; pp3 = partial_r[3][31:0];
    pp4 = partial_r[4][31:0]; pp5 = partial_r[5][31:0];
    pp6 = partial_r[6][31:0]; pp7 = partial_r[7][31:0];
end

// Wallace stage1
wallace_1 st1(
    pp0,pp1,pp2,pp3,pp4,pp5,pp6,pp7,
    s0,s1,s2,
    c0,c1,c2
);

// Wallace stage2
wallace_2 st2(
    s0, c0<<1,
    s1, c1<<1,
    s2, c2<<1,
    s3, s4,
    c3, c4
);

// Stage2 pipeline registers
logic [31:0] s3_r, s4_r, c3_r, c4_r;
always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        s3_r <= 0; s4_r <= 0;
        c3_r <= 0; c4_r <= 0;
    end else begin
        s3_r <= s3; s4_r <= s4;
        c3_r <= c3; c4_r <= c4;
    end
end

//--------------------------------------
// Stage 3: Wallace Stage3 + Stage4 + CLA
//--------------------------------------
logic [31:0] s5,c5,r0;
logic [31:0] sum,carry;
logic [31:0] product;

wallace_3 st3(
    s3_r, c3_r<<1,
    s4_r, c4_r<<1,
    s5, c5,
    r0
);

wallace_4 st4(
    s5, c5<<1,
    r0,
    sum,
    carry
);

wallace_final final_stage(
    sum,
    carry,
    product
);

// Stage3 output register
always_ff @(posedge clk or posedge rst) begin
    if (rst)
        P <= 0;
    else
        P <= product;
end

endmodule