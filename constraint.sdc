# 100 MHz clock constraint (10.0 ns period)
create_clock -name clk -period 10.0 [get_ports clk]

set_input_delay -clock clk 2.0 [get_ports {rst_n enable opcode* operand_a* operand_b*}]
set_output_delay -clock clk 2.0 [get_ports {result* zero overflow}]
