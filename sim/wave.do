onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /systolic_array_tb/clk
add wave -noupdate -radix binary /systolic_array_tb/rst_n
add wave -noupdate -radix binary /systolic_array_tb/valid_in
add wave -noupdate /systolic_array_tb/DUT/valid_in_d
add wave -noupdate /systolic_array_tb/DUT/valid_in_rise
add wave -noupdate -radix unsigned /systolic_array_tb/DUT/cycle_count
add wave -noupdate -radix unsigned /systolic_array_tb/DUT/reg_idx
add wave -noupdate -radix decimal -childformat {{{/systolic_array_tb/matrix_a_in[4]} -radix decimal} {{/systolic_array_tb/matrix_a_in[3]} -radix decimal} {{/systolic_array_tb/matrix_a_in[2]} -radix decimal} {{/systolic_array_tb/matrix_a_in[1]} -radix decimal} {{/systolic_array_tb/matrix_a_in[0]} -radix decimal}} -subitemconfig {{/systolic_array_tb/matrix_a_in[4]} {-height 15 -radix decimal} {/systolic_array_tb/matrix_a_in[3]} {-height 15 -radix decimal} {/systolic_array_tb/matrix_a_in[2]} {-height 15 -radix decimal} {/systolic_array_tb/matrix_a_in[1]} {-height 15 -radix decimal} {/systolic_array_tb/matrix_a_in[0]} {-height 15 -radix decimal}} /systolic_array_tb/matrix_a_in
add wave -noupdate -radix decimal /systolic_array_tb/matrix_b_in
add wave -noupdate -radix decimal /systolic_array_tb/DUT/A_reg
add wave -noupdate -radix decimal /systolic_array_tb/DUT/B_reg
add wave -noupdate -divider Output
add wave -noupdate /systolic_array_tb/valid_out
add wave -noupdate -radix decimal {/systolic_array_tb/matrix_c_out[0]}
add wave -noupdate -radix decimal {/systolic_array_tb/matrix_c_out[1]}
add wave -noupdate -radix decimal {/systolic_array_tb/matrix_c_out[2]}
add wave -noupdate -radix decimal {/systolic_array_tb/matrix_c_out[3]}
add wave -noupdate -radix decimal {/systolic_array_tb/matrix_c_out[4]}
add wave -noupdate -divider R1
add wave -noupdate -radix decimal {/systolic_array_tb/DUT/partial_sum[0][0]}
add wave -noupdate -radix decimal {/systolic_array_tb/DUT/partial_sum[0][1]}
add wave -noupdate -radix decimal {/systolic_array_tb/DUT/partial_sum[0][2]}
add wave -noupdate -radix decimal {/systolic_array_tb/DUT/partial_sum[0][3]}
add wave -noupdate -radix decimal {/systolic_array_tb/DUT/partial_sum[0][4]}
add wave -noupdate -divider R2
add wave -noupdate -radix decimal {/systolic_array_tb/DUT/partial_sum[1][0]}
add wave -noupdate -radix decimal {/systolic_array_tb/DUT/partial_sum[1][1]}
add wave -noupdate -radix decimal {/systolic_array_tb/DUT/partial_sum[1][2]}
add wave -noupdate -radix decimal {/systolic_array_tb/DUT/partial_sum[1][3]}
add wave -noupdate -radix decimal {/systolic_array_tb/DUT/partial_sum[1][4]}
add wave -noupdate -divider R3
add wave -noupdate -radix decimal {/systolic_array_tb/DUT/partial_sum[2][0]}
add wave -noupdate -radix decimal {/systolic_array_tb/DUT/partial_sum[2][1]}
add wave -noupdate -radix decimal {/systolic_array_tb/DUT/partial_sum[2][2]}
add wave -noupdate -radix decimal {/systolic_array_tb/DUT/partial_sum[2][3]}
add wave -noupdate -radix decimal {/systolic_array_tb/DUT/partial_sum[2][4]}
add wave -noupdate -divider R4
add wave -noupdate -radix decimal {/systolic_array_tb/DUT/partial_sum[3][0]}
add wave -noupdate -radix decimal {/systolic_array_tb/DUT/partial_sum[3][1]}
add wave -noupdate -radix decimal {/systolic_array_tb/DUT/partial_sum[3][2]}
add wave -noupdate -radix decimal {/systolic_array_tb/DUT/partial_sum[3][3]}
add wave -noupdate -radix decimal {/systolic_array_tb/DUT/partial_sum[3][4]}
add wave -noupdate -divider R5
add wave -noupdate -radix decimal {/systolic_array_tb/DUT/partial_sum[4][0]}
add wave -noupdate -radix decimal {/systolic_array_tb/DUT/partial_sum[4][1]}
add wave -noupdate -radix decimal {/systolic_array_tb/DUT/partial_sum[4][2]}
add wave -noupdate -radix decimal {/systolic_array_tb/DUT/partial_sum[4][3]}
add wave -noupdate -radix decimal {/systolic_array_tb/DUT/partial_sum[4][4]}
add wave -noupdate -divider Counters
add wave -noupdate -radix unsigned /systolic_array_tb/DUT/counter
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {15 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 126
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {163 ns}
