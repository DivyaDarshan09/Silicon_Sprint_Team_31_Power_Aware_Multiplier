
`timescale 1ns/1ps

module tb_basic_pipeline;

parameter N = 16;
parameter PIPELINE_DELAY = 3;

logic clk;
logic rst;

logic signed [N-1:0] X;
logic signed [N-1:0] Y;
logic signed [2*N-1:0] P;

logic signed [2*N-1:0] golden_queue [0:PIPELINE_DELAY];
logic signed [N-1:0] X_queue [0:PIPELINE_DELAY];
logic signed [N-1:0] Y_queue [0:PIPELINE_DELAY];

integer errors;
integer i;
integer cycle;

//-------------------------------------------
// VCD Dump
//-------------------------------------------
initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, tb_basic_pipeline);
end

//-------------------------------------------
// Clock generation (500 MHz)
//-------------------------------------------
initial clk = 0;
always #1 clk = ~clk;

//-------------------------------------------
// DUT
//-------------------------------------------
R4_Wallace_pipeline #(.N(N)) dut (
    .clk(clk),
    .rst(rst),
    .X(X),
    .Y(Y),
    .P(P)
);

//-------------------------------------------
// Queue shift every clock
//-------------------------------------------
always @(posedge clk) begin
    if(rst) begin
        for(i=0;i<=PIPELINE_DELAY;i=i+1) begin
            golden_queue[i] <= 0;
            X_queue[i] <= 0;
            Y_queue[i] <= 0;
        end
    end
    else begin
        for(i=PIPELINE_DELAY;i>0;i=i-1) begin
            golden_queue[i] <= golden_queue[i-1];
            X_queue[i] <= X_queue[i-1];
            Y_queue[i] <= Y_queue[i-1];
        end
    end
end

//-------------------------------------------
// Apply stimulus
//-------------------------------------------
task run_test(input signed [N-1:0] a,
              input signed [N-1:0] b);
begin

    @(posedge clk);

    X <= a;
    Y <= b;

    golden_queue[0] <= a * b;
    X_queue[0] <= a;
    Y_queue[0] <= b;

    if(cycle >= PIPELINE_DELAY) begin
        if(P !== golden_queue[PIPELINE_DELAY]) begin
            $display("ERROR: X=%0d Y=%0d DUT=%0d EXPECTED=%0d",
                X_queue[PIPELINE_DELAY],
                Y_queue[PIPELINE_DELAY],
                P,
                golden_queue[PIPELINE_DELAY]);
            errors++;
        end
        else begin
            $display("PASS: X=%0d Y=%0d P=%0d",
                X_queue[PIPELINE_DELAY],
                Y_queue[PIPELINE_DELAY],
                P);
        end
    end

    cycle++;

end
endtask

//-------------------------------------------
// Tests
//-------------------------------------------
initial begin

    errors = 0;
    cycle = 0;

    rst = 1;
    X = 0;
    Y = 0;

    repeat(4) @(posedge clk);
    rst = 0;

    $display("Starting pipeline multiplier tests");

    run_test(25,10);
    run_test(-20,-5);
    run_test(30,-7);
    run_test(-15,12);

    run_test(0,45);
    run_test(0,-33);
    run_test(99,0);
    run_test(-88,0);

    run_test(32767,32767);
    run_test(-32767,-32767);
    run_test(32767,-32767);

    //---------------------------------------
    // Flush pipeline
    //---------------------------------------

    repeat(PIPELINE_DELAY) begin
        @(posedge clk);

        if(P !== golden_queue[PIPELINE_DELAY]) begin
            $display("ERROR: X=%0d Y=%0d DUT=%0d EXPECTED=%0d",
                X_queue[PIPELINE_DELAY],
                Y_queue[PIPELINE_DELAY],
                P,
                golden_queue[PIPELINE_DELAY]);
            errors++;
        end
        else begin
            $display("PASS: X=%0d Y=%0d P=%0d",
                X_queue[PIPELINE_DELAY],
                Y_queue[PIPELINE_DELAY],
                P);
        end
    end

    //---------------------------------------

    if(errors==0)
        $display("ALL TESTS PASSED");
    else
        $display("TOTAL ERRORS = %0d", errors);

    $finish;

end

endmodule
