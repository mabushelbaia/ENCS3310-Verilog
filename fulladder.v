module full_adder(input a, b, c, output carry, sum);
	assign {carry, sum} = a + b + c;
endmodule

module test_bench;
	reg a, b, c;
	wire carry, sum;
	full_adder f01(a, b, c, carry, sum);	  
	initial 
		begin
			{a, b, c} = 3'b000;
			repeat(8)
			#10ns {a, b, c} = {a, b, c} + 3'b001;
		end
endmodule

		
			