
module BCD_ADDER(a,b,selection,final_sum,final_carry);
	input [3:0] a,b;
	input selection;
	output [3:0] final_sum;
	output final_carry;
	wire c_out,checker,c;
	wire [3:0] sum,second_4bit;
	assign {c_out,sum} = a+b+selection;
	assign checker = (sum[1] & sum[3]) | (sum[2]&sum[3]) | c_out;
	assign second_4bit[3] = 0;
	assign second_4bit[2] = checker;
	assign second_4bit[1] = checker;
	assign second_4bit[0] = 0;
	assign {c,final_sum} = sum + second_4bit;
	assign final_carry = checker;
endmodule	 


module BCD_ADDER_SUBTRACTOR(a,b,mode,final_sum,final_carry);
	input [3:0] a,b;
	input mode;
	output [3:0] final_sum;
	output final_carry;
	wire [3:0] nine_complement, mux_out; 
	NINE_COMP(b, nine_complement);
	QUADMUX21(b, nine_complement ,mode,mux_out); 
	BCD_ADDER(a,mux_out,mode,final_sum,final_carry);
endmodule		   


module QUADMUX21(a,b,mode,c);
	input [3:0] a,b;
	input mode;
	output [3:0]c;
	reg [3:0] c;
	always @(*)begin
		if (mode == 0) c =a;
		else c = b;
	end
endmodule	


module NINE_COMP(a, b);
	input [3:0] a;
	output [3:0] b;
	assign b[3] = ~a[3] & ~a[2] & ~a[1];
	assign b[2] = a[2] ^ a[1];
	assign b[1] = a[1];
	assign b[0] = ~a[0];
endmodule