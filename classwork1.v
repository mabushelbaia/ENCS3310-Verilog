

module dcdr24(input x, y, en, output d0, d1, d2, d3);
	assign d0 = en & ~x & ~y;  
	assign d1 = en & ~x & y;
	assign d2 = en & x & ~y;
	assign d3 = en & x & y;	
endmodule  


module dcdr38(input x, y, z, output d0, d1, d2, d3, d4, d5, d6, d7);   
	dcdr24 u1 (x, y, ~z, d0, d1, d2, d3);
	dcdr24 u2 (x, y, z, d4, d5, d6, d7);
	
endmodule				 



module mux_test1;
	reg x, y, en;
	wire d0, d1, d2, d3;
	dcdr24 u4 (x, y, en, d0, d1, d2, d3);
	initial
		begin
			{en, x, y} = 3'b000;
			repeat(7)
			#10ns {en, x, y} = {en, x, y} + 3'b001;
		end
		
endmodule


module mux_test;
	reg TX, TY, TZ;
	wire d0, d1, d2, d3, d4, d5, d6, d7;
	dcdr38 u3(TX, TY, TZ, d0, d1, d2, d3, d4, d5, d6, d7);
	initial
		begin
			{TZ, TX, TY} = 3'b000;
			repeat(7)
			#10ns {TZ, TX, TY} = {TZ, TX, TY} + 3'b001;
		end	 
		
endmodule	 
