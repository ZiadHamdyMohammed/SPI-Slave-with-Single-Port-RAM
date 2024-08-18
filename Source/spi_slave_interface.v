module spi_slave_interface(MOSI, SS_n, tx_data, tx_valid, clk, rst_n, MISO, rx_data, rx_valid);
	parameter IDLE = 3'b000, CHK_CMD = 3'b001, WRITE = 3'b010, READ_ADD = 3'b011, READ_DATA = 3'b100;
	input MOSI, SS_n, tx_valid, clk, rst_n;
	input [7:0] tx_data;
	output reg MISO, rx_valid;
	output reg [9:0] rx_data;

	(* fsm_encoding = "one_hot" *)
	reg [2:0] cs, ns;
	reg read;
	reg [3:0] counter;

	//State memory
	always @(posedge clk) begin
		if(~rst_n) begin
			cs <= IDLE;
		end
		else begin
			cs <= ns;
		end
	end

	//Next state logic
	always @(cs or SS_n) begin
		case(cs)
			IDLE:
				if(SS_n) begin
					ns = IDLE;
				end
				else begin
					ns = CHK_CMD;
				end
			CHK_CMD:
				if(SS_n) begin
					ns = IDLE;
				end
				else if(~SS_n && MOSI && ~read) begin
					ns = READ_ADD;
				end
				else if(~SS_n && MOSI && read) begin
					ns = READ_DATA;
				end
				else begin
					ns = WRITE;
				end
			READ_ADD:
				if(SS_n) begin
					ns = IDLE;
				end
				else begin
					ns = READ_ADD;
				end
			READ_DATA:
				if(SS_n) begin
					ns = IDLE;
				end
				else begin
					ns = READ_DATA;
				end
			WRITE:
				if(SS_n) begin
					ns = IDLE;
				end
				else begin
					ns = WRITE;
				end
			default: ns = IDLE;
		endcase
	end

	//Output logic
	always @(posedge clk) begin
		if(~rst_n) begin
			read <= 0;
			MISO <= 0;
			rx_valid <= 0;
			rx_data <= 0;
			counter <= 9;
		end
		else begin
			if(cs == WRITE) begin
				rx_valid <= 0;
				rx_data[counter] <= MOSI;
				counter <= counter -1;
				if(counter == 4'b0000) begin
					rx_valid <= 1;
					counter <= 9;
				end
			end
			else if(cs == READ_ADD) begin
				rx_valid <= 0;
				rx_data[counter] <= MOSI;
				counter <= counter -1;
				if(counter == 4'b0000) begin
					rx_valid <= 1;
					counter <= 9;
					read <= 1;
				end
			end
			else if(cs == READ_DATA) begin
				if(tx_valid) begin
					MISO <= tx_data[counter];
					counter <= counter -1;
					if(counter == 4'b0000) begin
						counter <= 9;
					end
				end
				else begin
					rx_valid <= 0;
					rx_data[counter] <= MOSI;
					counter <= counter -1;
					if(counter == 4'b0000) begin
						rx_valid <= 1;
						counter <= 7;
						read <= 0;
					end
				end
			end
		end
	end
endmodule