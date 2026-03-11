/****************************************************************************************
* Project        : Silicon Sprint Hackathon 2026
* Problem        : Power-Aware 16-bit Multiplier Architecture
*
* Event          : Silicon Sprint
* Organized by   : Mindgrove Technologies
* In collaboration with : SRM Institute of Science and Technology
* Date           : March 10–11, 2026
*
* Team           : Silicon Sprint - Team 31
*
* Description    :
* This project implements multiple 16-bit multiplier architectures optimized
* for low Power-Delay Product (PDP). The goal is to design an energy-efficient
* integer multiplier suitable for DSP and accelerator-based applications.
*
* Architectures Implemented :
*  - Radix-4 Booth Multiplier
*  - Wallace Tree Multiplier
*  - Radix-4 Booth + Wallace Tree
*  - Pipelined Radix-4 Booth + Wallace Multiplier
*
* Module Name    : booth_preencode
*
* Module Function:
* This module performs Booth pre-encoding by examining three bits of the
* multiplier (y2, y1, y0). It detects the cases where the partial product
* should be zero (000 or 111), which helps reduce unnecessary partial
* product generation in the Radix-4 Booth multiplication algorithm.
*
* Author(s)      : Team 31
* Language       : SystemVerilog
* Target Tech    : Standard Cell Library (90nm)
****************************************************************************************/

module booth_preencode (
    input  logic y2,
    input  logic y1,
    input  logic y0,
    output logic zero
);

assign zero = (~y2 & ~y1 & ~y0) | (y2 & y1 & y0);

endmodule

