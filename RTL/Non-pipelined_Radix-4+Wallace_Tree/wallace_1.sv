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
* Module Name    : wallace_1
*
* Module Function :
* This module implements the first reduction stage of the Wallace Tree.
* It compresses eight partial products into fewer intermediate rows using
* full adders and half adders.
*
* Reduction Performed :
*   pp0, pp1, pp2 → Full Adder → s0, c0
*   pp3, pp4, pp5 → Full Adder → s1, c1
*   pp6, pp7      → Half Adder → s2, c2
*
* Wallace Tree Concept :
* The Wallace tree reduces the number of partial product rows by
* performing carry-save addition in parallel. This significantly
* reduces the critical path delay compared to sequential addition.
*
* Language       : SystemVerilog
* Target Tech    : 90 nm Standard Cell Library
****************************************************************************************/

module wallace_1(
    input  logic [31:0] pp0,pp1,pp2,pp3,pp4,pp5,pp6,pp7,
    output logic [31:0] s0,s1,s2,
    output logic [31:0] c0,c1,c2
);

genvar i;

generate
for(i=0;i<32;i++) begin

    full_adder FA0(pp0[i],pp1[i],pp2[i],s0[i],c0[i]);
    full_adder FA1(pp3[i],pp4[i],pp5[i],s1[i],c1[i]);
    half_adder HA0(pp6[i],pp7[i],s2[i],c2[i]);

end
endgenerate

endmodule