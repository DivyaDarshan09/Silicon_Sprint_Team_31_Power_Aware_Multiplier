module wallace_3(
    input  logic [31:0] s3,c3,s4,c4,
    output logic [31:0] s5,
    output logic [31:0] c5,
    output logic [31:0] r0
);

genvar i;

generate
for(i=0;i<32;i++) begin

    full_adder FA4(s3[i],c3[i],s4[i],s5[i],c5[i]);
    assign r0[i] = c4[i];

end
endgenerate

endmodule