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
* This project explores different multiplier architectures optimized for
* low Power-Delay Product (PDP). The implemented architectures include
* Radix-4 Booth, Wallace Tree, and pipelined Booth-Wallace multipliers.
*
* Module Name : booth_encoder
*
* Module Function :
* This module implements the Radix-4 Booth encoding logic. It examines
* three bits of the multiplier (y2, y1, y0) and generates control signals
* used for partial product generation:
*
*   neg  -> Indicates whether the generated partial product should be negative
*   one  -> Selects multiplication by X
*   two  -> Selects multiplication by 2X
*
* These control signals are later used by the partial product generator
* to create the required signed partial products for Booth multiplication.
*
* Language       : SystemVerilog
* Target Tech    : 90nm Standard Cell Library
****************************************************************************************/

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
