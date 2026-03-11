`timescale 1ns/1ps

module tb_basic;

parameter N = 16;

logic signed [N-1:0] X;
logic signed [N-1:0] Y;
logic signed [2*N-1:0] P;

logic signed [2*N-1:0] golden;
integer errors;

initial begin
    $dumpfile("waveform.vcd");   // name of VCD file
    $dumpvars(0, tb_basic);      // dump all signals in this module
end
//-------------------------------------------
// DUT
//-------------------------------------------
R4_Dadda #(.N(N)) dut (
    .X(X),
    .Y(Y),
    .P(P)
);

//-------------------------------------------
// Test task
//-------------------------------------------
task run_test(input signed [N-1:0] a, input signed [N-1:0] b);
begin
    X = a;
    Y = b;

    #1;

    golden = a * b;

    if (P === golden)
        $display("PASS: X=%0d  Y=%0d  P=%0d", a, b, P);
    else begin
        $display("ERROR: X=%0d  Y=%0d  DUT=%0d  EXPECTED=%0d", a, b, P, golden);
        errors = errors + 1;
    end
end
endtask

//-------------------------------------------
// Tests
//-------------------------------------------
initial begin
    errors = 0;

    $display("Starting basic multiplier tests");

    // positive × positive
    run_test(25, 10);

    // negative × negative
    run_test(-20, -5);

    // positive × negative
    run_test(30, -7);

    // negative × positive
    run_test(-15, 12);

    // zero × positive
    run_test(0, 45);

    // zero × negative
    run_test(0, -33);

    // positive × zero
    run_test(99, 0);

    // negative × zero
    run_test(-88, 0);

    // max positive values
    run_test(32767, 32767);

    // max negative values
    run_test(-32767, -32767);

    // max positive × max negative
    run_test(32767, -32767);

    //---------------------------------------

    if(errors == 0)
        $display("ALL TESTS PASSED");
    else
        $display("TOTAL ERRORS = %0d", errors);

    $finish;

end

endmodule