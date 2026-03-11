module wallace_2(
    input  logic [31:0] s0,c0,s1,c1,s2,c2,
    output logic [31:0] s3,s4,
    output logic [31:0] c3,c4
);

genvar i;

generate
for(i=0;i<32;i++) begin

    full_adder FA2(s0[i],c0[i],s1[i],s3[i],c3[i]);
    full_adder FA3(c1[i],s2[i],c2[i],s4[i],c4[i]);

end
endgenerate

endmodule