/****************************************************************************************
* Module Name    : wallace_4
*
* Module Function :
* This module performs the final compression stage of the Wallace Tree.
* It combines the remaining intermediate rows to produce the final
* two rows (sum and carry) before the final carry-propagate addition.
*
* Inputs :
*   s5, c5, r0 → Reduced intermediate rows from previous stage
*
* Output :
*   sum   → Final sum row
*   carry → Final carry row
*
* These two rows are typically fed into a final adder (Ripple, CLA,
* or parallel prefix adder) to produce the final multiplier result.
****************************************************************************************/

module wallace_4(
    input  logic [31:0] s5,c5,r0,
    output logic [31:0] sum,
    output logic [31:0] carry
);

genvar i;

generate
for(i=0;i<32;i++) begin

    full_adder FA5(s5[i],c5[i],r0[i],sum[i],carry[i]);

end
endgenerate

endmodule