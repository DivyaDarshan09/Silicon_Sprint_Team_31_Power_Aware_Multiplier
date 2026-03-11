`timescale 1ns/1ps

module tb_ex;

//-------------------------------------------
// Parameters
//-------------------------------------------
parameter N = 16;
parameter BATCH_SIZE = 256;  // number of parallel multiplications per cycle

//-------------------------------------------
// DUT inputs
//-------------------------------------------
logic signed [N-1:0] X_array [0:BATCH_SIZE-1];
logic signed [N-1:0] Y_array [0:BATCH_SIZE-1];
logic signed [2*N-1:0] P_array [0:BATCH_SIZE-1];  // DUT outputs

//-------------------------------------------
// DUT instantiation
//-------------------------------------------
genvar i;
generate
    for (i = 0; i < BATCH_SIZE; i = i + 1) begin : DUT_GEN
        booth_wallace_top #(.N(N)) dut_inst (
            .X(X_array[i]),
            .Y(Y_array[i]),
            .P(P_array[i])
        );
    end
endgenerate

//-------------------------------------------
// Testbench logic
//-------------------------------------------
integer x_idx, y_idx, batch_idx;
integer errors;
logic signed [2*N-1:0] golden;

initial begin
    errors = 0;

    $display("Starting exhaustive 16x16 signed multiplier verification...");

    // Sweep through signed 16-bit range in batches
    for (x_idx = -32767; x_idx <= 32767; x_idx = x_idx + BATCH_SIZE) begin
        for (y_idx = -32767; y_idx <= 32767; y_idx = y_idx + BATCH_SIZE) begin

            // Feed DUT inputs and check immediately
            for (batch_idx = 0; batch_idx < BATCH_SIZE; batch_idx = batch_idx + 1) begin
                X_array[batch_idx] = x_idx + batch_idx;
                Y_array[batch_idx] = y_idx + batch_idx;

                #1; // delta cycle for DUT to compute

                // Golden model
                golden = $signed(X_array[batch_idx]) * $signed(Y_array[batch_idx]);

                // Compare DUT output
                if (P_array[batch_idx] !== golden) begin
                    $display("ERROR: Step X=%0d Y=%0d --> DUT P=%0d Expected=%0d",
                             X_array[batch_idx],
                             Y_array[batch_idx],
                             P_array[batch_idx],
                             golden);
                    errors = errors + 1;
                end
            end

        end
    end

    if (errors == 0)
        $display("PASS: All multiplications matched!");
    else
        $display("FAIL: Total errors = %0d", errors);

    $finish;
end

endmodule