module spi_tb();
	reg MOSI, SS_n, clk, rst_n;
	wire MISO;

	spi dut(.MOSI(MOSI), .SS_n(SS_n), .clk(clk), .rst_n(rst_n), .MISO(MISO));

	initial begin
		clk = 0;
		forever
			#1 clk = ~clk;
	end

	initial begin
		//Reseting
		$readmemh("mem.dat", dut.mem.mem);
		rst_n = 0;
		SS_n = 1;
		@(negedge clk);
		rst_n = 1;

		//Writing address
		SS_n = 0;
		MOSI = 0;
		repeat(11) @(negedge clk);
		MOSI = 1;
		SS_n = 1;
		@(negedge clk);

		//Writing data
		SS_n = 0;
		MOSI = 0;
		@(negedge clk);
		@(negedge clk);
		@(negedge clk);
		MOSI = 1;
		repeat(8) @(negedge clk);
		MOSI = 0;
		SS_n = 1;
		@(negedge clk);
		
		//Reading address
		SS_n = 0;
		MOSI = 1;
		@(negedge clk);
		@(negedge clk);
		@(negedge clk);
		MOSI = 0;
		repeat(8) @(negedge clk);
		MOSI = 1;
		SS_n = 1;
		@(negedge clk);

		//Reading data
		SS_n = 0;
		MOSI = 1;
		@(negedge clk);
		@(negedge clk);
		repeat(17) @(negedge clk);
		//Ending comm.
		SS_n = 1;
		repeat(5) @(negedge clk);
		$stop;
	end
endmodule