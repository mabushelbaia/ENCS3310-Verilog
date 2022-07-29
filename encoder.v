module n_encoder(x, y);
	parameter n = 5;
	output reg [n-1:0] y;
	input [2**n-1: 0] x;
	integer i;	
	always @(*) 
		begin
		for (i = 0; i < 2**n - 1; i = i + 1)
			if (x[i]) 
			begin	
				y = i;
				break;
			end		
		end
endmodule
module nencoder_test;
	wire [2:0] TY;
	reg [2**3 - 1:0] TX;
	n_encoder #(4) u5(TX, TY);
	initial
		begin		
			#00ns TX = 8'b00000000;
			#10ns TX = 8'b00000001;
			repeat(7)
			#10ns TX = TX * 2;
		end	 
		
endmodule