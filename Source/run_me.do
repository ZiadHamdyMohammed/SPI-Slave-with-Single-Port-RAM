vlib work
vlog ram.v spi_slave_interface.v spi.v spi_tb.v
vsim -voptargs=+acc work.spi_tb
add wave -color yellow clk
add wave rst_n
add wave SS_n
add wave MOSI
add wave MISO
add wave dut.slave.cs
add wave dut.rx_valid
add wave -radix binary dut.rx_data
add wave dut.tx_valid
add wave -radix binary dut.tx_data
add wave -radix binary dut.mem.write_addr
add wave -radix binary dut.mem.read_addr
add wave -radix binary dut.mem.din
add wave -radix binary dut.mem.mem
add wave dut.slave.counter
config wave -signalnamewidth 1
run -all