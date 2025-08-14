//======================================================================
//  File       : systolic_array_tb.sv
//  Author     : Abdelrahman Osama
//  Created On : 2025-07-25
//  Description: Parameterized self checking systolic array testbench
//               for matrix multiplication.
//
//  Parameters :
//    - DATAWIDTH : Bit width of each matrix element (signed).
//    - N_SIZE    : Size of the square matrices (NxN).
//
//  Test Cases:
//    - Three test cases are provided: 3×3, 4×4, and 5×5. The 5×5 case is enabled by default.
//    - To run a different test, change N_SIZE then comment out the 5×5 configuration and uncomment the desired one.
//
//  Notes:
//    - Ensure matrix A and B are streamed in synchronously.
//    - Output C matrix is streamed row by row when valid_out is high.
//    - error_count increments each time a mismatch is detected between the actual and expected output.
//
//======================================================================
module systolic_array_tb;

parameter N_SIZE = 5;
parameter DATAWIDTH = 16;
int       error_count = 0;

logic                             clk;
logic                             rst_n;
logic                             valid_in;
logic signed [(DATAWIDTH-1) :0]   matrix_a_in [(N_SIZE-1) :0];
logic signed [(DATAWIDTH-1) :0]   matrix_b_in [(N_SIZE-1) :0];
logic                             valid_out;
logic signed [(2*DATAWIDTH)-1 :0] matrix_c_out [(N_SIZE-1) :0];

systolic_array #(.DATAWIDTH(DATAWIDTH), .N_SIZE(N_SIZE)) DUT (
    .clk(clk),
    .rst_n(rst_n),
    .valid_in(valid_in),
    .matrix_a_in(matrix_a_in),
    .matrix_b_in(matrix_b_in),
    .valid_out(valid_out),
    .matrix_c_out(matrix_c_out)
);

// Clock generation
always #5 clk = ~clk;

// 3x3 Test Case
// // A
// logic signed [DATAWIDTH-1:0] A [0:N_SIZE-1][0:N_SIZE-1] = '{
//     '{  2, -1,  4 },  // row 0
//     '{  5,  2, -2 },  // row 1
//     '{ -4,  3,  0 }   // row 2
// };

// // B
// logic signed [DATAWIDTH-1:0] B [0:N_SIZE-1][0:N_SIZE-1] = '{
//     '{  3,  1, -2 },  // row 0
//     '{ -1,  2,  5 },  // row 1
//     '{  2,  3,  0 }   // row 2
// };

// // Expected output matrix
// logic signed [(2*DATAWIDTH)-1:0] expected_C [0:N_SIZE-1][0:N_SIZE-1] = '{
//     '{  15,  12,  -9 },  // row 0
//     '{   9,   3,   0 },  // row 1
//     '{ -15,   2,  23 }   // row 2
// };

/*------------------------------------------------------------*/

// 4x4 Test Case
// // A
// logic signed [DATAWIDTH-1:0] A [0:N_SIZE-1][0:N_SIZE-1] = '{
//     '{  1, -2,  3,  0 },  // row 0
//     '{ -1,  4,  0,  2 },  // row 1
//     '{  2,  1, -3, -1 },  // row 2
//     '{  0,  5, -2,  3 }   // row 3
// };

// // B
// logic signed [DATAWIDTH-1:0] B [0:N_SIZE-1][0:N_SIZE-1] = '{
//     '{  3,  1, -1,  2 },  // row 0
//     '{ -2,  0,  4,  1 },  // row 1
//     '{  1,  3,  0, -1 },  // row 2
//     '{  2, -3,  1,  0 }   // row 3
// };

// // Expected output matrix
// logic signed [(2*DATAWIDTH)-1:0] expected_C [0:N_SIZE-1][0:N_SIZE-1] = '{
//     '{  10,  10,  -9,  -3 },  // row 0
//     '{  -7,  -7,  19,   2 },  // row 1
//     '{  -1,  -4,   1,   8 },  // row 2
//     '{  -6, -15,  23,   7 }   // row 3
// };

/*------------------------------------------------------------*/

// 5x5 Test Case
// A
logic signed [DATAWIDTH-1:0] A [0:N_SIZE-1][0:N_SIZE-1] = '{
    '{  2, -1,  4,  0, -3 },  // row 0
    '{  5,  2, -2,  1,  0 },  // row 1
    '{ -4,  3,  0, -1,  2 },  // row 2
    '{  1, -5,  3,  2,  4 },  // row 3
    '{  0,  2, -3,  5, -1 }   // row 4
};

// B
logic signed [DATAWIDTH-1:0] B [0:N_SIZE-1][0:N_SIZE-1] = '{
    '{  3,  1, -2,  4,  0 },  // row 0
    '{ -1,  2,  5,  0,  3 },  // row 1
    '{  2,  3,  0, -1,  1 },  // row 2
    '{  4,  0,  1,  2, -2 },  // row 3
    '{  0, -3,  2,  1,  5 }   // row 4
};

// Expected output matrix
logic signed [(2*DATAWIDTH)-1:0] expected_C [0:N_SIZE-1][0:N_SIZE-1] = '{
    '{  15,  21, -15,   1, -14 },  // row 0
    '{  13,   3,   1,  24,   2 },  // row 1
    '{ -19,  -4,  26, -16,  21 },  // row 2
    '{  22, -12, -17,   9,   4 },  // row 3
    '{  12,  -2,  13,  12, -12 }   // row 4
};

// Test Stimulus
initial begin
    // Initialize signals to 0 and reset the system
    clk = 0;
    rst_n = 0;
    valid_in = 0;

    for (int i = 0; i < N_SIZE; i++) begin
        matrix_a_in[i] = 'b0;
        matrix_b_in[i] = 'b0;
    end

    @(posedge clk); 
    rst_n = 1;
 
    for (int cycle = 0; cycle < N_SIZE; cycle++) begin
        @(posedge clk);
        valid_in = 1;

        for (int i = 0; i < N_SIZE; i++) begin
            matrix_a_in[i] = A[i][cycle];   // column cycle of A
            matrix_b_in[i] = B[cycle][i];   // row cycle of B
        end
    end

    // Deasserting the valid_in signal after all inputs are injected
    @(posedge clk);
    valid_in = 1'b0;

    for (int i = 0; i < N_SIZE; i++) begin
        matrix_a_in[i] = 'b0;
        matrix_b_in[i] = 'b0;
    end

    // Self checking mechanism
    wait(valid_out);
    $display("=========================================");
    for (int row = 0; row < N_SIZE; row++) begin
        @(negedge clk);
        for (int col = 0; col < N_SIZE; col++) begin
            if (matrix_c_out[col] !== expected_C[row][col]) begin
                $error("Row %0d, Col %0d: Expected %0d, Got %0d", 
                    row, col, expected_C[row][col], matrix_c_out[col]);
                error_count++;
            end
        end
        if (error_count == 0)
            $display("Row %0d matches the expected row", row);
    end

    if (error_count == 0)
        $display("All elements match the expected output");

    $display("=========================================");
    repeat (3) @(posedge clk);
    $stop;
end

endmodule 