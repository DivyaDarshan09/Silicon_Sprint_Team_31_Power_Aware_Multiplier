module tb_booth_multiplier;

    parameter N = 16; 

    logic signed [N-1:0] multiplicand;
    logic signed [N-1:0] multiplier;
    logic signed [2*N-1:0] product;

    R4_Dadda #(N) uut (
        .X(multiplicand),
        .Y(multiplier),
        .P(product)
    );
initial begin
    $dumpfile("booth_top.vcd");
    $dumpvars(0,tb_booth_multiplier);
end

    initial begin
        $monitor("Multiplicand = %d, Multiplier = %d, Product = %d", multiplicand, multiplier, product);

        // Test case 1: 5 * 5
        multiplicand = 16'sd15;
        multiplier = -16'sd15;
        #200;  


        

        $finish;
    end

endmodule
