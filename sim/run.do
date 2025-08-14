vlib work   

transcript file ./transcript.log

vlog -sv ../rtl/systolic_array.sv

vlog -sv systolic_array_tb.sv

vsim -voptargs=+acc work.systolic_array_tb

do wave.do

run -all