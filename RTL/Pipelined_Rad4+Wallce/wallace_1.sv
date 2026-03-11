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