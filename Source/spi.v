module spi(MOSI, SS_n, clk, rst_n, MISO);
	input MOSI, SS_n, clk, rst_n;
	output MISO;

	wire [9:0] rx_data;
	wire rx_valid, tx_valid;
	wire [7:0] tx_data;

	spi_slave_interface slave(.MOSI(MOSI), .SS_n(SS_n), .tx_data(tx_data), .tx_valid(tx_valid), .clk(clk), .rst_n(rst_n), .MISO(MISO), .rx_data(rx_data), .rx_valid(rx_valid));
	ram mem(.din(rx_data), .rx_valid(rx_valid), .clk(clk), .rst_n(rst_n), .dout(tx_data), .tx_valid(tx_valid));
endmodule