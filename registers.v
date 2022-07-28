module n_register(x, clk, y);
	parameter n = 4;
	input [n-1: 0] x;
	input clk;
	output reg [n-1: 0] y;
	always @ (posedge clk)
		y = x;
endmodule


module test_register;
	reg [9: 0] x;
	reg clk;
	wire [9: 0] y; 
	n_register #(10) g10(x, clk, y);	
	always #10ns clk = ~clk;
	initial 
		begin 
			clk = 1'b0;
			#00ns x = 10'b1000100010;
			#30ns x = 10'b1010100010;
			#30ns x = 10'b1110100010;
			#30ns x = 10'b1001111010; 
			#300ns $finish;
		end
endmodule