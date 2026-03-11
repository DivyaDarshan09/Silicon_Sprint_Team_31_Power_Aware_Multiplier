`timescale 1ns/1ps

module tb_R4_Wallace_pipeline;

parameter N = 16;

reg clk;
reg rst;
reg signed [N-1:0] X;
reg signed [N-1:0] Y;
wire signed [2*N-1:0] P;

reg signed [2*N-1:0] expected;

integer errors = 0;
integer i;

// Clock generation
initial clk = 0;
always #5 clk = ~clk; // 100 MHz

// DUT
R4_Wallace_pipeline #(.N(N)) dut (
    .clk(clk),
    .rst(rst),
    .X(X),
    .Y(Y),
    .P(P)
);

// Pipeline stage latency = 3 cycles
localparam PIPELINE_LATENCY = 3;

// Testcases arrays
reg signed [N-1:0] test_X [0:4];
reg signed [N-1:0] test_Y [0:4];
reg [100*8:1] test_desc [0:4]; // string workaround

initial begin
    // Reset
    rst = 1;
    X = 0; Y = 0;
    #20;
    rst = 0;

    // Define 5 important testcases
    test_X[0] = 32767; test_Y[0] =  32767; test_desc[0] = "Max positive x Max positive";
    test_X[1] = 32767; test_Y[1] = -32768; test_desc[1] = "Max positive x Max negative";
    test_X[2] = -32768; test_Y[2] = 32767; test_desc[2] = "Max negative x Max positive";
    test_X[3] = 12345;  test_Y[3] = -6789; test_desc[3] = "Random signed numbers";

    // Apply testcases
    for(i=0; i<4; i=i+1) begin
        @(negedge clk);
        X = test_X[i];
        Y = test_Y[i];
        expected = X * Y; // reference

        // Wait for pipeline latency
        repeat(PIPELINE_LATENCY) @(negedge clk);

        if(P !== expected) begin
            $display("ERROR: %s | X=%0d Y=%0d DUT P=%0d Expected=%0d",
                     test_desc[i], X, Y, P, expected);
            errors = errors + 1;
        end else begin
            $display("PASS : %s | X=%0d Y=%0d P=%0d",
                     test_desc[i], X, Y, P);
        end
    end

    $display("---------------------------------");
    if(errors == 0)
        $display("ALL TESTS PASSED");
    else
        $display("TOTAL ERRORS: %0d", errors);

    $finish;
end

endmodule