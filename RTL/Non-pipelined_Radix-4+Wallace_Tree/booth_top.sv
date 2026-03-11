/****************************************************************************************
* Project        : Silicon Sprint Hackathon 2026
* Problem        : Power-Aware 16-bit Multiplier Design
*
* Event          : Silicon Sprint Hackathon
* Organized by   : Mindgrove Technologies
* In collaboration with : SRM Institute of Science and Technology
* Date           : March 10–11, 2026
*
* Team           : Silicon Sprint - Team 31
*
* Description :
* This project implements different multiplier architectures optimized for
* low Power-Delay Product (PDP). The Radix-4 Booth multiplier reduces the
* number of generated partial products and improves multiplication efficiency.
*
* Module Name    : booth_top
*
* Module Function :
* This is the top-level module implementing a parameterized N-bit signed
* Radix-4 Booth multiplier. The module performs the following operations:
*
* 1. Booth Encoding of the multiplier bits (Y)
* 2. Partial Product Generation using the multiplicand (X)
* 3. Alignment of partial products through shifting
* 4. Accumulation of all partial products to produce the final product
*
* Architecture Flow :
*
*        X , Y
*          │
*          ▼
*   Radix-4 Booth Encoder
*          │
*          ▼
*   Partial Product Generator
*          │
*          ▼
*   Shifted Partial Products
*          │
*          ▼
*   Accumulation / Summation
*          │
*          ▼
*          P (2N-bit Product)
*
* Key Feature :
* Radix-4 Booth encoding reduces the number of partial products from N
* to N/2, leading to lower switching activity and improved power efficiency.
*
* Language       : SystemVerilog
* Target Tech    : 90 nm Standard Cell Library
****************************************************************************************/

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

