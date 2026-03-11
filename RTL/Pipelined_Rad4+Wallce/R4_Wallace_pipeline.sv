/****************************************************************************************
* Project        : Silicon Sprint Hackathon 2026
* Problem        : Power-Aware Multiplier Design
*
* Event          : Silicon Sprint Hackathon
* Organized by   : Mindgrove Technologies
* In collaboration with : SRM Institute of Science and Technology
* Date           : March 10–11, 2026
*
* Team           : Silicon Sprint - Team 31
*
* Module Name    : R4_Wallace_pipeline
*
* Description :
* This module implements a pipelined 16-bit signed multiplier using
* Radix-4 Booth encoding and Wallace Tree reduction.
*
* The goal of this design is to achieve a lower Power-Delay Product (PDP)
* by reducing the number of partial products and performing parallel
* compression using Wallace tree stages.
*
* Architecture :
*
*        X , Y
*          │
*          ▼
*   Stage 1 : Radix-4 Booth Encoding
*             + Partial Product Generation
*
*          ▼
*   Stage 2 : Wallace Tree Reduction
*             (Stage1 + Stage2 compression)
*
*          ▼
*   Stage 3 : Final Wallace Reduction
*             + Carry Lookahead Adder
*
*          ▼
*           P (32-bit Product)
*
* Pipeline Structure :
*
*   ┌───────────┐
*   │ Stage 1   │ Booth + PP Generation
*   └─────┬─────┘
*         │ pipeline register
*   ┌─────▼─────┐
*   │ Stage 2   │ Wallace Tree Compression
*   └─────┬─────┘
*         │ pipeline register
*   ┌─────▼─────┐
*   │ Stage 3   │ Final Wallace + CLA Adder
*   └─────┬─────┘
*         │ pipeline register
*         ▼
*       Product
*
* Key Features :
* - Radix-4 Booth reduces partial products from 16 → 8
* - Wallace tree performs fast parallel compression
* - Pipelining improves clock frequency
* - Designed for low Power-Delay Product (PDP)
*
* Language       : SystemVerilog
* Target Tech    : 90 nm Standard Cell Library
****************************************************************************************/

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