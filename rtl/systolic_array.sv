//======================================================================
//  File       : systolic_array.sv
//  Author     : Abdelrahman Osama
//  Created On : 2025-07-25
//  Description: Parameterized systolic array module for matrix
//               multiplication.
//
//  Parameters :
//    - DATAWIDTH : Bit width of each matrix element (signed).
//    - N_SIZE    : Size of the square matrices (NxN).
//
//  Inputs :
//    - clk             : Clock signal.
//    - rst_n           : Active-low reset signal.
//    - valid_in        : Signal to indicate data on the bus is valid to sample.
//    - matrix_a_in[N]  : One column of matrix A per cycle.
//    - matrix_b_in[N]  : One row of matrix B per cycle.
//
//  Outputs :
//    - valid_out       : Asserted when output C row is valid to be sampled.
//    - matrix_c_out[N] : One row of result matrix C per cycle.
//
//  Timing Info:
//    - MAC phase duration      : N_SIZE + 2 cycles
//    - Output start cycle      : (2 * N_SIZE) - 1
//    - Output complete by      : (3 * N_SIZE) - 1
//
//======================================================================
module systolic_array #(
    parameter DATAWIDTH = 16,
    parameter N_SIZE = 5
)(
    input  logic                             clk,
    input  logic                             rst_n,
    input  logic                             valid_in,
    input  logic signed [(DATAWIDTH-1) :0]   matrix_a_in [(N_SIZE-1) :0],
    input  logic signed [(DATAWIDTH-1) :0]   matrix_b_in [(N_SIZE-1) :0],

    output logic                             valid_out,
    output logic signed [(2*DATAWIDTH)-1 :0] matrix_c_out [(N_SIZE-1) :0]
);

// Parameters
localparam MAC_PHASE_CYCLES  = N_SIZE + 2;
localparam VALID_OUT_START   = (2 * N_SIZE) - 1;
localparam TOTAL_CYCLES      = (3 * N_SIZE) - 1;

// Internal data flow registers
logic signed [(DATAWIDTH-1) :0] A_reg [(N_SIZE-1) :0][(N_SIZE-1) :0];
logic signed [(DATAWIDTH-1) :0] B_reg [(N_SIZE-1) :0][(N_SIZE-1) :0];

// MAC accumulation buffer
logic signed [(DATAWIDTH*2)-1 :0] partial_sum [(N_SIZE-1) :0][(N_SIZE-1) :0];

// Counters
logic [$clog2(4*N_SIZE) :0] cycle_count, reg_idx, counter;

// Delayed valid in & edge detection for reg_idx
logic valid_in_d, valid_in_rise;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        valid_in_d <= 1'b0;
    else
        valid_in_d <= valid_in;
end

assign valid_in_rise = valid_in & ~valid_in_d;

// Main counter
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        counter <= 'b0;
    else if (counter < TOTAL_CYCLES) // the needed time to compute and output the entire C matrix 
        counter <= counter + 'b1;
end

// Fill A_reg & B_reg with the inputs
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cycle_count <= 'b0;
        for (int i = 0; i < N_SIZE; i++) begin
            for (int j = 0; j < N_SIZE; j++) begin
                A_reg[i][j] <= 'b0;
                B_reg[i][j] <= 'b0;
            end
        end
    end else if (valid_in && cycle_count < N_SIZE) begin
        for (int row = 0; row < N_SIZE; row++)
            A_reg[row][cycle_count] <= matrix_a_in[row];

        for (int col = 0; col < N_SIZE; col++)
            B_reg[cycle_count][col] <= matrix_b_in[col];

        cycle_count <= cycle_count + 'b1;
    end
end

// Systolic array accumlation logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg_idx <= 'b0;
        for (int i = 0; i < N_SIZE; i++) begin
            for (int j = 0; j < N_SIZE; j++) begin
                partial_sum[i][j] <= 'b0;
            end
        end
    end else begin
        // Perform MAC operations for all cells.
        // cell [0][0] is updated separately using direct matrix inputs.
        // This block runs only during the MAC phase (counter < MAC_PHASE_CYCLES).
        if (counter < MAC_PHASE_CYCLES) begin
            partial_sum[0][0] <= partial_sum[0][0] + (matrix_a_in[0] * matrix_b_in[0]);
            for (int row = 0; row < N_SIZE; row++) begin
                for (int col = 0; col < N_SIZE; col++) begin
                    // Skip partial_sum[0][0]
                    if (!(row == 0 && col == 0)) begin
                        partial_sum[row][col] <= partial_sum[row][col] + (A_reg[row][reg_idx] * B_reg[reg_idx][col]);
                    end
                end
            end
        end

        // the edge detector pulse helps in synchronizing the reg_idx signal to access A_reg & B_reg
        if (valid_in_rise)
            reg_idx <= 'b0;
        else if (reg_idx < (N_SIZE-1))
            reg_idx <= reg_idx + 'b1;
    end
end

// Output the C matrix and valid_out logic
always_comb begin
    // valid_out is asserted when the first row is done computing and deasserted when the last row is outputted
    valid_out = (counter >= VALID_OUT_START && counter < TOTAL_CYCLES) ? 1'b1 : 1'b0;
    
    // when valid_out is asserted, output 3 elements from partial_sum (representing a row) each clock cycle
    for (int i = 0; i < N_SIZE; i++) begin
        matrix_c_out[i] = valid_out ? partial_sum[counter - VALID_OUT_START][i] : 'b0;
    end
end

endmodule 