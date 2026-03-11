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