module ram(din, rx_valid, clk, rst_n, dout, tx_valid);
	parameter MEM_DEPTH = 256, ADDR_SIZE = 8;
	input [9:0] din;
	input rx_valid, clk, rst_n;
	output reg [7:0] dout;
	output reg tx_valid;

	reg [7:0] mem [MEM_DEPTH-1:0];
	reg [ADDR_SIZE-1:0] write_addr, read_addr;

	always @(*) begin
		if(~rst_n) begin
			dout <= 0;
			tx_valid <= 0;
			write_addr <= 0;
			read_addr <= 0;
		end
		else begin
			if(rx_valid) begin
				if(din[9:8] == 2'b00) begin
					write_addr <= din[7:0];
					tx_valid <= 0;
				end
				else if(din[9:8] == 2'b01) begin
					mem[write_addr] <= din[7:0];
					tx_valid <= 0;
				end
				else if(din[9:8] == 2'b10) begin
					read_addr <= din[7:0];
					tx_valid <= 0;
				end
				else if (din[9:8] == 2'b11) begin
					dout <= mem[read_addr];
					tx_valid <= 1;
				end
			end
		end
	end
endmodule