`timescale 1ns / 1ps

module test_cpu();
	
	reg reset   ;
	reg clk     ;
wire [11:0] digi;


	CPU cpu(
		reset,
		clk,
        digi
	);
	initial begin
		reset   = 1;
		clk     = 1;
		#100 reset = 0;
	end
	
	always #50 clk = ~clk;
		
endmodule
