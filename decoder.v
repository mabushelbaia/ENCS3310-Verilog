module n_decoder(x, y);
	parameter n = 5;
	input [n-1:0] x;
	output y[2**n-1: 0];
	genvar i;	
	generate
		for (i =0; i < 2**n ; i = i + 1) begin : block_name
			assign y[i] = (x == i)? 1: 0; 
		end
	endgenerate
	
endmodule
module nmux_test;
	reg [3:0] TX;
	wire TY[2**4 - 1:0];
	n_decoder #(4) u5(TX, TY);
	initial
		begin		
			#00ns TX = 4'b0000;
			repeat(15)
			#10ns TX = TX + 4'b0001;
		end	 
		
endmodule